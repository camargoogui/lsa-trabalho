# P08 - Ouvidoria: depósito cego

**Responsável:** Guilherme Paes Camargo (RM576842)

A `empresa/ouvidoria` está com `1730 root:orion`: o grupo orion tem `-wx` (cria arquivo pelo nome, mas não lista), o sticky bit impede apagar depósito alheio e a ACL `group:auditoria:r-x` deixa a auditoria listar e ler. A ACL padrão (`default:group::---`, `default:group:auditoria:r-x`, `default:other::---`) faz cada depósito nascer sem leitura para os outros colaboradores.

Nas prints: asouza e cmendes depositam, mas não listam; cmendes não lê o depósito da asouza mesmo sabendo o nome; ninguém apaga, sobrescreve ou renomeia depósito alheio; a eprado e o drocha (auditoria) listam e leem, mas também não apagam.

Prints: `P08-1-deposito.png`, `P08-2-sem-acesso-alheio.png` e `P08-3-auditoria.png`.
