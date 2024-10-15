#!/bin/bash

# Habilitar depuração para ver cada comando sendo executado
set -x

# Diretórios de saída dos logs
LOG_DIR="/paulom/meu_projeto_nginx"
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

