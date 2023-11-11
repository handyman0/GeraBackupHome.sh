# GeraBackupHome.sh

Este script em Bash realiza um backup compactado do diretório home do usuário que está executando o script.

## Uso

```bash
./GeraBackupHome.sh
```

## Requisitos

- Bash
- Comando 'tar' instalado

## Funcionalidades

- Cria um backup compactado do diretório home.
- Exibe progresso durante o backup.
- Registra operações no arquivo de log.
- Verifica e remove backups com mais de 30 dias.

## Parâmetros e Variáveis

- `DIRDEST`: Diretório de destino para o backup (padrão: "$HOME/Backup").
- `LOGFILE`: Arquivo de log para registrar operações (padrão: "$HOME/backup.log").
- `DATE`: Data no formato "YYYYMMDDHHMM".
- `SEVEN_DAYS_AGO`: Timestamp para sete dias atrás.

## Versões

- **v0.5**
    - 25/10/2023 - Luiz Fernando - Criando algoritmo de cópia.
    - 10/11/2023 - Luiz Fernando - Melhorias e correções.

## Como Contribuir

Sinta-se à vontade para abrir issues ou enviar pull requests para melhorias ou correções.

## Autor

Luiz Fernando
[GitHub: handyman0](https://www.github.com.br/handyman0)
[Linkedin: Luiz Fernando](https://www.linkedin.com/in/luizfernando-perfil)

## Licença

Este projeto é licenciado sob a [Licença MIT](LICENSE).
```
