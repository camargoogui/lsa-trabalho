# P09 - ACLs, ACLs padrão e máscara

**Responsável:** Guilherme Paes Camargo (RM576842)

ACLs foram usadas só onde o modelo tradicional não resolve: svc-backup lendo toda a árvore (inclusive arquivos futuros), auditoria lendo grupos/, drocha escrevendo em downloads e politicas, orion lendo comunicados, auditoria na ouvidoria, blima como único escritor em incidentes, fnunes só lendo e executando em ferramentas, blima só lendo o alertas.log e svc-backup escrevendo em backup/. As ACLs padrão (default) garantem a herança para arquivos novos e a máscara limita todas as entradas da classe de grupo (visível nos `#effective`).

Prints: `P09-1-acl-padrao.png`, `P09-2-acl-mascara.png` e `P09-3-testes-acl.png` (fnunes executa mas não altera; arquivo novo em incidentes herda a ACL; svc-backup lê arquivos futuros e não escreve). Arquivo: `getfacl.txt`.
