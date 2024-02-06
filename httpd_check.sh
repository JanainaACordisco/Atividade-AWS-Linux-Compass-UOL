#!/bin/bash

# Define a variável de ambiente TZ para o fuso horário de "America/Sao_Paulo".
export TZ=America/Sao_Paulo

# Obter data e hora atual
date_hour=$(date '+%d-%m-%Y %H:%M:%S')

# Verificar o status do serviço do httpd (Apache)
httpd_status=$(systemctl is-active httpd)

# Configurar o resultado da verificação
if [ "$httpd_status" == "active" ]; then
    echo "O serviço httpd está ONLINE."
    result="ONLINE"
    message="O serviço httpd está ONLINE."

    # Define o nome do arquivo de saída para o serviço online
    output_file="httpd_online.txt"
else
    echo "O serviço httpd está OFFLINE."
    result="OFFLINE"
    message="O serviço httpd está OFFLINE."

    # Define o nome do arquivo de saída para o serviço offline
    output_file="httpd_offline.txt"
fi

# Combinar todas informações
final_message="$date_hour - Serviço httpd - Status: $result - $message"

# Diretório no NFS
diretory_nfs="/efs/Seu_Nome"

# Cria o arquivo de resultado no diretório do NFS com as informações
echo "$final_message" > "$diretory_nfs/$output_file"

echo "Resultado da validação foi salvo em $diretory_nfs/$output_file."