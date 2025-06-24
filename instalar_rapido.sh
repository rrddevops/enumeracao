#!/bin/bash

echo "🚀 Instalação RÁPIDA das ferramentas essenciais..."
echo "================================================="

# Verificar Go
if ! command -v go &> /dev/null; then
    echo "❌ Go não está instalado. Instalando..."
    sudo apt update && sudo apt install -y golang-go
fi

echo "✅ Go encontrado: $(go version)"

# Criar diretórios
mkdir -p ~/tools ~/wordlists

# 1. Ferramentas Go ESSENCIAIS (mais confiáveis)
echo "[1/4] Instalando ferramentas Go essenciais..."

echo "Instalando Amass..."
go install github.com/OWASP/Amass/v4/...@latest

echo "Instalando Subfinder..."
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

echo "Instalando Httpx..."
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

echo "Instalando Nuclei..."
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

echo "Instalando Assetfinder..."
go install github.com/tomnomnom/assetfinder@latest

echo "Instalando Gau..."
go install github.com/tomnomnom/gau@latest

echo "Instalando Waybackurls..."
go install github.com/tomnomnom/waybackurls@latest

echo "Instalando Hakrawler..."
go install github.com/hakluke/hakrawler@latest

echo "Instalando Ffuf..."
go install github.com/ffuf/ffuf@latest

echo "Instalando Gospider..."
go install github.com/jaeles-project/gospider@latest

echo "Instalando Dalfox..."
go install github.com/hahwul/dalfox/v2@latest

# 2. Ferramentas Python ESSENCIAIS
echo "[2/4] Instalando ferramentas Python essenciais..."

echo "Instalando Sublist3r..."
pip3 install sublist3r

echo "Instalando TheHarvester..."
pip3 install theHarvester

echo "Instalando Subjack..."
pip3 install subjack

echo "Instalando Paramspider..."
pip3 install paramspider

echo "Instalando Dnsgen..."
pip3 install dnsgen

echo "Instalando Shodan CLI..."
pip3 install shodan

echo "Instalando Censys..."
pip3 install censys

echo "Instalando Wafw00f..."
pip3 install wafw00f

# 3. Ferramentas binárias ESSENCIAIS
echo "[3/4] Instalando ferramentas binárias essenciais..."

# Findomain
echo "Instalando Findomain..."
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux
if [ -f findomain-linux ]; then
    chmod +x findomain-linux
    sudo mv findomain-linux /usr/local/bin/findomain
    echo "✅ Findomain instalado"
fi

# Massdns
echo "Instalando Massdns..."
if git clone https://github.com/blechschmidt/massdns.git 2>/dev/null; then
    cd massdns && make && sudo cp bin/massdns /usr/local/bin && cd ..
    echo "✅ Massdns instalado"
fi

# Cloud_enum
echo "Instalando Cloud_enum..."
if git clone https://github.com/initstring/cloud_enum.git 2>/dev/null; then
    cd cloud_enum && pip3 install -r requirements.txt && cd ..
    echo "✅ Cloud_enum instalado"
fi

# Arjun
echo "Instalando Arjun..."
if git clone https://github.com/s0md3v/Arjun.git 2>/dev/null; then
    cd Arjun && pip3 install -r requirements.txt && cd ..
    echo "✅ Arjun instalado"
fi

# GF patterns
echo "Instalando GF patterns..."
mkdir -p ~/.gf
if git clone https://github.com/tomnomnom/gf.git 2>/dev/null; then
    cp -r gf/examples/* ~/.gf/
    rm -rf gf
    echo "✅ GF patterns instalado"
fi

# 4. Verificação final
echo "[4/4] Verificando instalações..."

# Lista de ferramentas essenciais
essential_tools=(
    "amass"
    "subfinder"
    "httpx"
    "nuclei"
    "assetfinder"
    "gau"
    "waybackurls"
    "hakrawler"
    "ffuf"
    "gospider"
    "dalfox"
    "findomain"
    "massdns"
    "cloud_enum"
    "arjun"
    "sublist3r"
    "theHarvester"
    "subjack"
    "paramspider"
    "dnsgen"
    "shodan"
    "censys"
    "wafw00f"
)

echo "Verificando ferramentas essenciais:"
instaladas=0
total=${#essential_tools[@]}

for tool in "${essential_tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool - INSTALADO"
        ((instaladas++))
    else
        echo "❌ $tool - NÃO ENCONTRADO"
    fi
done

echo ""
echo "📊 RESUMO:"
echo "   ✅ Ferramentas instaladas: $instaladas/$total"
echo "   📈 Taxa de sucesso: $((instaladas * 100 / total))%"

if [ $instaladas -gt $((total * 3 / 4)) ]; then
    echo ""
    echo "🎉 Instalação bem-sucedida! Você tem as ferramentas essenciais."
    echo "🚀 Agora você pode usar os scripts de enumeração!"
else
    echo ""
    echo "⚠️ Algumas ferramentas não foram instaladas."
    echo "💡 Execute: ./instalar_faltantes.sh para tentar instalar as restantes"
fi

echo ""
echo "🔄 Execute: source ~/.bashrc"
echo "🔍 Execute: ./verificar_instalacao.sh" 