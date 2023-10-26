#!/bin/bash

#####################################################################
# Nome: GeraBackupHome.sh                                           #
#                                                                   #
# Autor: Luiz Fernando (www.github.com.br/handyman0)                #
# Data: 25/10/2023                                                  #
#                                                                   #
# Descrição: O script fara um backup compactado do diretorio home   #
#		do usuario que estiver executando o script.         #
# Uso: ./GeraBackupHome.sh                                          #
#                                                                   #
# v0.1                                                              #
#                                                                   #
# 25/10/2023 - luiz fernando - criando o algoritmo de copia         #
#                                                                   #
#####################################################################

# Principais Variaveis
PROCURADIR=$(find /home/lfms/ -type d -name "Backup")
DATADEHOJE=$(date +%Y%m%d%H%M)
ULTIMODIR=$(ls "$PROCURADIR" -t1 | head -n 1)

# procurando se tem a variavel no depois do diretorio do usuario
if test -d "$PROCURADIR";
then
	cd "$PROCURADIR"
	if test -d $ULTIMODIR;
	then    # criando as variaveis para facilitar as contagens do dias
		DATACRIACAO=$(stat -c %Y "$ULTIMODIR")
		DATAATUAL=$(date +%s)
		DIFERENCA=$((DATAATUAL - DATACRIACAO))
		SETEDIAS=$((7 * 24 * 60 * 60))
		# Esse if é para fazer a condição se foi feito o backup antes ou depois de 7 dias
		if test "$DIFERENCA" -le "$SETEDIAS"; then
			echo "Ja foi criado um diretorio nos ultimos 7 dias"
			read -p "Deseja Continuar? (S/N)" RESPOSTA
			echo ""
			# Melhor opção ate o momento de fazer case de questionamento de como prosseguir
			case "$RESPOSTA" in
				y|s|S)
					echo "Será criado mais um backup para a mesma semana."
					echo "Criando backup!"
		                        echo""
                		        mkdir backup_home_$DATADEHOJE
					ULTIMODIR=$(ls -t1 | head -n 1)
					cd "$ULTIMODIR"
					touch backup_home_$DATADEHOJE
                        		echo "O backup de nome: ""backup_home_$DATADEHOJE ""foi criado em $PROCURADIR"
					echo ""
					echo "Backup Concluído!"
					;;

				n|N)    # Se o usuario não quiser prosseguir com o backup adicional 
                                        #coloquei como saida direto
					echo "saindo .."
					exit 0
					;;
				*)
					echo "Opção invalida, saindo do script!"
					exit 1
					;;
			esac
		else    #saindo da condição criada :D  aqui ja indo para o backup direto
			echo "Criando um diretorio!"
			echo ""
			mkdir backup_home_$DATADEHOJE
			ULTIMODIR=$(ls -t1 | head -n 1)
                        cd "$ULTIMODIR"
                        touch backup_home_$DATADEHOJE
			echo "O backup de nome: ""backup_home_$DATADEHOJE ""foi criado em $PROCURADIR"
			echo ""
			echo "Backup Concluido!"
		fi
	else
		echo "Não existe diretorio"
	fi
else
	mkdir /home/lfms/Backup
	echo "diretorio criado em /home/lfms/Backup"
fi
