#!/bin/bash

echo "📚 Baixando wordlists necessárias..."
echo "===================================="

# Criar diretório de wordlists se não existir
mkdir -p ~/wordlists

# Verificar se SecLists está instalado
if [ ! -d "/usr/share/wordlists" ]; then
    echo "Instalando SecLists..."
    sudo apt update
    sudo apt install -y seclists
fi

# Criar link simbólico se necessário
if [ ! -L "/usr/share/wordlists" ]; then
    echo "Criando link simbólico para wordlists..."
    sudo ln -sf /usr/share/seclists /usr/share/wordlists
fi

echo "[1/4] Baixando wordlists básicas..."

# Wordlists básicas
cd ~/wordlists

# SecLists (já instalado via apt)
echo "Copiando SecLists..."
if [ -d "/usr/share/seclists" ]; then
    cp -r /usr/share/seclists/* ~/wordlists/ 2>/dev/null || echo "⚠️ Erro ao copiar SecLists"
fi

# Wordlists específicas
echo "Baixando wordlists específicas..."

# Subdomínios
wget -O subdomains-top1million-5000.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt 2>/dev/null || echo "⚠️ Erro ao baixar subdomains-top1million-5000.txt"

# Diretórios web
wget -O common.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt 2>/dev/null || echo "⚠️ Erro ao baixar common.txt"
wget -O big.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/big.txt 2>/dev/null || echo "⚠️ Erro ao baixar big.txt"
wget -O directory-list-2.3-medium.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-medium.txt 2>/dev/null || echo "⚠️ Erro ao baixar directory-list-2.3-medium.txt"

# Parâmetros
wget -O parameters.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/burp-parameter-names.txt 2>/dev/null || echo "⚠️ Erro ao baixar parameters.txt"

# Extensões
wget -O extensions.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/web-extensions.txt 2>/dev/null || echo "⚠️ Erro ao baixar extensions.txt"

echo "[2/4] Criando wordlists personalizadas..."

# Criar wordlist comum personalizada
cat > common-custom.txt << 'EOF'
admin
administrator
api
assets
backup
blog
cdn
config
css
dashboard
db
dev
docs
download
email
files
forum
ftp
git
help
images
img
js
lib
login
logout
mail
media
mobile
news
old
panel
php
private
public
register
search
secure
server
shop
site
static
support
test
tmp
tools
upload
user
users
web
www
xml
EOF

# Criar wordlist de subdomínios personalizada
cat > subdomains-custom.txt << 'EOF'
admin
api
app
auth
backup
beta
blog
cdn
dev
docs
ftp
git
help
images
img
lib
mail
media
mobile
news
old
panel
private
public
secure
server
shop
site
static
support
test
tmp
tools
upload
user
web
www
EOF

echo "[3/4] Verificando wordlists..."

# Verificar se as wordlists principais existem
wordlists=(
    "common.txt"
    "big.txt"
    "subdomains-top1million-5000.txt"
    "common-custom.txt"
    "subdomains-custom.txt"
)

echo "Verificando wordlists:"
for wordlist in "${wordlists[@]}"; do
    if [ -f "$wordlist" ]; then
        echo "✅ $wordlist - $(wc -l < $wordlist) linhas"
    else
        echo "❌ $wordlist - NÃO ENCONTRADO"
    fi
done

echo "[4/4] Configurando links simbólicos..."

# Criar links simbólicos para compatibilidade
if [ ! -f "/usr/share/wordlists/dirb/common.txt" ]; then
    echo "Criando link para /usr/share/wordlists/dirb/common.txt"
    sudo mkdir -p /usr/share/wordlists/dirb
    sudo ln -sf ~/wordlists/common.txt /usr/share/wordlists/dirb/common.txt
fi

if [ ! -f "/usr/share/wordlists/dirb/big.txt" ]; then
    echo "Criando link para /usr/share/wordlists/dirb/big.txt"
    sudo ln -sf ~/wordlists/big.txt /usr/share/wordlists/dirb/big.txt
fi

# Criar wordlist padrão se não existir
if [ ! -f "/usr/share/wordlists/dirb/common.txt" ]; then
    echo "Criando wordlist padrão..."
    sudo mkdir -p /usr/share/wordlists/dirb
    sudo cp ~/wordlists/common-custom.txt /usr/share/wordlists/dirb/common.txt
fi

echo ""
echo "✅ Wordlists baixadas e configuradas!"
echo "📁 Localização: ~/wordlists/"
echo "🔗 Links criados em: /usr/share/wordlists/dirb/"
echo ""
echo "📋 Wordlists disponíveis:"
ls -la ~/wordlists/ | grep "\.txt$"
echo ""
echo "🚀 Agora você pode usar as ferramentas com as wordlists!" 