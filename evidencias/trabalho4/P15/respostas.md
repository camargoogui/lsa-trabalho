# P15 - Respostas

Grupo: guilherme | VM: lsa-guilherme | Responsável: Guilherme Paes Camargo (RM576842)

Todos os exemplos abaixo foram executados na própria VM.

## 1. Diferença entre `x` e `X` no chmod e por que o `X` é útil em operações recursivas

O `x` minúsculo liga a execução em tudo o que for alterado, seja arquivo ou diretório. O `X` maiúsculo só liga a execução em diretórios e em arquivos que já tenham execução para alguém. Em um `chmod -R`, isso permite dar acesso de travessia a todas as pastas sem transformar documentos comuns em executáveis.

Na VM usamos `chmod -R g+rwX,o-rwx grupos/redteam` (P04, alteração L4): os diretórios ganharam `x` para o grupo e os scripts, que ainda eram `644`, continuaram sem execução até o `chmod 0770` do P05. Exemplo isolado:

```
$ ls -lR /tmp/q1 | grep -v total
/tmp/q1:
-rw------- 1 root root  0 Nov  8 22:14 arquivo.txt
drw------- 2 root root 60 Nov  8 22:14 sub

/tmp/q1/sub:
-rw------- 1 root root 0 Nov  8 22:14 outro.txt
```
```
$ chmod -R g+rX /tmp/q1 && ls -ldR /tmp/q1 /tmp/q1/* /tmp/q1/sub/* | awk '{print $1, $NF}'
drwxr-x--- /tmp/q1
-rw-r----- /tmp/q1/arquivo.txt
drw-r-x--- /tmp/q1/sub
-rw-r----- /tmp/q1/sub/outro.txt
```

O diretório `sub` recebeu `x` e os arquivos `.txt` não. Com `g+rx` minúsculo, os dois arquivos virariam executáveis sem motivo.

## 2. O que cada bit (r, w, x) permite em um diretório e a combinação da ouvidoria

Em um diretório, `r` permite listar os nomes das entradas, `w` permite criar, apagar e renomear entradas (sempre junto com `x`) e `x` permite atravessar o diretório, ou seja, acessar um arquivo pelo nome e entrar nele com `cd`.

Na ouvidoria o grupo `orion` tem `-wx`: o colaborador entra e cria o arquivo pelo nome (`w` + `x`), mas sem `r` não consegue listar o que existe lá. A auditoria recebeu `r-x` por ACL, então lista e lê. O sticky bit impede que alguém apague depósito alheio e a ACL padrão faz o arquivo novo nascer sem leitura para o grupo e para outros, só para a auditoria (e o svc-backup):

```
$ ls -ld empresa/ouvidoria; getfacl -p --omit-header empresa/ouvidoria
drwxrwx--T+ 2 root orion 4096 Nov  8 22:14 empresa/ouvidoria
user::rwx
user:svc-backup:r-x
group::-wx
group:auditoria:r-x
mask::rwx
other::---
default:user::rwx
default:user:svc-backup:r-x
default:group::---
default:group:auditoria:r-x
default:mask::r-x
default:other::---

```

## 3. Efeito do sticky bit e diferença entre `t` e `T`

Com o sticky bit em um diretório, mesmo quem tem `w` no diretório só consegue apagar ou renomear arquivos dos quais é dono (o dono do diretório e o root também podem). Sem ele, quem tem `w` no diretório apaga qualquer arquivo, de qualquer dono.

Na listagem, `t` minúsculo indica sticky bit com execução para outros, e `T` maiúsculo indica sticky bit sem execução para outros. Na VM, `publico/troca` (1777) mostra `t` porque outros têm `x`, e `empresa/ouvidoria` (1730) mostra `T` porque outros não têm acesso:

```
$ ls -ld publico/troca empresa/ouvidoria
drwxrwx--T+ 2 root orion 4096 Nov  8 22:14 empresa/ouvidoria
drwxrwxrwt+ 2 root root  4096 Nov  8 22:14 publico/troca
```

## 4. Como o SGID em diretório e a umask trabalham juntos na colaboração

O SGID em um diretório faz todo arquivo novo pertencer ao grupo do diretório, e não ao grupo primário de quem criou. A umask define quais permissões o arquivo novo não recebe. Com SGID no `grupos/soc` e umask `007` para o grupo `orion`, um arquivo criado pela asouza nasce com grupo `soc` e com `rw` para o grupo, então o blima consegue editar.

