# P05 - Alterações em modo octal

**Responsável:** Guilherme Paes Camargo (RM576842)

Foram feitas 7 alterações com `chmod` em modo octal, com antes e depois: O1 `1730` na ouvidoria (sticky bit com 4 dígitos), O2 `2750` em politicas, incidentes e backup (SGID), O3 `2770` em comunicados, bkpadm, monitoramento e metricas (SGID), O4 `0711` em individual, O5 `0770` nos scripts do Red Team, O6 `0640` em politica-seguranca.txt e O7 `0620` em alertas.log. Assim temos vários bits especiais expressos com 4 dígitos (1730, 2750 e 2770).

Prints: `P05-1-octal.png` e `P05-2-octal.png`.
