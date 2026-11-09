#!/bin/bash
# testes.sh - P13: valida a matriz de acesso do servidor de arquivos da Orion
# Executar como root:  bash testes.sh            (roda os testes)
#                      bash testes.sh --matriz   (gera a matriz em Markdown)
# Cada teste roda COMO O USUARIO (runuser) e compara com o esperado.
# Tudo o que o script cria e removido no final.

B=/srv/arquivos
USUARIOS=(asouza blima cmendes drocha eprado fnunes svc-backup svc-monitor)
ACOES=(entrar listar ler criar apagar)

# Matriz (contrato). Cada linha: diretorio|quem cria o arquivo de referencia|E|L|R|C|A
# Em cada coluna, 8 letras na ordem de USUARIOS: S = permitido, N = negado.
MATRIZ='
publico|root|SSSSSSSS|SSSSSSSS|SSSSSSSS|NNNNNNNN|NNNNNNNN
publico/downloads|drocha|SSSSSSSS|SSSSSSSS|SSSSSSSS|NNNSNNNN|NNNSNNNN
publico/troca|blima|SSSSSSSS|SSSSSSSS|SSSSSSSS|SSSSSSNS|NSNNNNNN
empresa|root|SSSSSSSN|SSSSSSSN|SSSSSSSN|NNNNNNNN|NNNNNNNN
empresa/politicas|drocha|SSSSSSSN|SSSSSSSN|SSSSSSSN|NNNSNNNN|NNNSNNNN
empresa/comunicados|blima|SSSSSSSN|SSSSSSSN|SSSSSSSN|SSNNNNNN|SSNNNNNN
empresa/ouvidoria|asouza|SSSSSSSN|NNNSSNSN|SNNSSNSN|SSSSSSNN|SNNNNNNN
grupos|root|SSSSSSSS|NNNSSNSN|NNNSSNSN|NNNNNNNN|NNNNNNNN
grupos/soc|blima|SSNSSNSN|SSNSSNSN|SSNSSNSN|SSNNNNNN|SSNNNNNN
grupos/soc/incidentes|blima|SSNSSNSN|SSNSSNSN|SSNSSNSN|NSNNNNNN|NSNNNNNN
grupos/redteam|cmendes|NNSSSSSN|NNSSSSSN|NNSSSSSN|NNSNNSNN|NNSNNSNN
grupos/redteam/ferramentas|cmendes|NNSSSSSN|NNSSSSSN|NNSSSSSN|NNSNNNNN|NNSNNNNN
grupos/auditoria|eprado|NNNSSNSN|NNNSSNSN|NNNSSNSN|NNNSSNNN|NNNSSNNN
grupos/bkpadm|drocha|NNNSSNSN|NNNSSNSN|NNNSSNSN|NNNSNNNN|NNNSNNNN
grupos/monitoramento|blima|NSNSSNSS|NSNSSNSS|NSNSSNSS|NSNNNNNS|NSNNNNNS
grupos/monitoramento/metricas|blima|NSNSSNSS|NSNSSNSS|NSNSSNSS|NSNNNNNS|NSNNNNNS
individual/asouza|asouza|SNNNNNSN|SNNNNNSN|SNNNNNSN|SNNNNNNN|SNNNNNNN
individual/blima|blima|NSNNNNSN|NSNNNNSN|NSNNNNSN|NSNNNNNN|NSNNNNNN
individual/cmendes|cmendes|NNSNNNSN|NNSNNNSN|NNSNNNSN|NNSNNNNN|NNSNNNNN
individual/drocha|drocha|NNNSNNSN|NNNSNNSN|NNNSNNSN|NNNSNNNN|NNNSNNNN
individual/eprado|eprado|NNNNSNSN|NNNNSNSN|NNNNSNSN|NNNNSNNN|NNNNSNNN
individual/fnunes|fnunes|NNNNNSSN|NNNNNSSN|NNNNNSSN|NNNNNSNN|NNNNNSNN
backup|svc-backup|NNNSNNSN|NNNSNNSN|NNNSNNSN|NNNNNNSN|NNNNNNSN
'