Se faltar o SGID, o arquivo fica com o grupo primário de quem criou (por exemplo `asouza`), e o outro membro do soc cai em "outros", sem acesso. Se faltar a umask adequada (por exemplo a padrão `022`), o arquivo até fica com o grupo certo, mas nasce `rw-r--r--`: o colega só lê e não consegue editar, e ainda sobra leitura para outros. Nos diretórios que também têm ACL padrão, a ACL padrão substitui a umask na hora de calcular o modo, por isso incluímos `default:group::rwx` neles.

```
$ ls -ld grupos/soc; su - asouza -c 'umask; touch teste-sgid.txt; ls -l teste-sgid.txt'; rm -f /home/soc/asouza/teste-sgid.txt
drwxrws---+ 3 root soc 4096 Nov  8 22:14 grupos/soc
0007
-rw-rw---- 1 asouza asouza 0 Nov  8 22:14 teste-sgid.txt
```

## 5. Cálculo das permissões finais com a umask 007

A umask é subtraída (bit a bit) do modo padrão de criação: `666` para arquivos e `777` para diretórios.

- Arquivo: `666` sem os bits de `007` = `660` = `rw-rw----`
- Diretório: `777` sem os bits de `007` = `770` = `rwxrwx---`

Em binário, o último dígito: `6 = 110` e `7 = 111`; a umask `7 = 111` zera todos os bits de outros. Prova na VM:

```
$ su - eprado -c 'umask; touch calc.txt; mkdir calc-dir; ls -ld calc.txt calc-dir'; rm -rf /home/auditoria/eprado/calc.txt /home/auditoria/eprado/calc-dir
0007
drwxrwx--- 2 eprado eprado 4096 Nov  8 22:14 calc-dir
-rw-rw---- 1 eprado eprado    0 Nov  8 22:14 calc.txt
```

## 6. Ordem de avaliação de uma ACL, papel da máscara e efeito do chmod no grupo

O kernel avalia nesta ordem e para na primeira classe que casar: (1) se o processo é o dono, vale a entrada `user::`; (2) se é um usuário nomeado, vale `user:nome:`; (3) se pertence ao grupo dono ou a algum grupo nomeado, vale a entrada de grupo que conceder o acesso pedido (se nenhuma conceder, é negado); (4) senão, vale `other::`.

A máscara (`mask::`) é o limite máximo para todas as entradas da classe de grupo: usuários nomeados, grupo dono e grupos nomeados. A permissão efetiva é a interseção da entrada com a máscara. Em um arquivo com ACL, o `ls -l` mostra a máscara no lugar das permissões do grupo, e por isso o `chmod g=...` passa a alterar a máscara, e não a entrada `group::`. Um `chmod g-w` em um arquivo com ACL corta a escrita de todos os nomeados de uma vez. Demonstração em uma cópia:

```
$ cp -p grupos/redteam/ferramentas/coleta-info.sh /tmp/acl-demo.sh; setfacl -m u:cmendes:rwx /tmp/acl-demo.sh; chmod g=r /tmp/acl-demo.sh; getfacl -p --omit-header /tmp/acl-demo.sh; rm -f /tmp/acl-demo.sh
user::rwx
user:svc-backup:r-x	#effective:r--
user:fnunes:r-x	#effective:r--
user:cmendes:rwx	#effective:r--
group::rwx	#effective:r--
group:auditoria:r-x	#effective:r--
mask::r--
other::---

```

Depois do `chmod g=r`, a máscara virou `r--` e as entradas com `x` ou `w` aparecem com `#effective` reduzido.

## 7. Por que a ACL de fnunes prevalece sobre as permissões do grupo redteam

Porque na ordem de avaliação a entrada de usuário nomeado (`user:fnunes:r-x`) vem antes das entradas de grupo. Quando o kernel encontra uma entrada específica para o usuário, ele usa só ela e nem chega a olhar o grupo `redteam`, que tem `rwx`. Por isso fnunes, mesmo sendo membro do redteam, lê e executa os scripts, mas não altera nem cria:

