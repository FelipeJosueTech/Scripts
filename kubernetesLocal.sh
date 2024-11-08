#!/bin/bash

##[ Ficha ]##################################################
# Nome: script_inicializacao
# Escrito por: FelipeJosueTech
# Criado em: 05/07/2020
# Última atualização: 06/11/2024
##[ Descrição ]##############################################
# Script de instalação do Kubernetes no CentOs.
#############################################################
# Função para instalar o kubectl
install_kubectl() {
    echo "Instalando kubectl..."
    # Baixar a versão estável mais recente do kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    # Tornar o kubectl executável
    chmod +x kubectl
    # Mover kubectl para o diretório de binários do sistema
    sudo mv kubectl /usr/local/bin/
    # Verificar versão instalada
    kubectl version --client --short
}

# Função para instalar o kind
install_kind() {
    echo "Instalando kind..."
    # Baixar a versão especificada do kind
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    # Tornar o kind executável
    chmod +x ./kind
    # Mover kind para o diretório de binários do sistema
    sudo mv ./kind /usr/local/bin/kind
    # Verificar versão instalada
    kind version
}

# Executar funções de instalação
install_kubectl
install_kind

echo "Instalação de kubectl e kind concluída."