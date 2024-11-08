#!/bin/bash

##[ Ficha ]##################################################
# Nome: script_inicializacao
# Escrito por: FelipeJosueTech
# Criado em: 25/04/2019
# Última atualização: 08/11/2024
##[ Descrição ]##############################################
# Script de configuração inicial para sistemas CentOS.
#############################################################

# -- VERIFICAR SE O USUÁRIO É ROOT
if [[ $EUID -ne 0 ]]; then
    echo "Você precisa ser root para executar este script."
    exit 1
fi

# -- CRIAR LOG SE NÃO EXISTIR
log_file="/var/log/script_inicializacao.log"
[[ ! -e $log_file ]] && echo "Criando log em $log_file" && touch "$log_file"

# -- INFORMAÇÕES INICIAIS
echo "Script de configuração inicial do sistema."
sleep 0.3
echo "Diretório atual: $(pwd)"
sleep 0.3
echo "Usuário logado: $USER"
sleep 0.3
echo "PID: $$"
sleep 0.3
echo "Console: $SSH_TTY"
sleep 0.3

# -- REGISTRAR EXECUÇÃO NO LOG
datevar=$(date)
IP=$(echo "$SSH_CLIENT" | awk '{print $1}')
echo "Usuário $USER executou o script em $datevar do IP $IP" | tee -a "$log_file"

# Função para solicitar confirmação de configuração
confirm() {
    read -p "$1 [s/n] > " opcao
    [[ "$opcao" == "s" ]]
}

# -- CONFIGURAÇÃO DE HOSTNAME
if confirm "Deseja configurar o hostname?"; then
    read -p "Digite o hostname: " hostname
    {
        echo "NETWORKING=yes"
        echo "NETWORKING_IPV6=yes"
        echo "HOSTNAME=$hostname"
    } > /etc/sysconfig/network
    echo "127.0.0.1   localhost.localdomain   localhost   $hostname" > /etc/hosts
    echo "Hostname configurado para $hostname." | tee -a "$log_file"
fi

# -- CONFIGURAÇÃO DE PROXY
if confirm "Sua rede possui proxy?"; then
    read -p "Digite o IP do proxy: " ip
    read -p "Digite a porta: " port
    {
        echo '#!/bin/bash'
        echo "export http_proxy=http://$ip:$port"
        echo "export https_proxy=http://$ip:$port"
        echo "export ftp_proxy=http://$ip:$port"
    } > /etc/profile.d/proxy.sh
    chmod +x /etc/profile.d/proxy.sh
    source /etc/profile.d/proxy.sh
    echo "Proxy configurado para $ip:$port." | tee -a "$log_file"
fi

# -- CONFIGURAÇÃO DE DNS
if confirm "Deseja configurar DNS?"; then
    read -p "Digite o domínio: " dominio
    echo "search $dominio" > /etc/resolv.conf
    read -p "Quantos servidores de DNS? " num_dns
    for i in $(seq 1 $num_dns); do
        read -p "Digite o IP do servidor DNS $i: " ipdns
        echo "nameserver $ipdns" >> /etc/resolv.conf
        echo "Servidor DNS $i configurado para $ipdns." | tee -a "$log_file"
    done
fi

# -- CONFIGURAÇÃO DE DATA E HORA
if confirm "Deseja configurar Data/Hora?"; then
    read -p "Digite a data/hora [mm/dd/aaaa hh:mm]: " data
    date -s "$data" && echo "Data/hora configurada para $data." | tee -a "$log_file"
fi

# -- CONFIGURAÇÃO DE NTP
if confirm "Deseja configurar um servidor NTP?"; then
    read -p "Digite o IP do servidor NTP: " ipntp
    ntpdate -u -v "$ipntp" && echo "Servidor NTP configurado para $ipntp." | tee -a "$log_file"
fi

# -- CRIAÇÃO DE CRON JOB PARA NTPDATE
if confirm "Deseja criar cron para NTPdate?"; then
    (crontab -l 2>/dev/null; echo "*/1 * * * * /usr/sbin/ntpdate -u -v $ipntp") | crontab -
    echo "Cron configurado para sincronização NTP." | tee -a "$log_file"
fi

# -- CONFIGURAÇÃO DE IP FIXO
if confirm "Deseja configurar IP fixo?"; then
    read -p "Digite o IP: " ip
    read -p "Digite a máscara de rede: " mask
    read -p "Digite o gateway: " gw
    {
        echo "DEVICE=eth0"
        echo "BOOTPROTO=none"
        echo "HWADDR=$(cat /sys/class/net/eth0/address)"
        echo "ONBOOT=yes"
        echo "NETMASK=$mask"
        echo "IPADDR=$ip"
        echo "GATEWAY=$gw"
    } > /etc/sysconfig/network-scripts/ifcfg-eth0
    echo "Configuração de IP fixo completa." | tee -a "$log_file"
else
    echo "IP atribuído via DHCP." | tee -a "$log_file"
    {
        echo "DEVICE=eth0"
        echo "BOOTPROTO=dhcp"
        echo "ONBOOT=yes"
    } > /etc/sysconfig/network-scripts/ifcfg-eth0
fi

# -- REINÍCIO DO SISTEMA
if confirm "Deseja reiniciar o sistema?"; then
    echo "Reiniciando em 10 segundos..."
    sleep 10
    reboot
else
    echo "Configurações concluídas sem reinicialização."
fi