#!/bin/bash

echo "🔧 Iniciando instalação das ferramentas de enumeração..."
echo "=================================================="

# Atualizar sistema
echo "[1/10] Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo "[2/10] Instalando dependências básicas..."
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
  seclists \
  chromium-browser \
  build-essential \
  libpcap-dev \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libffi-dev \
  liblzma-dev \
  libgdbm-dev \
  libnss3-dev \
  libatk-bridge2.0-dev \
  libgtk-3-dev \
  libxss-dev

# Configurar Go
echo "[3/10] Configurando Go..."
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# Instalar ferramentas Python
echo "[4/10] Instalando ferramentas Python..."
pip3 install --upgrade pip
pip3 install \
  ffuf \
  gowitness \
  nuclei \
  metagoofil \
  theHarvester \
  git-secrets \
  subjack \
  dalfox \
  paramspider \
  xsstrike \
  by4xx \
  waybackpacket \
  ctfr \
  dnsvalidator \
  sublist3r \
  assetfinder \
  findomain \
  httpx \
  gau \
  waybackurls \
  hakrawler \
  gospider \
  meg \
  waymore \
  unfurl \
  recon-ng \
  spiderfoot \
  shodan \
  censys \
  wafw00f \
  vhost \
  mapcidr \
  tko-subs \
  github-dorker \
  gfredirect

# Instalar ferramentas Go
echo "[5/10] Instalando ferramentas Go..."
go install github.com/tomnomnom/gf@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/tomnomnom/gau@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/OWASP/Amass/v4/...@latest
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install github.com/toniblyx/gitrob@latest
go install github.com/greenbone/gospider@latest
go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest

# Instalar ferramentas específicas
echo "[6/10] Instalando ferramentas específicas..."

# Metabigor (tentar com git clone público)
echo "Instalando Metabigor..."
if git clone https://github.com/j3ssie/metabigor.git 2>/dev/null; then
    cd metabigor && chmod +x metabigor && sudo cp metabigor /usr/local/bin && cd ..
    echo "✅ Metabigor instalado com sucesso"
else
    echo "⚠️ Metabigor não pôde ser instalado via git, tentando download direto..."
    wget -O metabigor https://github.com/j3ssie/metabigor/releases/latest/download/metabigor_linux_amd64 2>/dev/null || echo "⚠️ Metabigor não disponível"
    if [ -f metabigor ]; then
        chmod +x metabigor && sudo mv metabigor /usr/local/bin/
        echo "✅ Metabigor instalado via download"
    fi
fi

# Massdns
echo "Instalando Massdns..."
if git clone https://github.com/blechschmidt/massdns.git 2>/dev/null; then
    cd massdns && make && sudo cp bin/massdns /usr/local/bin && cd ..
    echo "✅ Massdns instalado com sucesso"
else
    echo "⚠️ Massdns não pôde ser instalado"
fi

# Kiterunner
echo "Instalando Kiterunner..."
if git clone https://github.com/assetnote/kiterunner.git 2>/dev/null; then
    cd kiterunner && ./install.sh && cd ..
    echo "✅ Kiterunner instalado com sucesso"
else
    echo "⚠️ Kiterunner não pôde ser instalado"
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

# Xray
echo "Instalando Xray..."
wget https://github.com/chaitin/xray/releases/download/1.9.13/xray_linux_amd64.zip 2>/dev/null
if [ -f xray_linux_amd64.zip ]; then
unzip xray_linux_amd64.zip
chmod +x xray
sudo mv xray /usr/local/bin/
    rm xray_linux_amd64.zip
    echo "✅ Xray instalado com sucesso"
else
    echo "⚠️ Xray não pôde ser baixado"
fi

# WPScan
echo "Instalando WPScan..."
sudo gem install wpscan 2>/dev/null && echo "✅ WPScan instalado com sucesso" || echo "⚠️ WPScan não pôde ser instalado"

# Sn1per
echo "Instalando Sn1per..."
if git clone https://github.com/1N3/Sn1per.git 2>/dev/null; then
    cd Sn1per && sudo ./install.sh && cd ..
    echo "✅ Sn1per instalado com sucesso"
