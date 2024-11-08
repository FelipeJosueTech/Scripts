#!/bin/bash

##[ Ficha ]##################################################
# Nome: script_inicializacao
# Escrito por: FelipeJosueTech
# Criado em: 05/07/2020
# Última atualização: 06/11/2024
##[ Descrição ]##############################################
# Script de configuração do fireWalld no CentOs.
#############################################################
# Variáveis
STATUS=$(systemctl is-active firewalld)
SERVICE_NAME="firewalld"

# Funções
check_firewalld_installed() {
   if command -v firewalld &> /dev/null; then
      echo "O serviço $SERVICE_NAME está instalado e na última versão."
   else
      echo "O serviço $SERVICE_NAME não está instalado."
   fi
}

show_firewalld_status() {
   echo "Status do Firewalld: $STATUS"
}

start_firewalld_service() {
   echo "Iniciando o serviço $SERVICE_NAME..."
   systemctl start firewalld
   echo "Serviço $SERVICE_NAME iniciado."
}

show_available_rules() {
   echo "Regras configuradas no Firewalld:"
   firewall-cmd --list-all | grep -i "services"
}

add_firewall_rule() {
   echo -n "Digite o nome do serviço ou porta para adicionar uma nova regra (ex: http, https): "
   read rule
   if [ -z "$rule" ]; then
      echo "Nenhuma regra digitada."
   else
      firewall-cmd --add-service="$rule" --permanent && echo "Regra '$rule' adicionada com sucesso!"
   fi
}

reload_firewalld_service() {
   echo "Recarregando o serviço $SERVICE_NAME..."
   firewall-cmd --reload && echo "Serviço $SERVICE_NAME recarregado."
}

# Código principal
clear
while true; do
   echo ""
   echo "Bem-vindo ao $0"
   echo ""
   echo "Escolha uma opção abaixo:
1 - Verificar se o serviço Firewalld está instalado
2 - Mostrar status do Firewalld
3 - Iniciar o serviço Firewalld
4 - Mostrar regras configuradas
5 - Adicionar nova regra
6 - Recarregar o serviço Firewalld
0 - Sair do script"
   echo ""
   echo -n "Opção selecionada: "
   read option
   echo ""

   case $option in
      1) check_firewalld_installed ;;
      2) show_firewalld_status ;;
      3) start_firewalld_service ;;
      4) show_available_rules ;;
      5) add_firewall_rule ;;
      6) reload_firewalld_service ;;
      0) echo "Saindo do script..."; exit 0 ;;
      *) echo "Opção inválida, tente novamente!" ;;
   esac

   echo ""
   sleep 2
done