# P12 - Matriz de acesso (8 usuarios x diretorios)

Legenda: E = entra (cd), L = lista (ls), R = le um arquivo de referencia da pasta, C = cria arquivo, A = apaga arquivo. Traco = negado.
O arquivo de referencia de cada pasta e criado por quem tem o papel de escrever nela (coluna 'quem cria' no testes.sh).
Esta matriz e o contrato verificado pelo testes.sh (P13).

| Diretorio | asouza | blima | cmendes | drocha | eprado | fnunes | svc-backup | svc-monitor |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| `publico/` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` |
| `publico/downloads/` | `ELR--` | `ELR--` | `ELR--` | `ELRCA` | `ELR--` | `ELR--` | `ELR--` | `ELR--` |
| `publico/troca/` | `ELRC-` | `ELRCA` | `ELRC-` | `ELRC-` | `ELRC-` | `ELRC-` | `ELR--` | `ELRC-` |
| `empresa/` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `-----` |
| `empresa/politicas/` | `ELR--` | `ELR--` | `ELR--` | `ELRCA` | `ELR--` | `ELR--` | `ELR--` | `-----` |
| `empresa/comunicados/` | `ELRCA` | `ELRCA` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `-----` |
| `empresa/ouvidoria/` | `E-RCA` | `E--C-` | `E--C-` | `ELRC-` | `ELRC-` | `E--C-` | `ELR--` | `-----` |
| `grupos/` | `E----` | `E----` | `E----` | `ELR--` | `ELR--` | `E----` | `ELR--` | `E----` |
| `grupos/soc/` | `ELRCA` | `ELRCA` | `-----` | `ELR--` | `ELR--` | `-----` | `ELR--` | `-----` |
| `grupos/soc/incidentes/` | `ELR--` | `ELRCA` | `-----` | `ELR--` | `ELR--` | `-----` | `ELR--` | `-----` |
| `grupos/redteam/` | `-----` | `-----` | `ELRCA` | `ELR--` | `ELR--` | `ELRCA` | `ELR--` | `-----` |
| `grupos/redteam/ferramentas/` | `-----` | `-----` | `ELRCA` | `ELR--` | `ELR--` | `ELR--` | `ELR--` | `-----` |
| `grupos/auditoria/` | `-----` | `-----` | `-----` | `ELRCA` | `ELRCA` | `-----` | `ELR--` | `-----` |
| `grupos/bkpadm/` | `-----` | `-----` | `-----` | `ELRCA` | `ELR--` | `-----` | `ELR--` | `-----` |
| `grupos/monitoramento/` | `-----` | `ELRCA` | `-----` | `ELR--` | `ELR--` | `-----` | `ELR--` | `ELRCA` |
| `grupos/monitoramento/metricas/` | `-----` | `ELRCA` | `-----` | `ELR--` | `ELR--` | `-----` | `ELR--` | `ELRCA` |
| `individual/asouza/` | `ELRCA` | `-----` | `-----` | `-----` | `-----` | `-----` | `ELR--` | `-----` |
| `individual/blima/` | `-----` | `ELRCA` | `-----` | `-----` | `-----` | `-----` | `ELR--` | `-----` |
| `individual/cmendes/` | `-----` | `-----` | `ELRCA` | `-----` | `-----` | `-----` | `ELR--` | `-----` |
| `individual/drocha/` | `-----` | `-----` | `-----` | `ELRCA` | `-----` | `-----` | `ELR--` | `-----` |
| `individual/eprado/` | `-----` | `-----` | `-----` | `-----` | `ELRCA` | `-----` | `ELR--` | `-----` |
| `individual/fnunes/` | `-----` | `-----` | `-----` | `-----` | `-----` | `ELRCA` | `ELR--` | `-----` |
| `backup/` | `-----` | `-----` | `-----` | `ELR--` | `-----` | `-----` | `ELRCA` | `-----` |
