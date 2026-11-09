# P04 - Alterações em modo literal (simbólico)

**Responsável:** Guilherme Paes Camargo (RM576842)

Foram feitas 7 alterações com `chmod` em modo literal, cada uma mostrando o antes e o depois: L1 `a+w,o+t` em publico/troca (sticky bit), L2 `u=rwx,g=rx,o=` em empresa, L3 `u=rwx,g=x,o=` em grupos, L4 `-R g+rwX,o-rwx` em grupos/redteam (uso do X maiúsculo: os diretórios ganharam x e os scripts, que ainda não eram executáveis, não), L5 `g+s` em redteam e ferramentas (SGID), L6 `u=rwx,g=rwxs,o=` em soc e auditoria e L7 `go=` nas pastas individuais.

Prints: `P04-1-literal.png` e `P04-2-literal.png`.
