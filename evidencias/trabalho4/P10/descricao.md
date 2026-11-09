# P10 - Atributos imutável e somente acréscimo

**Responsável:** Guilherme Paes Camargo (RM576842)

O `politica-seguranca.txt` recebeu `chattr +i` (imutável) e o `alertas.log` recebeu `chattr +a` (somente acréscimo), confirmados com `lsattr`. Nas provas, nem o root consegue acrescentar, sobrescrever, apagar ou mover a política sem antes remover o atributo, e o drocha também não. No alertas.log, o svc-monitor consegue acrescentar uma linha nova, mas nem ele nem o root conseguem sobrescrever, zerar (truncate) ou apagar o arquivo; o blima continua lendo o conteúdo.

Prints: `P10-1-imutavel.png` e `P10-2-somente-acrescimo.png`.
