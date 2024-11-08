#!/bin/bash

##[ Ficha ]##################################################
# Nome: script_inicializacao
# Escrito por: FelipeJosueTech
# Criado em: 26/04/2019
# Última atualização: 08/11/2024
##[ Descrição ]##############################################
# Script de Backup para sistemas CentOS.
#############################################################
# Variáveis
ROOT_UID=0
E_NOTROOT=67
timestamp=$(date +%d-%m-%Y-%H:%M)
dir_source="/etc"
dir_dest="/backup"

# Funções
compact() {
   tar -cjvf "$dir_dest/bkp-$timestamp-usr.tar.bz2" "$dir_source"
}

is_root() {
   if [ "$UID" -ne "$ROOT_UID" ]; then
      echo "Você precisa ser root para executar este script!"
      exit $E_NOTROOT
   fi
}

# Código principal
is_root

if [ -d "$dir_dest" ]; then
   compact
else
   if [ -f "$dir_dest" ]; then
      echo "Erro: $dir_dest é um arquivo, não um diretório."
      sleep 2
      exit 1
   else
      mkdir -p "$dir_dest"
      compact
   fi
fi

echo "Backup concluído com sucesso em $dir_dest/bkp-$timestamp-usr.tar.bz2"
# Fim do script