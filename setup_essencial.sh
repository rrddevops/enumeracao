#!/bin/bash

echo "🔧 Iniciando instalação das ferramentas ESSENCIAIS de enumeração..."
echo "================================================================"

# Atualizar sistema
echo "[1/6] Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo "[2/6] Instalando dependências básicas..."
sudo apt install -y \
  python3 \
  python3-pip \
  git \
  wget \
  curl \
  unzip \
  golang-go \
  ruby-full \
  nmap \
  whatweb \
  fierce \
  dnsrecon \
  dnsenum \
  dirb \
  gobuster \
  masscan \
  dnswalk \
  seclists

# Configurar Go
echo "[3/6] Configurando Go..."
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# Instalar ferramentas Python essenciais
echo "[4/6] Instalando ferramentas Python essenciais..."
pip3 install --upgrade pip
pip3 install \
  ffuf \
  nuclei \
  theHarvester \
  subjack \
  dalfox \
  paramspider \
  xsstrike \
  sublist3r \
  httpx \
  gau \
  waybackurls \
  hakrawler \
  gospider \
  meg \
  unfurl \
  shodan \
  censys \
  wafw00f \
  dnsgen

# Instalar ferramentas Go essenciais
echo "[5/6] Instalando ferramentas Go essenciais..."
go install github.com/tomnomnom/gf@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/gau@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/OWASP/Amass/v4/...@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/toniblyx/gitrob@latest
go install github.com/greenbone/gospider@latest
go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/meg@latest
go install github.com/tomnomnom/unfurl@latest
go install github.com/hahwul/dalfox/v2@latest
go install github.com/jaeles-project/gospider@latest

# Instalar ferramentas específicas essenciais
echo "[6/6] Instalando ferramentas específicas essenciais..."

# Findomain
echo "Instalando Findomain..."
curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux 2>/dev/null
if [ -f findomain-linux ]; then
    chmod +x findomain-linux
    sudo mv findomain-linux /usr/local/bin/findomain
    echo "✅ Findomain instalado com sucesso"
else
    echo "⚠️ Findomain não pôde ser baixado"
fi

# Massdns
echo "Instalando Massdns..."
if git clone https://github.com/blechschmidt/massdns.git 2>/dev/null; then
    cd massdns && make && sudo cp bin/massdns /usr/local/bin && cd ..
    echo "✅ Massdns instalado com sucesso"
else
    echo "⚠️ Massdns não pôde ser instalado"
fi

# Cloud_enum
echo "Instalando Cloud_enum..."
if git clone https://github.com/initstring/cloud_enum.git 2>/dev/null; then
    cd cloud_enum && pip3 install -r requirements.txt && cd ..
    echo "✅ Cloud_enum instalado com sucesso"
else
    echo "⚠️ Cloud_enum não pôde ser instalado"
fi

# Arjun
echo "Instalando Arjun..."
if git clone https://github.com/s0md3v/Arjun.git 2>/dev/null; then
    cd Arjun && pip3 install -r requirements.txt && cd ..
    echo "✅ Arjun instalado com sucesso"
else
    echo "⚠️ Arjun não pôde ser instalado"
fi

# WPScan
echo "Instalando WPScan..."
sudo gem install wpscan 2>/dev/null && echo "✅ WPScan instalado com sucesso" || echo "⚠️ WPScan não pôde ser instalado"

# Sublist3r
echo "Instalando Sublist3r..."
if git clone https://github.com/aboul3la/Sublist3r.git 2>/dev/null; then
    cd Sublist3r && pip3 install -r requirements.txt && cd ..
    echo "✅ Sublist3r instalado com sucesso"
else
    echo "⚠️ Sublist3r não pôde ser instalado"
fi

# GF patterns
echo "Instalando GF patterns..."
mkdir -p ~/.gf
if git clone https://github.com/tomnomnom/gf.git 2>/dev/null; then
    cp -r gf/examples/* ~/.gf/
    rm -rf gf
    echo "✅ GF patterns instalado com sucesso"
else
    echo "⚠️ GF patterns não pôde ser instalado"
fi

# Criar diretórios necessários
echo "Criando diretórios..."
mkdir -p ~/tools
mkdir -p ~/wordlists
mkdir -p ~/results

# Configurar PATH final
echo "Configurando PATH..."
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc

echo ""
echo "✅ Instalação ESSENCIAL concluída!"
echo "=================================================="
echo "🔧 Ferramentas essenciais instaladas:"
echo "   - Enumeração: Amass, Subfinder, Assetfinder, Findomain, Sublist3r"
echo "   - Verificação: Httpx, Nmap, Whatweb"
echo "   - URLs: Waybackurls, Gau, Hakrawler"
echo "   - Fuzzing: Ffuf, Gobuster, Dirb"
echo "   - DNS: Dnsrecon, Dnsenum, Fierce, Massdns"
echo "   - Vulnerabilidades: Nuclei, WPScan, XSStrike, Dalfox"
echo "   - Parâmetros: Arjun, Paramspider"
echo "   - Cloud: Cloud_enum"
echo "   - Outras: TheHarvester, Gitrob, Gospider"
echo ""
echo "📁 Diretórios criados:"
echo "   - ~/tools/ - Ferramentas adicionais"
echo "   - ~/wordlists/ - Wordlists"
echo "   - ~/results/ - Resultados"
echo ""
echo "🔄 Para aplicar as mudanças, execute:"
echo "   source ~/.bashrc"
echo ""
echo "🚀 Agora você pode usar o script enum.sh!"
echo ""
echo "💡 Esta instalação inclui apenas as ferramentas mais estáveis e essenciais."
echo "   Para instalar todas as ferramentas, use ./setup.sh" 