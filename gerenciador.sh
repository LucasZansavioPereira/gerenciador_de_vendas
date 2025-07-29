#!/bin/bash

#FUNCAO QUE FAZ A CHECAGEM DA CARGA DA MAQUINA PELO COMANDO UPTIME
checaCarga(){
echo -n "CHECANDO CARGA... "
CARGA=$(uptime | awk -F 'average:' '{print $2}' | awk '{print $1}' | sed 's/,//g')
[ $CARGA -le 90 ] && echo "OK" || echo "PROBLEMA"
}

#FUNCAO QUE FAZ A CHECAGEM DA MEMORIA DA MAQUINA PELO COMANDO FREE -M
checaMemoria(){
	echo -n "CHECANDO MEMORIA..."
	MEM_TOTAL=$(free -m | grep ^Mem | awk '{print $2}')
	MEM_LIVRE=$(free -m | grep ^Mem | awk '{print $4+$5+$6}')
	PERC_MEMORIA_LIVRE=$(echo $(($MEM_LIVRE*100/$MEM_TOTAL)))
	[ $PERC_MEMORIA_LIVRE -le 10 ] && echo "PROBLEMA" || echo "OK"
}

#FUNCAO QUE FAZ A CHECAGEM DO DISCO DA MAQUINA PELO COMANDO UPTIME
checaDisco(){
echo "CHECANDO DISCO..."
df | grep ^/dev | while read LINHA ;do
	PORCENTAGEM=$(echo $LINHA | awk '{print $5}' | sed 's/%//g')
	NOME=$(echo $LINHA | awk '{print $6}')
	[ $PORCENTAGEM -le 90 ] && echo "[OK] Particao $NOME com $PORCENTAGEM% de uso" || echo "[PROBLEMA] Partição $NOME com $PORCENTAGEM% de uso"

done

}

#SWITCH/CASE PARA CONTROLAR A CHAMADA DAS FUNÇOES PELO PAREMETRO 1
case $1 in
	"carga") checaCarga ;;
	"memoria") checaMemoria ;;
	"disco") checaDisco ;;
	"tudo") checaCarga ; checaMemoria ; checaDisco ;;
	*) echo "FORMA DE USO $0 <CARGA|MEMORIA|DISCO>" ;;
esac
