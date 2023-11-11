#!/bin/bash -e

#####################################################################
# Nome: GeraBackupHome.sh                                           #
#                                                                   #
# Autor: Luiz Fernando (www.github.com.br/handyman0)                #
# Data: 25/10/2023                                                  #
#                                                                   #
# Descrição: Este script realiza um backup compactado do diretório  #
# home do usuário que está executando o script.                     #
# Uso: ./GeraBackupHome.sh                                          #
#                                                                   #
# Versão: 0.5                                                        #
#                                                                   #
# 25/10/2023 - Luiz Fernando - Criando algoritmo de cópia           #
# 10/11/2023 - Luiz Fernando - Melhorias e correções                #
#####################################################################

DIRDEST="$HOME/Backup"
LOGFILE="$HOME/backup.log"
DATE=$(date +"%Y%m%d%H%M")
SEVEN_DAYS_AGO=$(date -d "7 days ago" +%s)

#-----------------funções-------------------------

# Função para exibir mensagens de erro e sair
erro_sair() {
    echo "Erro: $1"
    exit 1
}

#--------

# Função para exibir o progresso do backup
exibir_progresso() {
    local SIZE=$1
    local SIZEDEST=$2
    local PORC_EXIBIDA=0

    until [ $SIZEDEST -ge $SIZE ]; do
        SIZEDEST=$(du -s "$DIRDEST" 2>/dev/null | awk '{print $1}')
        PORC_ATUAL=$((SIZEDEST * 100 / SIZE))

        if [ $PORC_ATUAL -ge $((PORC_EXIBIDA + 10)) ]; then
            printf "CARREGANDO... %s%%\r" "$PORC_ATUAL"
            PORC_EXIBIDA=$PORC_ATUAL
        fi
        sleep 1
    done
}

#---------

# Cria o backup
cria_backup() {
    if ! command -v tar &>/dev/null; then
        erro_sair "O comando 'tar' não está instalado. Instale-o antes de executar este script."
    else
        echo "Criando Backup..."
        ARQ="backup_home_$DATE.tgz"
        tar czpf "$DIRDEST/$ARQ" --exclude="$DIRDEST" "$HOME" 2>/dev/null || erro_sair "Falha ao criar o backup."
    fi
}

#------------------fim das funções-------------------

# Verifica se o diretório de destino existe
if [ ! -d "$DIRDEST" ]; then
    mkdir -p "$DIRDEST" || erro_sair "Falha ao criar o diretório de backup."
fi

# Procura por backups gerados nos últimos 7 dias
if find "$DIRDEST" -ctime -7 -name "backup_home*.tgz" &>/dev/null; then
    read -rp "Já foi gerado um backup do diretório $HOME nos últimos 7 dias. Deseja continuar? (N/s): " CONT
    case "${CONT,,}" in
        n|no|"") echo "Backup Abortado!"; exit 1 ;;
        s|yes) echo "Será criado mais um backup para a mesma semana."; sleep 2 ; clear ;;
        *) erro_sair "Opção Inválida." ;;
    esac
fi

# Obtém o tamanho do diretório home
SIZE=$(du -s "$HOME" | awk '{print $1}')

# Verifica se o diretório de destino existe e é acessível
if [ -n "$DIRDEST" ] && [ -w "$DIRDEST" ]; then
    cria_backup &
    exibir_progresso "$SIZE" 0

    # Registra a operação no arquivo de log
    echo "$DATE: Backup do diretório home realizado com sucesso." >> "$LOGFILE"

    echo -e "\nO backup de nome \"$DIRDEST/$ARQ\" foi criado em $DIRDEST"
    echo -e "\nBackup Concluído!"
else
    erro_sair "Diretório de destino $DIRDEST não é acessível ou não existe."
fi

# verifica e remove backups com mais de 30 dias

find "$DIRDEST" -type f -name "backup_home*.tgz" -ctime +30 -exec rm {} \;
