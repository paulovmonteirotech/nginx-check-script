# 🐧 Instalação e Configuração do Ubuntu via WSL

<div align="center">

![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![WSL](https://img.shields.io/badge/WSL-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![Git](https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white)

</div>

Este guia fornece instruções detalhadas para instalar o Ubuntu via WSL (Windows Subsystem for Linux), configurar o Git, instalar o Nginx e criar um sistema de monitoramento simples.

## 📋 Índice

- [Instalação do Ubuntu via WSL](#instalação-do-ubuntu-via-wsl)
- [Instalação e Configuração do Git](#instalação-e-configuração-do-git)
- [Instalação do Nginx](#instalação-do-nginx)
- [Script de Verificação do Nginx](#script-de-verificação-do-nginx)
- [Configuração do Cron](#configuração-do-cron)
- [Cópia de Logs para Máquina Física](#cópia-de-logs-para-máquina-física)
- [Página HTML de Status](#página-html-de-status)
- [Observações](#observações)

## 🚀 Instalação do Ubuntu via WSL

1. Abra o PowerShell como administrador e execute:
   ```powershell
   wsl --install
   ```

2. Para instalar uma versão específica do Ubuntu:
   ```powershell
   wsl --install -d Ubuntu-20.04
   ```

3. Liste as distribuições disponíveis:
   ```powershell
   wsl -l -o
   ```

4. Após a instalação, abra o Ubuntu e defina o nome de usuário e senha.

> **Dica:** Use `sudo su` para mudar para o usuário root.

## 🔧 Instalação e Configuração do Git

1. Atualize os repositórios:
   ```bash
   sudo apt update && sudo apt upgrade
   ```

2. Instale o Git:
   ```bash
   sudo apt install git
   ```

3. Configure o Git:
   ```bash
   git config --global user.name "Seu Nome"
   git config --global user.email "seu.email@example.com"
   ```

## 🌐 Instalação do Nginx

1. Instale o Nginx:
   ```bash
   sudo apt install nginx
   ```

2. Verifique o status e inicie o serviço:
   ```bash
   sudo systemctl status nginx
   sudo systemctl start nginx
   ```

## 📊 Script de Verificação do Nginx

Crie um script `check_nginx.sh` para monitorar o status do Nginx:

<details>
<summary>Ver script</summary>

</details>

## 📝 Observações

Para rodar o Nginx no Ubuntu via WSL usando a porta 80, pode ser necessário mudar a porta de escuta de outros servidores na máquina física (como o Apache) para evitar conflitos.

---

<div align="center">
⭐ Se este guia foi útil, considere dar uma estrela no repositório!
</div>
