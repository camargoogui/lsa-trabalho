# P13 - Script de testes automatizado

**Responsável:** Guilherme Paes Camargo (RM576842)

O `testes.sh` roda como root e executa cada teste como o usuário correspondente (`runuser`), comparando o resultado com a matriz do P12. São 920 testes (8 usuários x 23 diretórios x 5 ações), misturando acessos que devem ser permitidos e negados. Cada linha mostra status, usuário, ação, caminho, esperado e obtido, e o final mostra o total e a porcentagem de acertos. Resultado na VM: 920 de 920, 100%. O script remove tudo o que criou e confere que não sobrou nenhum arquivo de teste.

Print: `P13-testes-100.png`. Arquivos: `testes.sh` e `saida-testes.txt`.
