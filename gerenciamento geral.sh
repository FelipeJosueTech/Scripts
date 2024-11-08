#!/bin/bash
##[ Ficha ]##################################################
# Nome: script_inicializacao
# Escrito por: FelipeJosueTech
# Criado em: 29/06/2020
# Última atualização: 06/11/2024
##[ Descrição ]##############################################
# Script de gerenciamento geral do sistema CentOs
#############################################################
function menuprincipal() {
    clear
    echo " "
    echo "HARDWARE MACHINE INFORMATION $0"
    echo " "
    echo "Escolha uma opção abaixo para começar!"
    echo "      1 - Verificar processador do desktop"
    echo "      2 - Verificar kernel do sistema"
    echo "      3 - Verificar softwares instalados"
    echo "      4 - Versão do sistema operacional"
    echo "      5 - Verificar memória do equipamento"
    echo "      6 - Verificar serial number"
    echo "      7 - Verificar IP do sistema"      
    echo "      0 - Sair do menu"
    echo " "
    echo -n "Opção escolhida: "
    read opcao
    case $opcao in
        1)
            function processador() {
                TIME=2
                CPU_INFO=$(lscpu | grep "Model name" | cut -d ":" -f2 | sed -n '1p')
                echo "Modelo de CPU: $CPU_INFO"
                sleep $TIME
            }
            processador
            read -n 1 -p "<Enter> para menu principal"
            menuprincipal
            ;;
        
        2)
            function kernel() {
                KERNEL_VERSION=$(uname -r)
                echo "Versão do kernel: $KERNEL_VERSION"
            }
            kernel
            read -n 1 -p "<Enter> para menu principal"
            menuprincipal
            ;;
        
        3)
            function softwares() {
                TIME=2
                echo "Escolha uma opção abaixo para listar os programas!"
                echo "      1 - Listar programas do CentOS"
                echo "      2 - Instalar programas padrões"
                echo "      3 - Voltar ao menu principal"
                echo " "
                echo -n "Opção escolhida: "
                read alternative
                case $alternative in
                    1)
                        echo "Listando todos os programas instalados no CentOS..."
                        sleep $TIME
                        rpm -qa > /tmp/programas.txt
                        echo "A lista de programas foi gerada e está disponível no /tmp"
                        sleep $TIME
                        ;;
                    2)
                        echo "Instalando programas padrões..."
                        LIST_OF_APPS="pinta brasero gimp vlc inkscape blender filezilla"
                        sudo yum install -y $LIST_OF_APPS
                        ;;
                    3)
                        echo "Voltando para o menu principal..."
                        sleep $TIME
                        ;;
                    *)
                        echo "Opção inválida, tente novamente!"
                        ;;
                esac
            }
            softwares
            menuprincipal
            ;;
        
        4)
            function sistema() {
                VERSION=$(cat /etc/os-release | grep -i ^PRETTY_NAME)
                echo "A versão do seu sistema é: $VERSION"
            }
            sistema
            read -n 1 -p "<Enter> para menu principal"
            menuprincipal
            ;;
        
        5)
            function memory() {
                TIME=2
                MEMORY_FREE=$(free -m | grep ^Mem | tr -s ' ' | cut -d ' ' -f 4)
                MEMORY_TOTAL=$(free -m | grep ^Mem | tr -s ' ' | cut -d ' ' -f 2)
                MEMORY_USED=$(free -m | grep ^Mem | tr -s ' ' | cut -d ' ' -f 3)
                echo "Verificando a memória do sistema..."
                echo "A memória livre é: $MEMORY_FREE"
                sleep $TIME
                echo "A memória total é: $MEMORY_TOTAL"
                sleep $TIME
                echo "A memória usada é: $MEMORY_USED"
            }
            memory
            read -n 1 -p "<Enter> para menu principal"
            menuprincipal
            ;;
        
        6)
            function serial() {
                SERIAL_NUMBER=$(sudo dmidecode -t 1 | grep -i serial)
                echo "Serial Number: $SERIAL_NUMBER"
            }
            serial
            read -n 1 -p "<Enter> para menu principal"
            menuprincipal
            ;;
        
        7)
            function ip() {
                IP_SISTEMA=$(hostname -I)
                echo "O IP do seu sistema é: $IP_SISTEMA"
            }
            ip
            read -n 1 -p "<Enter> para menu principal"
            menuprincipal
            ;;
        
        0)
            echo "Saindo do sistema..."
            sleep 2
            exit 0
            ;;
        
        *)
            echo "Opção inválida, tente novamente!"
            menuprincipal
            ;;
    esac
}

menuprincipal