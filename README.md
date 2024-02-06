## Atividade AWS e Linux - PB AWS e DevSecOps Compass UOL
Este repositório tem como objetivo documentar as etapas da atividade de AWS e Linux do programa de bolsas da Compass UOL.

### Requisitos AWS:
- Gerar uma chave pública para acesso ao ambiente;
- Criar um instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small,16 GB SSD);
- Gerar um elastic IP e anexar à instância EC2;
- Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP);

### Requisitos Linux:
- Configurar o NFS;
- Criar um diretório dentro do filesystem com seu nome;
- Subir um servidor Apache (o Apache deve estar online e rodando);
- Criar um script que valide se o serviço está online ou offline e que envie o resultado da validação para o diretorio do seu nfs;
- O script deve conter data, hora, nome do serviço, status e mensagem personalizada de online ou offline;
- O script deve gerar dois arquivos de saida: Um para o serviço online e um para o serviço offline;
- Preparar a execução automatizada do script a cada 5 minutos;

## Instruções de execução

### Gerar chave pública para acesso ao ambiente:
- Acesse o console AWS e entre no servico EC2.
- No menu lateral esquerdo, na seção de **Rede e segurança**, selecione **Pares de chaves**.
- Dentro de Pares de chaves, clique no botão **Criar par de chaves**.
- Nomeie sua chave, selecione o tipo de par de chaves como RSA e o formato da chave privada como .pem e então clique no botão **Criar par de chaves"**.
- Salvar o arquivo .pem em uma pasta segura.

### Criar instância EC2:
- Acesse o console AWS e entre no servico EC2.
- No menu lateral esquerdo, na seção de **Instâncias**, selecione **Instâncias**.
- Dentro da seção de Instâncias clique no botão **Executar instância**.
- Ao lado do campo de inserir nome, clique em **Adicionar mais tags**.
- Crie e insira o valor para as chaves: **Name, Project e CostCenter**, selecionando **Intancias**, **Volumes** como tipos de recursos.
- Selecione a AMI com sistema operacional Amazon Linux 2.
- Selecione o tipo de instância como t3.small.
- Selecione o par de chaves que foi criado anteriormente.
- Selecione 16 GB de armazenamento gp2 (SSD).
- Em configurações de rede, selecione Criar grupo de segurança, mantenha selecionado **Permitir tráfego SSH de** > **Qualquer lugar**.
- Clicar em **Executar instância**.

### Gerar Elastic IP e anexar à instância EC2:
- Acesse o console AWS e entre no servico EC2.
- No menu lateral esquerdo, na seção de **Rede e segurança**, selecione **IPs elásticos**.
- Clique no botão **Alocar endereço IP elástico**.
- Mantenha as configuração padrão e clique no botão **Alocar**.
- Depois de criado, selecione o IP alocado, clique no botão de **Ações** e então **Associar endereço IP elástico**. 
- Selecione a instância EC2 que foi criada anteriormente e então clique em **Associar**.

### Criar e configurar Gateway da internet:
- Acesse o console AWS e entre no serviço de VPC.
- No menu lateral esquerdo, na seção de **Nuvem privada virtual**, selecione **Gateway da internet**.
- Clique no botão **Criar gateway de internet**.
- Defina um nome para o gateway e clique no botão **Criar gateway de internet**.
- Selecione o gateway criado, clique no botão **Ações** e depois em **Associar à VPC**.
- Selecione a VPC da instância EC2 criada anteriormente e clique em **Associar**.

### Configurar Tabela de rotas:
- Acesse o console AWS e entre no serviço de VPC.
- No menu lateral esquerdo, na seção de **Nuvem privada virtual**, selecione **Tabela de rotas**.
- Selecione a tabela de rotas da VPC da instância EC2 que foi criada anteriormente.
- Clique no botão **Ações** e depois em **Editar rotas**.
- Clique em **Adicionar rota**
- Configure da seguinte forma: 
    ```
    Destino: 0.0.0.0/0 
    Alvo: Selecione o gateway da internet criado anteriormente.
    ```
- Clique em **Salvar alterações**.

### Liberar as portas de comunicação para acesso público:
Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e
UDP, 2049/TCP/UDP, 80/TCP, 443/TCP).


- Acesse o console AWS e entre no serviço de EC2.
- No menu lateral esquerdo, na seção de **Rede e segurança**, selecione **Grupos de segurança**.
- Selecione o grupo criado anteriormente junto com a instância.
- Clique em **Regras de entrada** e e depois em **Editar regras de entrada**.

    A regra de entrada (22/TCP) já foi configurada no momento da criação da instância, então adicione as demais: (111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP).

- Configurar as seguintes regras:

    | Tipo              | Protocolo | Intervalo de portas |   Origem  | Descrição |
    |-------------------|:---------:|:-------------------:|:---------:|:---------:|
    | SSH               |    TCP    |          22         | 0.0.0.0/0 |    SSH    |
    | TCP personalizado |    TCP    |          80         | 0.0.0.0/0 |    HTTP   |
    | TCP personalizado |    TCP    |         443         | 0.0.0.0/0 |   HTTPS   |
    | TCP personalizado |    TCP    |         111         | 0.0.0.0/0 |    RPC    |
    | TCP personalizado |    UDP    |         111         | 0.0.0.0/0 |    RPC    |
    | TCP personalizado |    TCP    |         2049        | 0.0.0.0/0 |    NFS    |
    | TCP personalizado |    UDP    |         2049        | 0.0.0.0/0 |    NFS    |

