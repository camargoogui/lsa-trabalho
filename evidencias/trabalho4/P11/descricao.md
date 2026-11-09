# P11 - Auditoria de SUID e SGID

**Responsável:** Guilherme Paes Camargo (RM576842)

O inventário completo de binários SUID e SGID foi feito com `find / -xdev -type f \( -perm -4000 -o -perm -2000 \)` e salvo em `suid-sgid.txt`, junto com a análise de `passwd`, `su` e `sudo` e o motivo de cada um precisar do bit. Na demonstração controlada, o fnunes não conseguia ler um arquivo confidencial da asouza; depois de criar uma cópia do `cat` com SUID em `/usr/local/bin`, ele leu o arquivo. A cópia foi removida logo em seguida e a verificação final mostra zero SUID em /usr/local. Nenhum binário original do sistema foi alterado.

Prints: `P11-1-inventario.png` e `P11-2-demo-suid.png`. Arquivo: `suid-sgid.txt`.