# ---------- modo --matriz: gera matriz.md ----------
if [ "$1" == "--matriz" ]; then
  printf '| Diretorio |'; for u in "${USUARIOS[@]}"; do printf ' %s |' "$u"; done; echo
  printf '|---|'; for u in "${USUARIOS[@]}"; do printf ':---:|'; done; echo
  echo "$MATRIZ" | while IFS='|' read -r d ref e l r c a; do
    [ -z "$d" ] && continue
    printf '| `%s/` |' "$d"
    for i in 0 1 2 3 4 5 6 7; do
      cel=""
      [ "${e:$i:1}" == S ] && cel+="E" || cel+="-"
      [ "${l:$i:1}" == S ] && cel+="L" || cel+="-"
      [ "${r:$i:1}" == S ] && cel+="R" || cel+="-"
      [ "${c:$i:1}" == S ] && cel+="C" || cel+="-"
      [ "${a:$i:1}" == S ] && cel+="A" || cel+="-"
      printf ' `%s` |' "$cel"
    done; echo
  done
  exit 0
fi

[ "$(id -u)" -eq 0 ] || { echo "Execute como root."; exit 1; }
TAG="teste$$"
LOG=$(mktemp)
total=0; ok=0

como(){ runuser -u "$1" -- sh -c "$2" >/dev/null 2>&1; }

# cria um arquivo como o usuario "dono" (ou como root, herdando o grupo do diretorio)
prepara(){ local dono=$1 arq=$2
  if [ "$dono" == root ]; then touch "$arq" && chgrp "$(stat -c %G "$(dirname "$arq")")" "$arq"
  else runuser -u "$dono" -- touch "$arq"; fi; }

registra(){ local u=$1 acao=$2 cam=$3 esp=$4 obt=$5
  total=$((total+1))
  [ "$esp" == S ] && esp="PERMITIDO" || esp="NEGADO"
  [ "$obt" == S ] && obt="PERMITIDO" || obt="NEGADO"
  if [ "$esp" == "$obt" ]; then ok=$((ok+1)); st="PASSOU"; else st="FALHOU"; fi
  printf '%-6s | %-11s | %-6s | %-48s | esperado=%-9s | obtido=%-9s\n' "$st" "$u" "$acao" "$cam" "$esp" "$obt"; }

echo "=== testes.sh | host $(hostname) | $(date '+%d/%m/%Y %H:%M') ==="
echo "STATUS | USUARIO     | ACAO   | CAMINHO                                          | ESPERADO           | OBTIDO"
while IFS='|' read -r d ref e l r c a; do
  [ -z "$d" ] && continue
  dir="$B/$d"
  refarq="$dir/ref-$TAG.txt"
  prepara "$ref" "$refarq"
  for i in "${!USUARIOS[@]}"; do
    u=${USUARIOS[$i]}
    como "$u" "cd '$dir'"            && o=S || o=N; registra "$u" entrar "$dir/"         "${e:$i:1}" $o
    como "$u" "ls '$dir'"            && o=S || o=N; registra "$u" listar "$dir/"         "${l:$i:1}" $o
    como "$u" "cat '$refarq'"        && o=S || o=N; registra "$u" ler    "$refarq"       "${r:$i:1}" $o
    novo="$dir/novo-$TAG-$u.txt"
    como "$u" "touch '$novo'"; [ -e "$novo" ] && o=S || o=N; registra "$u" criar "$novo" "${c:$i:1}" $o
    alvo="$dir/apagar-$TAG-$u.txt"
    prepara "$ref" "$alvo"
    como "$u" "rm -f '$alvo'"; [ -e "$alvo" ] && o=N || o=S; registra "$u" apagar "$alvo" "${a:$i:1}" $o
  done
done <<< "$MATRIZ"

# limpeza: remove tudo o que o script criou
find "$B" -name "*$TAG*" -exec rm -f {} + 2>/dev/null
restam=$(find "$B" -name "*$TAG*" | wc -l)

falhas=$((total-ok))
echo
echo "Total de testes: $total | Passaram: $ok | Falharam: $falhas"
awk -v a=$ok -v t=$total 'BEGIN{printf "Acertos: %.1f%%\n", (a*100)/t}'
echo "Arquivos de teste restantes apos a limpeza: $restam"