- Clicar em **Salvar regras**.

### Criar Elastic File System:
- Acesse o console AWS e entre no serviço de EFS.
- No menu lateral esquerdo, clique em **Sistemas de arquivos**.
- Depois clique no botão **Criar sistema de arquivos**.   

    - #### Etapa 1 - Configurações do sistema de arquivos:

        - Adicione um nome para o EFS.
        - No campo **Virtual Private Cloud (VPC)** selecione a VPC que foi utilizada anteriormente na crianção da instância.
        - Selecione a opção **personalizar**.
        - Marque a opção **One zone** e selecione a zona de disponibilidade em que sua EC2 está criada.
        - Em Gerenciamento de ciclo de vida, na opção **Transição para Achive** devemos mudar a configuração para **Nenhum**, pois o Archive não está disponível para sistemas de arquivos One Zone no momento dessa atividade.
        - Clique em **Próximo**.

    - #### Etapa 2 - Acesso à rede:
        - No campo **Grupos de segurança** selecione o grupo de segurança que foi utilizado anteriormente na crianção da instância.
        - Clique em **Próximo**.

    - #### Etapa 3 - (opcional) Política do sistema de arquivos:
        - Deixe tudo como padrão.
        - Clique em **Próximo**.
        
    - #### Etapa 4 - Revisar e Criar:
        - Revise e clique em **Criar** para finalizar.

- Após criar, copie o DNS do seu sistema de arquivos.

### Montar sistema de arquivos do EFS:
- Comece a configuração do NFS acessando sua máquina via SSH.
- Instale o pacote necessário para o funcionamento do seu NFS com o comando:
    ```
    sudo yum install nfs-utils
    ```
- Será necessário criar um diretório para a montagem do EFS com o comando:
    ```
    sudo mkdir /efs
    ```
- Agora devemos fazer a montagem do NFS e existem duas formas de fazer isso: Manual e Automática.

    - **Manual**: 
        Dessa forma será necessário montar toda vez que a máquina for iniciada, usando o comando abaixo:
        ```
        sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-02d33e49911d03ca4.efs.us-east-1.amazonaws.com:/ efs
        ```
        Antes de confirmar o comando você deve substituir o **fs-02d33e49911d03ca4.efs.us-east-1.amazonaws.com** pelo DNS do EFS que foi criado anteriormente.

    - **Automática**: 
        Para esse tipo de montagem é necessário editar o arquivo **/etc/fstab**, para isso use o comando:
        ```
        sudo nano /etc/fstab
        ```
        Adicione o seguinte comando no arquivo **fstab**:
        ```
        file_system_id.efs.aws-region.amazonaws.com:/ mount_point nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0
        ```
        Faça as seguintes alterações:
        - **file_system_id** deve ser substituído pelo DNS do sistema de arquivos que você está montando.
        - **aws-region** deve ser substituído pela região da AWS que está configurada no sistema de arquivos, como us-east-1.
        - **mount_point** deve ser substituído pelo ponto de montagem do sistema de arquivos, no meu caso /efs.
        - Exemplo: ```fs-02d33e49911d03ca4.efs.us-east-1.amazonaws.com:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0```

- Salve e feche o arquivo.
 
- Reinicie a instância.
    
    Após a reinicialização, o sistema de arquivos do EFS estará montado no diretório **/efs** e estará disponível para uso na instância. 

- Para verificar se o sistema de arquivos do EFS está realmente montado, execute o comando:
    ```
    df -h
    ```
    Este comando lista todos os sistemas de arquivos montados na instância, e se o EFS estiver montado corretamente, você verá a linha de saída que mostrará o sistema de arquivos do EFS e seus detalhes.

### Criar um diretório dentro do filesystem do NFS com seu nome:
- Execute o seguinte comando:
    ```
    sudo mkdir /efs/Seu_Nome
    ```
    - Substitua o a parte do comando **Seu_Nome** pelo seu próprio nome.
    - Exemplo: ```sudo mkdir /efs/JanainaACordisco```
    
### Configurar o servidor Apache:
- Atualize os pacotes do sistema com o comando:
    ```
    sudo yum update -y
    ```
- Instale o Apache executando o comando:
    ```
    sudo yum install httpd -y
    ```
- Após a conclusão da instalação, inicie o serviço do Apache com o comando:
    ```
    sudo systemctl start httpd.service
    ```
- Utilize o comando para habilitar o serviço do Apache para inicialização automática:
    ```
    sudo systemctl enable httpd.service
    ```
- Verifique se o Apache está em execução utilizando o comando:
    ```
    sudo service httpd status
    ```
- Vá até o diretório padrão dos arquivos do Apache com o comando:
    ```
    cd /var/www/html
    ```
- Verifique se tem um arquivo **index.html** no diretório com o comando:
    ```
    ls
    ```
- Caso não tenha o arquivo **index.html** na pasta, você pode criá-lo usando o comando:
    ```
    sudo nano index.html
    ```
- Copie e cole o conteúdo abaixo para dentro do index.html e salve o arquivo.
    ``` 
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Apache</title>
    </head>
    <body>
      <h1>Apache rodando com sucesso!</h1>
    </body>
    </html>
    ```

- Para verificar que o serviço Apache está rodando corretamente, você deverá colocar na barra de endereço do seu navegador o IP público atribuído à sua instância com o Elastic IP.
    - Exemplo:
        ``` 34.225.185.38```
- Se conseguir visulizar o conteúdo do arquivo **index.html** no seu navegador, significa que seu Apache está configurado corretamente.