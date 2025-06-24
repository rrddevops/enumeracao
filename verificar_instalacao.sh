#!/bin/bash

echo "🔍 Verificando instalação das ferramentas..."
echo "=========================================="

# Array com todas as ferramentas
tools=(
    "sublist3r"
    "amass"
    "assetfinder"
    "findomain"
    "massdns"
    "httpx"
    "nmap"
    "aquatone-discover"
    "waybackurls"
    "gau"
    "hakrawler"
    "github-search"
    "gitrob"
    "ffuf"
    "gowitness"
    "nuclei"
    "metabigor"
    "metagoofil"
    "theHarvester"
    "dnsenum"
    "dnsrecon"
    "shodan"
    "censys"
    "spiderfoot"
    "sn1per"
    "subfinder"
    "wafw00f"
    "arjun"
    "subjack"
    "meg"
    "waymore"
    "unfurl"
    "dalfox"
    "gospider"
    "recon-ng"
    "xray"
    "vhost"
    "gf"
    "git-secrets"
    "shuffledns"
    "dnsgen"
    "mapcidr"
    "tko-subs"
    "kiterunner"
    "github-dorker"
    "gfredirect"
    "paramspider"
    "dirb"
    "gobuster"
    "fierce"
    "whatweb"
    "wpscan"
    "cloud_enum"
    "dnswalk"
    "masscan"
)

# Contadores
instaladas=0
nao_instaladas=0
nao_encontradas=()

echo "Verificando ferramentas..."
echo ""

for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool - INSTALADO"
        ((instaladas++))
    else
        echo "❌ $tool - NÃO ENCONTRADO"
        ((nao_instaladas++))
        nao_encontradas+=("$tool")
    fi
done

echo ""
echo "=========================================="
echo "📊 RESUMO DA VERIFICAÇÃO:"
echo "   ✅ Ferramentas instaladas: $instaladas"
echo "   ❌ Ferramentas não encontradas: $nao_instaladas"
echo ""

if [ $nao_instaladas -gt 0 ]; then
    echo "🔧 Ferramentas que precisam ser instaladas:"
    for tool in "${nao_encontradas[@]}"; do
        echo "   - $tool"
    done
    echo ""
    echo "💡 Soluções:"
    echo "   1. Execute novamente: ./setup.sh"
    echo "   2. Verifique se o PATH está configurado: source ~/.bashrc"
    echo "   3. Instale manualmente as ferramentas faltantes"
else
    echo "🎉 Todas as ferramentas foram instaladas com sucesso!"
    echo "🚀 Você pode usar o script enum.sh agora!"
fi

echo ""
echo "🔍 Verificando diretórios importantes..."
if [ -d "$HOME/go/bin" ]; then
    echo "✅ Go bin directory: $HOME/go/bin"
else
    echo "❌ Go bin directory não encontrado"
fi

if [ -d "$HOME/wordlists" ]; then
    echo "✅ Wordlists directory: $HOME/wordlists"
else
    echo "❌ Wordlists directory não encontrado"
fi

if [ -d "$HOME/tools" ]; then
    echo "✅ Tools directory: $HOME/tools"
else
    echo "❌ Tools directory não encontrado"
fi

echo ""
echo "🔧 Verificando PATH..."
echo "PATH atual: $PATH"
echo ""
echo "📁 Verificando se Go está no PATH..."
if echo "$PATH" | grep -q "$HOME/go/bin"; then
    echo "✅ Go bin está no PATH"
else
    echo "❌ Go bin NÃO está no PATH"
    echo "   Execute: source ~/.bashrc"
fi 