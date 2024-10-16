# INSTALAR O UBUNTU VIA WSL

Habilitar o WSL:

Abra o PowerShell como administrador e execute:

wsl --install

Isso instalará o WSL 2 e o Ubuntu como subsistema padrão.

Instalar o Ubuntu 20.04 ou superior:

Se já não estiver instalado, use o seguinte comando para obter a versão desejada:

wsl --install -d Ubuntu-20.04

Se já tiver o WSL, pode listar distribuições disponíveis:

wsl -l -o

Após a instalação, abra o Ubuntu, defina o nome de usuário e senha.

---------------------------------------------------------------------------------------------------------------------------

# INSTALAÇÃO DO GIT

Atualize os repositórios:

sudo apt update

sudo apt upgrade

Instale o Git:

sudo apt install git

Verifique a instalação:

git --version

Configuração do Git

Configure seu nome de usuário:

git config --global user.name "Seu Nome"

Configure seu email:

git config --global user.email "seu.email@example.com"

---------------------------------------------------------------------------------------------------------------------------

# INSTALAÇÃO DO NGINX

Instale o Nginx:

sudo apt install nginx

Verifique a instalação:

sudo systemctl status nginx

Inicie o serviço do Nginx:

sudo systemctl start nginx

---------------------------------------------------------------------------------------------------------------------------
# SCRIPT PARA VERIFICAR O STATUS DO NGINX

SALVE O SEGUINTE SCRIPT COMO check_nginx.sh:

---------------------------------------------------------------------------------------------------------------------------
#!/bin/bash

#Habilitar depuração para ver cada comando sendo executado

set -x
#Diretórios de saída dos logs

LOG_DIR="/seu_caminho_/paulom/meu_projeto_nginx"

ONLINE_LOG="$LOG_DIR/online.log"

OFFLINE_LOG="$LOG_DIR/offline.log"

CONSOLIDATED_LOG="$LOG_DIR/on_and_offline.log"

#Verifica se os arquivos de log podem ser criados

echo "Verificando se os arquivos de log podem ser criados..." >> "$LOG_DIR/debug.log"

#Verifica se o diretório de logs existe

if [ ! -d "$LOG_DIR" ]; then
    echo "Diretório de logs não existe: $LOG_DIR" >> "$LOG_DIR/debug.log"
    exit 1
fi

#Verifica se o serviço Nginx está rodando

if systemctl is-active --quiet nginx; then
    STATUS="ONLINE"
    MESSAGE="Nginx está rodando normalmente."
    echo "Nginx está ONLINE" >> "$LOG_DIR/debug.log"
#Grava no arquivo de log online
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$ONLINE_LOG"
#Grava também no log consolidado
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$CONSOLIDATED_LOG"
else
    STATUS="OFFLINE"
    MESSAGE="Nginx está fora do ar."
    echo "Nginx está OFFLINE" >> "$LOG_DIR/debug.log"
    
#Grava no arquivo de log offline
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$OFFLINE_LOG"
    
#Grava também no log consolidado
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$CONSOLIDATED_LOG"
fi

#Copia os logs consolidados para o diretório público

sudo cp "$CONSOLIDATED_LOG" /var/www/html/logs_on_and_offline.txt

#Desabilitar depuração

set +x

---------------------------------------------------------------------------------------------------------------------------
# CONFIGURAÇÃO DO CRON

EDITE O CRONTAB:

crontab -e

Adicione a seguinte linha para executar o script a cada 5 minutos:

*/5 * * * * /caminho/para/check_nginx.sh

---------------------------------------------------------------------------------------------------------------------------
# PARA COPIAR OS ARQUIVOS PARA A MÁQUINA FÍSICA E ATUALIZR UMA PAGINA HTML EM UM SERVIDOR WEB LOCAL, UTILIZE O SEGUINTE SCRIPT:
SCRIPT POWER SHELL NA MÁQUINA FÍSICA

Crie um script PowerShell como copy_logs.ps1:

---------------------------------------------------------------------------------------------------------------------------
#Caminho do arquivo na máquina virtual (caminho de rede ou mapeado via SMB)

$sourceFile = "\\wsl$\Ubuntu-20.04\var\www\html\logs_on_and_offline.txt"

#Caminho do arquivo de destino na máquina física

$destinationFile = "D:\seucaminho\www\nginx\logs_on_and_offline.txt"

#Verifica se o arquivo existe na origem

#Copia o arquivo para o destino na máquina física

if (Test-Path $sourceFile) { 
Copy-Item -Path $sourceFile -Destination $destinationFile -Force
    Write-Host "Arquivo copiado com sucesso!"
} else {
    Write-Host "O arquivo não foi encontrado na máquina virtual."
}

---------------------------------------------------------------------------------------------------------------------------
# CONFIGURE ESTE SCRIPT COMO UMA TAREFA AGENDADA NO WINDOWS PARA RODAR A CADA 5 MINUTOS.

NA MESMA PASTA DO SCRIPT ANTERIOR, CRIE UM ARQUIVO HTML PARA MOSTRAR OS LOGS:

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="10"> <!-- Atualiza a página a cada 10 segundos -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Status do Servidor</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1, h2 {
            color: #333;
        }
        .status {
            background-color: #f0f0f0;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .status.online {
            border-left: 5px solid green;
        }
        .status.offline {
            border-left: 5px solid red;
        }
        .history {
            max-height: 400px;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h1>Status do Servidor Nginx</h1>
    <div id="ultima-atualizacao" class="status"></div>
    
    <h2>Histórico de Atualizações</h2>
    <div class="history" id="historico">
        <!-- O histórico será carregado aqui -->
    </div>

    <script>
        // Função para fazer a requisição AJAX e atualizar a página
        function atualizarStatus() {
            fetch('logs_on_and_offline.txt')
                .then(response => response.text())
                .then(data => {
                    const linhas = data.trim().split('\n');
                    const ultimaLinha = linhas[linhas.length - 1];
                    const historico = linhas.reverse().join('<br>');

                    // Atualizar última atualização
                    const ultimaAtualizacaoDiv = document.getElementById('ultima-atualizacao');
                    ultimaAtualizacaoDiv.innerHTML = ultimaLinha;
                    
                    if (ultimaLinha.includes('ONLINE')) {
                        ultimaAtualizacaoDiv.classList.add('online');
                        ultimaAtualizacaoDiv.classList.remove('offline');
                    } else {
                        ultimaAtualizacaoDiv.classList.add('offline');
                        ultimaAtualizacaoDiv.classList.remove('online');
                    }

                    // Atualizar histórico completo
                    document.getElementById('historico').innerHTML = historico;
                })
                .catch(error => {
                    console.error('Erro ao carregar os logs:', error);
                });
        }

        // Atualizar a página a cada 10 segundos
        setInterval(atualizarStatus, 10000);
        atualizarStatus();
    </script>
</body>
</html>

---------------------------------------------------------------------------------------------------------------------------------
# OBS.:
Para rodar o nginx no ubuntu via wsl estrá usando a porta 80, logo para rodar outro servidor na física (no meu caso o apache2) é necessário mudar a porta de escuta do apache para 82 ou outra porta que não esteja em uso.
