# P02 - Árvore completa de /srv/arquivos

**Responsável:** Guilherme Paes Camargo (RM576842)

A estrutura obrigatória foi criada em `/srv/arquivos` exatamente com os nomes do enunciado. Todos os diretórios pertencem ao root, exceto os da área individual, que pertencem ao respectivo usuário. A árvore abaixo foi gerada com `tree -pug`, que mostra permissão, dono e grupo de cada item.

Observação: nos itens com ACL, o `tree` e o `ls` exibem a máscara no lugar do grupo. Por isso `individual/asouza` aparece como `drwxr-x---`, mas o grupo dono tem `---`; o `r-x` é do svc-backup, via ACL (detalhe no P03 e no P09).

Print: `P02-arvore.png`. Arquivo: `arvore.txt`.
