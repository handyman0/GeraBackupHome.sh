#!/bin/bash

PROCURADIR=$(find /home/lfms/ -type d -name "Backup")
DATADEHOJE=$(date +%Y%m%d%H%M)
ULTIMODIR=$(ls "$PROCURADIR" -t1 | head -n 1)
if test -d "$PROCURADIR";
then
	cd "$PROCURADIR"
	if test -d $ULTIMODIR; then 
		DATACRIACAO=$(stat -c %Y "$ULTIMODIR")
		DATAATUAL=$(date +%s)
		DIFERENCA=$((DATAATUAL - DATACRIACAO))
		SETEDIAS=$((7 * 24 * 60 * 60))
		if test "$DIFERENCA" -le "$SETEDIAS"; then
			echo "Ja foi criado um diretorio nos ultimos 7 dias"
			read -p "Deseja Continuar? (S/N)" RESPOSTA
			echo ""
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

				n|N)
					echo "saindo .."
					exit 0
					;;
				*)
					echo "Opção invalida, saindo do script!"
					exit 1
					;;
			esac
		else
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
