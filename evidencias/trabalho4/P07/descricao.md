# P07 - umask 007 permanente para o grupo orion

**Responsável:** Guilherme Paes Camargo (RM576842)

A umask foi configurada em `/etc/profile.d/orion-umask.sh`, que aplica `umask 007` somente para quem pertence ao grupo orion. O arquivo é carregado em todo login (bash e sh via /etc/profile) e também foi referenciado em `/etc/bash.bashrc` e `/etc/zsh/zprofile`, porque a cmendes usa zsh. O valor 007 tira toda permissão de outros e mantém leitura e escrita para o grupo, que é o necessário para colaborar dentro do grupo sem expor arquivos.

Cálculo: arquivo 666 - 007 = 660 (rw-rw----) e diretório 777 - 007 = 770 (rwxrwx---), comprovado com arquivos recém-criados pela asouza e pela eprado.

Prints: `P07-1-umask-config.png` e `P07-2-umask-teste.png`.
