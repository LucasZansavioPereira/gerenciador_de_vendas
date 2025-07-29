#!/bin/bash

#tail vendas.csv

grep -v ^SKU vendas.csv | while read LINHA;

do

DATA=$(echo $LINHA | awk -F ';' '{print $4}') 
DIA=$(echo $DATA | awk -F '/' '{print $1}')
MES=$(echo $DATA | awk -F '/' '{print $2}')
ANO=$(echo $DATA | awk -F '/' '{print $3}')

DATA_CORRETA=$"$ANO-$MES-$DIA"

PRECO=$(echo $LINHA | awk -F ';' '{print $6}' | sed 's/R$ //g' | sed 's/\.//g' | sed 's/,/./g')

SKU=$(echo $LINHA | awk -F ';' '{print $1}')

TAM_PEDIDO=$(echo $LINHA | awk -F ';' '{print $2}')

LOJA=$(echo $LINHA | awk -F ';' '{print $3}')

MARCA=$(echo $LINHA | awk -F ';' '{print $5}')

TUDO="INSERT INTO vendas VALUES ('$SKU', '$TAM_PEDIDO', '$LOJA', '$DATA_CORRETA', '$MARCA', '$PRECO');"

echo "$TUDO" >> /root/insert.sql
#echo "$TUDO"

done
