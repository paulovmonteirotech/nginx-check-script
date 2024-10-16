# 🐧 Instalação e Configuração do Ubuntu via WSL com Nginx

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![WSL](https://img.shields.io/badge/WSL-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

Este guia fornece instruções detalhadas para instalar o Ubuntu via WSL (Windows Subsystem for Linux), configurar o Git, instalar o Nginx e criar um sistema de monitoramento com scripts bash e PowerShell.

## 📋 Índice

1. [Instalação do Ubuntu via WSL](#instalação-do-ubuntu-via-wsl)
2. [Instalação e Configuração do Git](#instalação-e-configuração-do-git)
3. [Instalação do Nginx](#instalação-do-nginx)
4. [Script de Verificação do Nginx](#script-de-verificação-do-nginx)
5. [Configuração do Cron](#configuração-do-cron)
6. [Script PowerShell para Cópia de Logs](#script-powershell-para-cópia-de-logs)
7. [Página HTML para Exibição de Status](#página-html-para-exibição-de-status)
8. [Observações](#observações)

## 🚀 Instalação do Ubuntu via WSL

1. Abra o PowerShell como administrador e execute:

   ```powershell
   wsl --install
   ```

2. Para instalar uma versão específica do Ubuntu (por exemplo, 20.04):

   ```powershell
   wsl --install -d Ubuntu-20.04
   ```

3. Para listar distribuições disponíveis:

   ```powershell
   wsl -l -o
   ```

4. Após a instalação, abra o Ubuntu e defina o nome de usuário e senha.

> **Nota**: Para mudar para o usuário root, use o comando `sudo su` e insira a senha criada. Caso não faça isso será necessário usar o sudo para todos os comandos além de verificar as permições dos arquivos(principalmente os executaveis).
> 
> Sempre verifique o caminho para seus arquivos.

## 🔧 Instalação e Configuração do Git

1. Atualize os repositórios:

   ```bash
   sudo apt update
   sudo apt upgrade
   ```

2. Instale o Git:

   ```bash
   sudo apt install git
   ```

3. Verifique a instalação:

   ```bash
   git --version
   ```

4. Configure seu nome de usuário e email:

   ```bash
   git config --global user.name "Seu Nome"
   git config --global user.email "seu.email@example.com"
   ```

## 🌐 Instalação do Nginx

1. Instale o Nginx:

   ```bash
   sudo apt install nginx
   ```

2. Verifique a instalação:

   ```bash
   sudo systemctl status nginx
   ```

3. Inicie o serviço do Nginx:

   ```bash
   sudo systemctl start nginx
   ```

## 📊 Script de Verificação do Nginx

Crie um arquivo chamado `check_nginx.sh` com o seguinte conteúdo:

```bash
#!/bin/bash

# Habilitar depuração para ver cada comando sendo executado
set -x

# Diretórios de saída dos logs
LOG_DIR="/seu_caminho_/paulom/meu_projeto_nginx"
ONLINE_LOG="$LOG_DIR/online.log"
OFFLINE_LOG="$LOG_DIR/offline.log"
CONSOLIDATED_LOG="$LOG_DIR/on_and_offline.log"

# Verifica se os arquivos de log podem ser criados
echo "Verificando se os arquivos de log podem ser criados..." >> "$LOG_DIR/debug.log"

# Verifica se o diretório de logs existe
if [ ! -d "$LOG_DIR" ]; then
    echo "Diretório de logs não existe: $LOG_DIR" >> "$LOG_DIR/debug.log"
    exit 1
fi

# Verifica se o serviço Nginx está rodando
if systemctl is-active --quiet nginx; then
    STATUS="ONLINE"
    MESSAGE="Nginx está rodando normalmente."
    echo "Nginx está ONLINE" >> "$LOG_DIR/debug.log"
    # Grava no arquivo de log online
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$ONLINE_LOG"
    # Grava também no log consolidado
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$CONSOLIDATED_LOG"
else
    STATUS="OFFLINE"
    MESSAGE="Nginx está fora do ar."
    echo "Nginx está OFFLINE" >> "$LOG_DIR/debug.log"
    
    # Grava no arquivo de log offline
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$OFFLINE_LOG"
    
    # Grava também no log consolidado
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Nginx - $STATUS - $MESSAGE" >> "$CONSOLIDATED_LOG"
fi

# Copia os logs consolidados para o diretório público
sudo cp "$CONSOLIDATED_LOG" /var/www/html/logs_on_and_offline.txt

# Desabilitar depuração
set +x
```

## ⏱️ Configuração do Cron

1. Edite o crontab:

   ```bash
   crontab -e
   ```

2. Adicione a seguinte linha para executar o script a cada 5 minutos:

   ```
   */5 * * * * /caminho/para/check_nginx.sh
   ```

## 💾 Script PowerShell para Cópia de Logs

No Windows, crie um arquivo chamado `copy_logs.ps1` com o seguinte conteúdo:

```powershell
# Caminho do arquivo na máquina virtual (caminho de rede ou mapeado via SMB)
$sourceFile = "\\wsl$\Ubuntu-20.04\var\www\html\logs_on_and_offline.txt"

# Caminho do arquivo de destino na máquina física
$destinationFile = "D:\seucaminho\www\nginx\logs_on_and_offline.txt"

# Verifica se o arquivo existe na origem e copia para o destino na máquina física
if (Test-Path $sourceFile) { 
    Copy-Item -Path $sourceFile -Destination $destinationFile -Force
    Write-Host "Arquivo copiado com sucesso!"
} else {
    Write-Host "O arquivo não foi encontrado na máquina virtual."
}
```

 Configure este script como uma tarefa agendada no Windows para rodar a cada 5 minutos.
 ## ⏱️ Configuração do Agendador de Tarefas do Windows

Para configurar o script PowerShell para execução automática, você pode usar o Agendador de Tarefas do Windows. Siga estas etapas:

1. Abra o Agendador de Tarefas do Windows (pressione Win + R, digite "taskschd.msc" e pressione Enter).
2. No painel direito, clique em "Criar Tarefa Básica".
3. Dê um nome à tarefa, como "Cópia de Logs Nginx".
4. Escolha a frequência de execução (por exemplo, diariamente).
5. Defina a hora de início.
6. Escolha "Iniciar um programa" como ação.
7. Navegue até o local do seu script PowerShell e selecione-o.
8. Finalize a criação da tarefa.

Para instruções mais detalhadas sobre como usar o Agendador de Tarefas do Windows, consulte o [guia da Dell sobre agendamento de tarefas](https://www.dell.com/support/kbdoc/pt-br/000104417/usando-o-windows-task-scheduler-for-scheduled-raid-array-consistency-checks).

## 🖥️ Página HTML para Exibição de Status

Crie um arquivo HTML na mesma pasta do script PowerShell para mostrar os logs:

```html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="10">
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
    <div class="history" id="historico"></div>

    <script>
        function atualizarStatus() {
            fetch('logs_on_and_offline.txt')
                .then(response => response.text())
                .then(data => {
                    const linhas = data.trim().split('\n');
                    const ultimaLinha = linhas[linhas.length - 1];
                    const historico = linhas.reverse().join('<br>');

                    const ultimaAtualizacaoDiv = document.getElementById('ultima-atualizacao');
                    ultimaAtualizacaoDiv.innerHTML = ultimaLinha;
                
                    if (ultimaLinha.includes('ONLINE')) {
                        ultimaAtualizacaoDiv.classList.add('online');
                        ultimaAtualizacaoDiv.classList.remove('offline');
                    } else {
                        ultimaAtualizacaoDiv.classList.add('offline');
                        ultimaAtualizacaoDiv.classList.remove('online');
                    }

                    document.getElementById('historico').innerHTML = historico;
                })
                .catch(error => {
                    console.error('Erro ao carregar os logs:', error);
                });
        }

        setInterval(atualizarStatus, 10000);
        atualizarStatus();
    </script>
</body>
</html>
```

## 📝 Observações

Para rodar o Nginx no Ubuntu via WSL, ele usará a porta 80. Se você estiver executando outro servidor na máquina física (como o Apache2), será necessário mudar a porta de escuta desse servidor para 82 ou outra porta que não esteja em uso.

---

🌟 Lembresse de colocar os caminhos corretos para seus arquivos.
---

## 📚 Recursos Adicionais

Para mais informações sobre o Windows Subsystem for Linux (WSL), consulte a documentação oficial da Microsoft:

[Documentação do WSL](https://docs.microsoft.com/pt-br/windows/wsl/)
