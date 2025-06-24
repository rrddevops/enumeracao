#!/bin/bash

# Script de Exemplo - Enumeração de Redes
# Substitua "exemplo" pelo seu alvo real

TARGET="exemplo"
DOMAIN="$TARGET.com"

echo "🔍 Iniciando enumeração para: $DOMAIN"
echo "======================================"

# Criar diretório para resultados
mkdir -p resultados/$DOMAIN
cd resultados/$DOMAIN

echo "[1/8] 🔍 Enumeração de subdomínios..."
echo "----------------------------------------"

# Amass - Reconhecimento passivo
echo "Executando Amass..."
amass enum -d $DOMAIN -o amass_subdomains.txt

# Subfinder - Enumeração rápida
echo "Executando Subfinder..."
subfinder -d $DOMAIN -o subfinder_subdomains.txt

# Combinar resultados
cat amass_subdomains.txt subfinder_subdomains.txt | sort | uniq > subdomains.txt
echo "Subdomínios encontrados: $(wc -l < subdomains.txt)"

echo "[2/8] 🌐 Verificando hosts ativos..."
echo "----------------------------------------"

# Httpx - Verificar hosts ativos
echo "Executando Httpx..."
httpx -l subdomains.txt -title -tech-detect -status-code -o live_hosts.txt

# Filtrar apenas hosts com status 200
grep "200" live_hosts.txt | cut -d' ' -f1 > live_200.txt
echo "Hosts ativos (200): $(wc -l < live_200.txt)"

echo "[3/8] 📸 Capturando screenshots..."
echo "----------------------------------------"

# Gowitness - Screenshots
echo "Executando Gowitness..."
gowitness file -f live_200.txt -P screenshots/

echo "[4/8] 🔗 Descoberta de URLs..."
echo "----------------------------------------"

# Waybackurls - URLs históricas
echo "Executando Waybackurls..."
waybackurls $DOMAIN > wayback_urls.txt

# Gau - URLs de múltiplas fontes
echo "Executando Gau..."
gau $DOMAIN > gau_urls.txt

# Combinar URLs
cat wayback_urls.txt gau_urls.txt | sort | uniq > all_urls.txt
echo "URLs encontradas: $(wc -l < all_urls.txt)"

echo "[5/8] 📁 Fuzzing de diretórios..."
echo "----------------------------------------"

# Ffuf - Fuzzing básico (apenas nos primeiros 5 hosts)
echo "Executando Ffuf..."
head -5 live_200.txt | while read host; do
    echo "Fuzzing: $host"
    ffuf -w /usr/share/wordlists/dirb/common.txt -u $host/FUZZ -o fuzz_$(echo $host | sed 's|https://||' | sed 's|http://||' | sed 's|/.*||').txt -s
done

echo "[6/8] 🛡️ Scan de vulnerabilidades..."
echo "----------------------------------------"

# Nuclei - Scan básico
echo "Executando Nuclei..."
nuclei -l live_200.txt -severity critical,high -o nuclei_results.txt

echo "[7/8] 🔍 Informações DNS..."
echo "----------------------------------------"

# Dnsrecon - Enumeração DNS
echo "Executando Dnsrecon..."
dnsrecon -d $DOMAIN -o dnsrecon_results.txt

echo "[8/8] 📊 Gerando relatório..."
echo "----------------------------------------"

# Gerar relatório simples
echo "=== RELATÓRIO DE ENUMERAÇÃO ===" > relatorio.txt
echo "Alvo: $DOMAIN" >> relatorio.txt
echo "Data: $(date)" >> relatorio.txt
echo "" >> relatorio.txt
echo "Subdomínios encontrados: $(wc -l < subdomains.txt)" >> relatorio.txt
echo "Hosts ativos: $(wc -l < live_hosts.txt)" >> relatorio.txt
echo "Hosts com status 200: $(wc -l < live_200.txt)" >> relatorio.txt
echo "URLs descobertas: $(wc -l < all_urls.txt)" >> relatorio.txt
echo "Screenshots capturados: $(ls screenshots/ | wc -l)" >> relatorio.txt
echo "Vulnerabilidades encontradas: $(wc -l < nuclei_results.txt)" >> relatorio.txt

echo ""
echo "✅ Enumeração concluída!"
echo "📁 Resultados salvos em: resultados/$DOMAIN/"
echo "📄 Relatório: resultados/$DOMAIN/relatorio.txt"
echo ""
echo "📋 Próximos passos sugeridos:"
echo "1. Analisar screenshots em: resultados/$DOMAIN/screenshots/"
echo "2. Verificar vulnerabilidades em: resultados/$DOMAIN/nuclei_results.txt"
echo "3. Investigar URLs interessantes em: resultados/$DOMAIN/all_urls.txt"
echo "4. Realizar testes manuais nos hosts descobertos" 