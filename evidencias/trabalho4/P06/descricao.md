# P06 - Prova do SGID e do sticky bit

**Responsável:** Guilherme Paes Camargo (RM576842)

SGID: com `grupos/soc` em 2770, os arquivos criados pelo blima e pela asouza nasceram com o grupo `soc`, e não com o grupo primário de cada um. Para comparação, um arquivo criado na home do blima (sem SGID) ficou com o grupo `blima`. A asouza ainda editou o arquivo criado pelo blima, mostrando a colaboração.

Sticky bit: em `publico/troca` (1777, `t` na listagem) o blima criou um arquivo e a asouza não conseguiu apagar nem renomear (Operation not permitted), enquanto o próprio blima apagou normalmente.

Prints: `P06-1-sgid.png` e `P06-2-sticky.png`.