else
    echo "⚠️ Sn1per não pôde ser instalado"
fi

# Instalar ferramentas adicionais
echo "[7/10] Instalando ferramentas adicionais..."

# Sublist3r
echo "Instalando Sublist3r..."
if git clone https://github.com/aboul3la/Sublist3r.git 2>/dev/null; then
    cd Sublist3r && pip3 install -r requirements.txt && cd ..
    echo "✅ Sublist3r instalado com sucesso"
else
    echo "⚠️ Sublist3r não pôde ser instalado"
fi

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

# Assetfinder
echo "Instalando Assetfinder..."
go install github.com/tomnomnom/assetfinder@latest 2>/dev/null && echo "✅ Assetfinder instalado com sucesso" || echo "⚠️ Assetfinder não pôde ser instalado"

# GitHub Search
echo "Instalando GitHub Search..."
pip3 install github-search 2>/dev/null && echo "✅ GitHub Search instalado com sucesso" || echo "⚠️ GitHub Search não pôde ser instalado"

# Gitrob
echo "Instalando Gitrob..."
go install github.com/toniblyx/gitrob@latest 2>/dev/null && echo "✅ Gitrob instalado com sucesso" || echo "⚠️ Gitrob não pôde ser instalado"

# MEG
echo "Instalando MEG..."
go install github.com/tomnomnom/meg@latest 2>/dev/null && echo "✅ MEG instalado com sucesso" || echo "⚠️ MEG não pôde ser instalado"

# Waymore
echo "Instalando Waymore..."
pip3 install waymore 2>/dev/null && echo "✅ Waymore instalado com sucesso" || echo "⚠️ Waymore não pôde ser instalado"

# Unfurl
echo "Instalando Unfurl..."
go install github.com/tomnomnom/unfurl@latest 2>/dev/null && echo "✅ Unfurl instalado com sucesso" || echo "⚠️ Unfurl não pôde ser instalado"

# Dalfox
echo "Instalando Dalfox..."
go install github.com/hahwul/dalfox/v2@latest 2>/dev/null && echo "✅ Dalfox instalado com sucesso" || echo "⚠️ Dalfox não pôde ser instalado"

# Gospider
echo "Instalando Gospider..."
go install github.com/jaeles-project/gospider@latest 2>/dev/null && echo "✅ Gospider instalado com sucesso" || echo "⚠️ Gospider não pôde ser instalado"

# Recon-ng
echo "Instalando Recon-ng..."
pip3 install recon-ng 2>/dev/null && echo "✅ Recon-ng instalado com sucesso" || echo "⚠️ Recon-ng não pôde ser instalado"

# Spiderfoot
echo "Instalando Spiderfoot..."
pip3 install spiderfoot 2>/dev/null && echo "✅ Spiderfoot instalado com sucesso" || echo "⚠️ Spiderfoot não pôde ser instalado"

# Shodan CLI
echo "Instalando Shodan CLI..."
pip3 install shodan 2>/dev/null && echo "✅ Shodan CLI instalado com sucesso" || echo "⚠️ Shodan CLI não pôde ser instalado"

# Censys
echo "Instalando Censys..."
pip3 install censys 2>/dev/null && echo "✅ Censys instalado com sucesso" || echo "⚠️ Censys não pôde ser instalado"

# Wafw00f
echo "Instalando Wafw00f..."
pip3 install wafw00f 2>/dev/null && echo "✅ Wafw00f instalado com sucesso" || echo "⚠️ Wafw00f não pôde ser instalado"

# Vhost
echo "Instalando Vhost..."
go install github.com/hakluke/hakvhost@latest 2>/dev/null && echo "✅ Vhost instalado com sucesso" || echo "⚠️ Vhost não pôde ser instalado"

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

# Git-secrets
echo "Instalando Git-secrets..."
if git clone https://github.com/awslabs/git-secrets.git 2>/dev/null; then
    cd git-secrets && sudo make install && cd ..
    echo "✅ Git-secrets instalado com sucesso"
