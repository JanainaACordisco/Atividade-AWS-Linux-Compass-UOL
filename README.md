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
