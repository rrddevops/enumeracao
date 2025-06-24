#!/bin/bash

echo "🔧 Instalando ferramentas faltantes..."
echo "====================================="

# Verificar se Go está no PATH
if ! command -v go &> /dev/null; then
    echo "❌ Go não está instalado ou não está no PATH"
    exit 1
fi

echo "✅ Go encontrado: $(go version)"

# Criar diretórios necessários
mkdir -p ~/tools
mkdir -p ~/wordlists

# 1. Ferramentas Go (mais confiáveis)
echo "[1/5] Instalando ferramentas Go..."

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

echo "Instalando Gitrob..."
go install github.com/toniblyx/gitrob@latest

echo "Instalando Ffuf..."
go install github.com/ffuf/ffuf@latest

echo "Instalando Gospider..."
go install github.com/jaeles-project/gospider@latest

echo "Instalando Dalfox..."
go install github.com/hahwul/dalfox/v2@latest

echo "Instalando Meg..."
go install github.com/tomnomnom/meg@latest

echo "Instalando Unfurl..."
go install github.com/tomnomnom/unfurl@latest

echo "Instalando Mapcidr..."
go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

echo "Instalando Shuffledns..."
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest

echo "Instalando Dnsx..."
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest

echo "Instalando Naabu..."
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest

echo "Instalando Gfredirect..."
go install github.com/tomnomnom/gfredirect@latest

# 2. Ferramentas Python
echo "[2/5] Instalando ferramentas Python..."

echo "Instalando Sublist3r..."
pip3 install sublist3r

echo "Instalando TheHarvester..."
pip3 install theHarvester

echo "Instalando Metagoofil..."
pip3 install metagoofil

echo "Instalando Subjack..."
pip3 install subjack

echo "Instalando Paramspider..."
pip3 install paramspider

echo "Instalando XSStrike..."
pip3 install xsstrike

echo "Instalando Dnsgen..."
pip3 install dnsgen

echo "Instalando Shodan CLI..."
pip3 install shodan

echo "Instalando Censys..."
pip3 install censys

echo "Instalando Wafw00f..."
pip3 install wafw00f

echo "Instalando Waymore..."
pip3 install waymore

echo "Instalando Recon-ng..."
pip3 install recon-ng

echo "Instalando Spiderfoot..."
pip3 install spiderfoot

echo "Instalando GitHub-dorker..."
pip3 install github-dorker

# 3. Ferramentas específicas
echo "[3/5] Instalando ferramentas específicas..."

# Findomain
echo "Instalando Findomain..."
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux
if [ -f findomain-linux ]; then
    chmod +x findomain-linux
    sudo mv findomain-linux /usr/local/bin/findomain
    echo "✅ Findomain instalado"
else
    echo "❌ Findomain não pôde ser baixado"
fi

# Massdns
echo "Instalando Massdns..."
if git clone https://github.com/blechschmidt/massdns.git 2>/dev/null; then
    cd massdns && make && sudo cp bin/massdns /usr/local/bin && cd ..
    echo "✅ Massdns instalado"
else
    echo "❌ Massdns não pôde ser instalado"
fi

# Cloud_enum
echo "Instalando Cloud_enum..."
if git clone https://github.com/initstring/cloud_enum.git 2>/dev/null; then
    cd cloud_enum && pip3 install -r requirements.txt && cd ..
    echo "✅ Cloud_enum instalado"
else
    echo "❌ Cloud_enum não pôde ser instalado"
fi

# Arjun
echo "Instalando Arjun..."
if git clone https://github.com/s0md3v/Arjun.git 2>/dev/null; then
    cd Arjun && pip3 install -r requirements.txt && cd ..
    echo "✅ Arjun instalado"
else
    echo "❌ Arjun não pôde ser instalado"
fi

# Sublist3r
echo "Instalando Sublist3r (git)..."
if git clone https://github.com/aboul3la/Sublist3r.git 2>/dev/null; then
    cd Sublist3r && pip3 install -r requirements.txt && cd ..
    echo "✅ Sublist3r instalado"
else
    echo "❌ Sublist3r não pôde ser instalado"
fi

# GF patterns
echo "Instalando GF patterns..."
mkdir -p ~/.gf
if git clone https://github.com/tomnomnom/gf.git 2>/dev/null; then
    cp -r gf/examples/* ~/.gf/
    rm -rf gf
    echo "✅ GF patterns instalado"
else
    echo "❌ GF patterns não pôde ser instalado"
fi

# 4. Ferramentas que precisam de instalação manual
echo "[4/5] Instalando ferramentas manuais..."

# WPScan
echo "Instalando WPScan..."
sudo gem install wpscan 2>/dev/null && echo "✅ WPScan instalado" || echo "❌ WPScan não pôde ser instalado"

# Git-secrets
echo "Instalando Git-secrets..."
if git clone https://github.com/awslabs/git-secrets.git 2>/dev/null; then
    cd git-secrets && sudo make install && cd ..
    echo "✅ Git-secrets instalado"
else
    echo "❌ Git-secrets não pôde ser instalado"
fi

# 5. Verificar instalações
echo "[5/5] Verificando instalações..."

# Lista de ferramentas para verificar
tools=(
    "amass"
    "subfinder"
    "httpx"
    "nuclei"
    "assetfinder"
    "gau"
    "waybackurls"
    "hakrawler"
    "gitrob"
    "ffuf"
    "gospider"
    "dalfox"
    "meg"
    "unfurl"
    "mapcidr"
    "shuffledns"
    "dnsx"
    "naabu"
    "gfredirect"
    "findomain"
    "massdns"
    "cloud_enum"
    "arjun"
    "sublist3r"
    "wpscan"
    "git-secrets"
)

echo "Verificando ferramentas instaladas:"
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool - INSTALADO"
    else
        echo "❌ $tool - NÃO ENCONTRADO"
    fi
done

echo ""
echo "✅ Instalação concluída!"
echo "🔄 Execute: source ~/.bashrc"
echo "🔍 Execute: ./verificar_instalacao.sh" 