else
    echo "⚠️ Git-secrets não pôde ser instalado"
fi

# Shuffledns
echo "Instalando Shuffledns..."
go install github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest 2>/dev/null && echo "✅ Shuffledns instalado com sucesso" || echo "⚠️ Shuffledns não pôde ser instalado"

# DNSgen
echo "Instalando DNSgen..."
pip3 install dnsgen 2>/dev/null && echo "✅ DNSgen instalado com sucesso" || echo "⚠️ DNSgen não pôde ser instalado"

# Mapcidr
echo "Instalando Mapcidr..."
go install github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest 2>/dev/null && echo "✅ Mapcidr instalado com sucesso" || echo "⚠️ Mapcidr não pôde ser instalado"

# TKO-subs
echo "Instalando TKO-subs..."
if git clone https://github.com/anshumanbh/tko-subs.git 2>/dev/null; then
    cd tko-subs && pip3 install -r requirements.txt && cd ..
    echo "✅ TKO-subs instalado com sucesso"
else
    echo "⚠️ TKO-subs não pôde ser instalado"
fi

# GitHub-dorker
echo "Instalando GitHub-dorker..."
pip3 install github-dorker 2>/dev/null && echo "✅ GitHub-dorker instalado com sucesso" || echo "⚠️ GitHub-dorker não pôde ser instalado"

# Gfredirect
echo "Instalando Gfredirect..."
go install github.com/tomnomnom/gfredirect@latest 2>/dev/null && echo "✅ Gfredirect instalado com sucesso" || echo "⚠️ Gfredirect não pôde ser instalado"

# Paramspider
echo "Instalando Paramspider..."
pip3 install paramspider 2>/dev/null && echo "✅ Paramspider instalado com sucesso" || echo "⚠️ Paramspider não pôde ser instalado"

# Aquatone
echo "Instalando Aquatone..."
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip 2>/dev/null
if [ -f aquatone_linux_amd64_1.7.0.zip ]; then
    unzip aquatone_linux_amd64_1.7.0.zip
    sudo mv aquatone /usr/local/bin/
    rm aquatone_linux_amd64_1.7.0.zip
    echo "✅ Aquatone instalado com sucesso"
else
    echo "⚠️ Aquatone não pôde ser baixado"
fi

# Criar diretórios necessários
echo "[8/10] Criando diretórios..."
mkdir -p ~/tools
mkdir -p ~/wordlists
mkdir -p ~/results

# Baixar wordlists adicionais
echo "[9/10] Baixando wordlists..."
cd ~/wordlists

# SecLists (já instalado via apt)
# Baixar wordlists adicionais se necessário
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt 2>/dev/null || echo "⚠️ Wordlist DNS não pôde ser baixada"
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt 2>/dev/null || echo "⚠️ Wordlist common não pôde ser baixada"
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/big.txt 2>/dev/null || echo "⚠️ Wordlist big não pôde ser baixada"

cd ~

# Configurar PATH final
echo "[10/10] Configurando PATH..."
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
source ~/.bashrc

echo ""
echo "✅ Instalação concluída!"
echo "=================================================="
echo "🔧 Ferramentas instaladas:"
echo "   - Enumeração: Amass, Subfinder, Assetfinder, Findomain"
echo "   - Verificação: Httpx, Nmap, Whatweb"
echo "   - URLs: Waybackurls, Gau, Hakrawler"
echo "   - Fuzzing: Ffuf, Gobuster, Dirb"
echo "   - DNS: Dnsrecon, Dnsenum, Fierce"
echo "   - Screenshots: Gowitness, Aquatone"
echo "   - Vulnerabilidades: Nuclei, WPScan, XSStrike"
echo "   - Parâmetros: Arjun, Paramspider"
echo "   - Cloud: Cloud_enum"
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
echo "⚠️ Algumas ferramentas podem não ter sido instaladas devido a problemas de acesso."
echo "   Execute ./verificar_instalacao.sh para verificar quais estão disponíveis."
