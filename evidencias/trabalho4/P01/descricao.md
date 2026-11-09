# P01 - Ponto de partida (Trabalho 3, Versão A) e grupo orion

**Responsável:** Guilherme Paes Camargo (RM576842)

A VM `lsa-guilherme` (Debian 13) recebeu o estado final do Trabalho 3, Versão A: os 8 usuários com UID, home, shell e GECOS com RM, os 5 grupos funcionais com os GIDs 5001 a 5005 e o blima como administrador do grupo soc. O script de verificação confere cada item e mostra todos os grupos em [OK]. Em seguida foi criado o grupo `orion` (GID 5006) com os 6 colaboradores humanos, sem as contas de serviço.

Prints: `P01-1-verificacao.png` (hostname e saída do script) e `P01-2-grupo-orion.png` (`getent group orion` e `id` de cada usuário). Arquivo: `verificação.txt`.
