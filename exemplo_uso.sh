#!/bin/bash

# Script de Exemplo - Enumeração de Redes
# Substitua "exemplo" pelo seu alvo real

TARGET="exemplo"
DOMAIN="$TARGET.com"

echo "🔍 Iniciando enumeração para: $DOMAIN"
echo "======================================"

# Criar diretório para logs
mkdir -p log

echo "[1/8] 🔍 Enumeração de subdomínios..."
echo "----------------------------------------"

# Amass - Reconhecimento passivo
echo "Executando Amass..."
amass enum -d $DOMAIN -o log/amass_subdomains.txt 2>&1

# Subfinder - Enumeração rápida
echo "Executando Subfinder..."
subfinder -d $DOMAIN -o log/subfinder_subdomains.txt 2>&1

# Combinar resultados
cat log/amass_subdomains.txt log/subfinder_subdomains.txt 2>/dev/null | sort | uniq > log/subdomains.txt
echo "Subdomínios encontrados: $(wc -l < log/subdomains.txt 2>/dev/null || echo 0)"

echo "[2/8] 🌐 Verificando hosts ativos..."
echo "----------------------------------------"

# Httpx - Verificar hosts ativos
echo "Executando Httpx..."
if [ -s log/subdomains.txt ]; then
    httpx -l log/subdomains.txt -title -tech-detect -status-code -o log/live_hosts.txt 2>&1

    # Filtrar apenas hosts com status 200
    grep "200" log/live_hosts.txt 2>/dev/null | cut -d' ' -f1 > log/live_200.txt
    echo "Hosts ativos (200): $(wc -l < log/live_200.txt 2>/dev/null || echo 0)"
else
    echo "Nenhum subdomínio encontrado para verificar"
fi

echo "[3/8] 📸 Capturando screenshots..."
echo "----------------------------------------"

# Gowitness - Screenshots
echo "Executando Gowitness..."
if [ -s log/live_200.txt ]; then
    gowitness file -f log/live_200.txt -P log/screenshots/ 2>&1
else
    echo "Nenhum host ativo para capturar screenshots"
fi

echo "[4/8] 🔗 Descoberta de URLs..."
echo "----------------------------------------"

# Waybackurls - URLs históricas
echo "Executando Waybackurls..."
waybackurls $DOMAIN > log/wayback_urls.txt 2>&1

# Gau - URLs de múltiplas fontes
echo "Executando Gau..."
gau $DOMAIN > log/gau_urls.txt 2>&1

# Combinar URLs
cat log/wayback_urls.txt log/gau_urls.txt 2>/dev/null | sort | uniq > log/all_urls.txt
echo "URLs encontradas: $(wc -l < log/all_urls.txt 2>/dev/null || echo 0)"

echo "[5/8] 📁 Fuzzing de diretórios..."
echo "----------------------------------------"

# Ffuf - Fuzzing básico (apenas nos primeiros 5 hosts)
echo "Executando Ffuf..."
if [ -s log/live_200.txt ]; then
    head -5 log/live_200.txt | while read host; do
        echo "Fuzzing: $host"
        hostname=$(echo $host | sed 's|https://||' | sed 's|http://||' | sed 's|/.*||')
        ffuf -w /usr/share/wordlists/dirb/common.txt -u $host/FUZZ -o log/fuzz_${hostname}.txt -s 2>&1
    done
else
    echo "Nenhum host ativo para fuzzing"
fi

echo "[6/8] 🛡️ Scan de vulnerabilidades..."
echo "----------------------------------------"

# Nuclei - Scan básico
echo "Executando Nuclei..."
if [ -s log/live_200.txt ]; then
    nuclei -l log/live_200.txt -severity critical,high -o log/nuclei_results.txt 2>&1
else
    echo "Nenhum host ativo para scan de vulnerabilidades"
fi

echo "[7/8] 🔍 Informações DNS..."
echo "----------------------------------------"

# Dnsrecon - Enumeração DNS
echo "Executando Dnsrecon..."
dnsrecon -d $DOMAIN -o log/dnsrecon_results.txt 2>&1

echo "[8/8] 📊 Gerando relatório..."
echo "----------------------------------------"

# Gerar relatório simples
echo "=== RELATÓRIO DE ENUMERAÇÃO ===" > log/relatorio.txt
echo "Alvo: $DOMAIN" >> log/relatorio.txt
echo "Data: $(date)" >> log/relatorio.txt
echo "" >> log/relatorio.txt
echo "Subdomínios encontrados: $(wc -l < log/subdomains.txt 2>/dev/null || echo 0)" >> log/relatorio.txt
echo "Hosts ativos: $(wc -l < log/live_hosts.txt 2>/dev/null || echo 0)" >> log/relatorio.txt
echo "Hosts com status 200: $(wc -l < log/live_200.txt 2>/dev/null || echo 0)" >> log/relatorio.txt
echo "URLs descobertas: $(wc -l < log/all_urls.txt 2>/dev/null || echo 0)" >> log/relatorio.txt
echo "Screenshots capturados: $(ls log/screenshots/ 2>/dev/null | wc -l || echo 0)" >> log/relatorio.txt
echo "Vulnerabilidades encontradas: $(wc -l < log/nuclei_results.txt 2>/dev/null || echo 0)" >> log/relatorio.txt

# Listar arquivos gerados
echo "" >> log/relatorio.txt
echo "Arquivos gerados:" >> log/relatorio.txt
ls -la log/ >> log/relatorio.txt

echo ""
echo "✅ Enumeração concluída!"
echo "📁 Logs salvos em: log/"
echo "📄 Relatório: log/relatorio.txt"
echo ""
echo "📋 Próximos passos sugeridos:"
echo "1. Analisar screenshots em: log/screenshots/"
echo "2. Verificar vulnerabilidades em: log/nuclei_results.txt"
echo "3. Investigar URLs interessantes em: log/all_urls.txt"
echo "4. Realizar testes manuais nos hosts descobertos"
echo ""
echo "🔍 Arquivos principais gerados:"
echo "   - log/subdomains.txt - Lista de subdomínios"
echo "   - log/live_hosts.txt - Hosts ativos"
echo "   - log/live_200.txt - Hosts com status 200"
echo "   - log/all_urls.txt - URLs descobertas"
echo "   - log/nuclei_results.txt - Vulnerabilidades"
echo "   - log/relatorio.txt - Relatório completo" 