# P03 - Tabela de permissões nos modos literal e octal

**Responsável:** Guilherme Paes Camargo (RM576842)

O arquivo `tabela.md` lista cada diretório e arquivo especial com dono, grupo, permissão em modo literal e octal, as entradas de ACL e atributos e a justificativa de cada escolha. A tabela foi gerada direto na VM a partir do estado real (`stat`, `getfacl` e `lsattr`), então não há diferença entre o que está documentado e o que está aplicado.

Quando o item tem ACL, o trio do grupo mostrado pelo `ls`/`stat` é a máscara; a permissão real do grupo dono aparece na coluna de ACL como `group::`.

Arquivo: `tabela.md`.
