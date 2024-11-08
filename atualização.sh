##[ Ficha ]##################################################
# Nome: script_inicializacao
# Escrito por: FelipeJosueTech
# Criado em: 19/05/2019
# Última atualização: 08/11/2024
##[ Descrição ]##############################################
# Atualização dos pacotes e limpeza do sistema para CentOS/RHEL usando yum

# Atualizar repositórios e pacotes
sudo yum check-update
sudo yum update -y

# Listar pacotes atualizáveis
echo "Pacotes disponíveis para atualização:"
sudo yum list updates

# Remover pacotes desnecessários
sudo yum autoremove -y

# Limpeza de cache
sudo yum clean all

echo "Atualização do sistema concluída!"
# Fim do script