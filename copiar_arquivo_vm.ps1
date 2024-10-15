# Caminho do arquivo na máquina virtual (caminho de rede ou mapeado via SMB)
$sourceFile = "\\wsl$\Ubuntu-20.04\var\www\html\logs_on_and_offline.txt"

# Caminho do arquivo de destino na máquina física
$destinationFile = "D:\wamp64\www\nginx\logs_on_and_offline.txt"

# Verifica se o arquivo existe na origem
if (Test-Path $sourceFile) {
    # Copia o arquivo para o destino na máquina física
    Copy-Item -Path $sourceFile -Destination $destinationFile -Force
    Write-Host "Arquivo copiado com sucesso!"
} else {
    Write-Host "O arquivo não foi encontrado na máquina virtual."
}