```
$ getfacl -p --omit-header grupos/redteam/ferramentas/varredura-portas.sh
user::rwx
user:svc-backup:r-x
user:fnunes:r-x
group::rwx
group:auditoria:r-x
mask::rwx
other::---

```
```
$ runuser -u fnunes -- bash grupos/redteam/ferramentas/coleta-info.sh | head -2; runuser -u fnunes -- bash -c 'echo x >> grupos/redteam/ferramentas/varredura-portas.sh'
Host: lsa-guilherme
Kernel: 6.12.115+deb13.1-amd64
Broken pipe
bash: line 1: grupos/redteam/ferramentas/varredura-portas.sh: Permission denied
```

## 8. Para apagar um arquivo, importa a permissão do arquivo ou a do diretório?

A do diretório. Apagar é remover uma entrada do diretório, então é preciso `w` e `x` no diretório, independentemente das permissões do próprio arquivo. A exceção é o sticky bit, que exige também ser dono do arquivo (ou do diretório). Prova: o blima apaga um arquivo do root que está como `000`, porque tem `w` no diretório `grupos/soc`; e não consegue escrever nele, porque a escrita depende do arquivo:

```
$ touch grupos/soc/arquivo-root.txt; chmod 000 grupos/soc/arquivo-root.txt; setfacl -b grupos/soc/arquivo-root.txt; ls -l grupos/soc/arquivo-root.txt
---------- 1 root soc 0 Nov  8 22:14 grupos/soc/arquivo-root.txt
```
```
$ runuser -u blima -- bash -c 'echo x > grupos/soc/arquivo-root.txt'; runuser -u blima -- rm -f grupos/soc/arquivo-root.txt && echo 'apagado pelo blima'; ls grupos/soc/arquivo-root.txt
bash: line 1: grupos/soc/arquivo-root.txt: Permission denied
apagado pelo blima
ls: cannot access 'grupos/soc/arquivo-root.txt': No such file or directory
```

## 9. Por que o imutável não protege contra um atacante que já tem root e quais defesas complementares existem

O atributo `i` bloqueia até o root, mas o próprio root pode remover o atributo com `chattr -i` e depois alterar o arquivo, porque tem a capacidade `CAP_LINUX_IMMUTABLE`. Ele protege contra erro humano, contra scripts e contra processos sem essa capacidade, não contra quem já controla o sistema:

```
$ lsattr empresa/politicas/politica-seguranca.txt; echo teste >> empresa/politicas/politica-seguranca.txt
----i---------e------- empresa/politicas/politica-seguranca.txt
bash: line 1: empresa/politicas/politica-seguranca.txt: Operation not permitted
```

Defesas complementares: evitar o acesso root (sudo com mínimo privilégio e sem shell root compartilhado), auditoria com `auditd` registrando `chattr` e escritas em `empresa/politicas/`, monitoramento de integridade (AIDE ou hashes guardados fora da máquina), envio dos logs para um servidor remoto, backups imutáveis/offline, remoção de `CAP_LINUX_IMMUTABLE` de serviços e, em ambientes críticos, frameworks como SELinux/AppArmor ou boot com securelevel restrito.

## 10. Por que o Linux ignora o SUID em scripts, o que faz o `nosuid` e onde usar nesta estrutura

O kernel ignora SUID em scripts interpretados (com `#!`) porque existe uma janela entre o kernel ler o shebang e o interpretador abrir o arquivo: um atacante poderia trocar o script nesse intervalo (condição de corrida) ou manipular variáveis de ambiente como `IFS`, `PATH` e `BASH_ENV` para executar código como o dono do script. Por isso só binários compilados respeitam o SUID.

A opção de montagem `nosuid` faz o kernel ignorar os bits SUID e SGID de todos os executáveis daquele sistema de arquivos. Nesta estrutura ela seria recomendada para o `/srv/arquivos` (idealmente uma partição própria), principalmente para `publico/troca`, `publico/downloads` e `individual/`, onde usuários gravam arquivos, além de `/tmp`, `/var/tmp` e `/dev/shm`, junto com `nodev` e, onde não houver scripts legítimos, `noexec`. Assim, mesmo que alguém consiga gravar um binário SUID ali (como na demonstração do P11), ele não ganharia privilégios.

```
$ findmnt -no SOURCE,OPTIONS /srv/arquivos 2>/dev/null || findmnt -no SOURCE,OPTIONS /
/dev/sda1 rw,relatime,errors=remount-ro
```
