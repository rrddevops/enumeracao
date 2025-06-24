#!/bin/bash

# Variável alvo (sem .com)
TARGET="target"
DOMAIN="$TARGET.com"

# Criar pasta log se não existir
mkdir -p log

# Verificar e configurar wordlists
echo "[*] Verificando wordlists..."
if [ ! -f "/usr/share/wordlists/dirb/common.txt" ] && [ ! -f "~/wordlists/common.txt" ]; then
    echo "[!] Wordlists não encontradas. Execute: ./baixar_wordlists.sh"
    echo "[!] Continuando com wordlist básica..."
    # Criar wordlist básica
    cat > /tmp/common.txt << 'EOF'
admin
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
    WORDLIST="/tmp/common.txt"
else
    if [ -f "/usr/share/wordlists/dirb/common.txt" ]; then
        WORDLIST="/usr/share/wordlists/dirb/common.txt"
    else
        WORDLIST="~/wordlists/common.txt"
    fi
fi

echo "[*] Iniciando enumeração para: $DOMAIN"
echo "[*] Logs serão salvos em: log/"
echo "[*] Usando wordlist: $WORDLIST"

# 1. Informações básicas
echo "[1/35] Informações básicas..."
whois $DOMAIN > log/whois.txt 2>&1
nslookup $DOMAIN > log/nslookup.txt 2>&1
dig $DOMAIN > log/dig.txt 2>&1
host -t ns $DOMAIN > log/host_ns.txt 2>&1
host -t mx $DOMAIN > log/host_mx.txt 2>&1

# 2. Subdomínios
echo "[2/35] Enumeração de subdomínios..."
if command -v sublist3r &> /dev/null; then
    sublist3r -d $DOMAIN -o log/sublist3r.txt 2>&1
else
    echo "Sublist3r não encontrado" > log/sublist3r.txt
fi

if command -v amass &> /dev/null; then
    amass enum -d $DOMAIN -o log/amass.txt 2>&1
else
    echo "Amass não encontrado" > log/amass.txt
fi

if command -v assetfinder &> /dev/null; then
    assetfinder --subs-only $DOMAIN > log/assetfinder.txt 2>&1
else
    echo "Assetfinder não encontrado" > log/assetfinder.txt
fi

if command -v findomain &> /dev/null; then
    findomain -t $DOMAIN -o log/findomain.txt 2>&1
else
    echo "Findomain não encontrado" > log/findomain.txt
fi

# Combinar subdomínios
cat log/sublist3r.txt log/amass.txt log/assetfinder.txt log/findomain.txt 2>/dev/null | grep -v "não encontrado" | sort | uniq > log/subdomains.txt

# Massdns se subdomains.txt existir
if [ -s log/subdomains.txt ]; then
    if command -v massdns &> /dev/null; then
        massdns -r resolvers.txt -t A -o S -w log/massdns_results.txt log/subdomains.txt 2>&1
    fi
    if command -v httprobe &> /dev/null; then
        httprobe < log/subdomains.txt > log/live_subdomains.txt 2>&1
    fi
fi

# 3. Hosts ativos
echo "[3/35] Verificação de hosts ativos..."
if [ -s log/subdomains.txt ]; then
    if command -v httpx &> /dev/null; then
        httpx -l log/subdomains.txt -o log/live_hosts.txt 2>&1
    fi
    if command -v nmap &> /dev/null; then
        nmap -iL log/live_hosts.txt -oA log/nmap_scan 2>&1
    fi
    if command -v whatweb &> /dev/null; then
        whatweb -i log/live_hosts.txt > log/whatweb.txt 2>&1
    fi
fi

# 4. Screenshots de hosts
echo "[4/35] Capturando screenshots..."
if [ -s log/live_hosts.txt ]; then
    if command -v aquatone-discover &> /dev/null; then
        aquatone-discover -d $DOMAIN -o log/aquatone/ 2>&1
    fi
fi

# 5. URLs históricas
echo "[5/35] URLs históricas..."
if command -v waybackurls &> /dev/null; then
    waybackurls $DOMAIN > log/waybackurls.txt 2>&1
else
    echo "Waybackurls não encontrado" > log/waybackurls.txt
fi

if command -v gau &> /dev/null; then
    gau $DOMAIN > log/gau_urls.txt 2>&1
else
    echo "Gau não encontrado" > log/gau_urls.txt
fi

# 6. Rastreamento de links
echo "[6/35] Rastreamento de links..."
if [ -s log/live_hosts.txt ]; then
    if command -v hakrawler &> /dev/null; then
        hakrawler -url $DOMAIN -depth 2 -plain > log/hakrawler_output.txt 2>&1
    else
        echo "Hakrawler não encontrado" > log/hakrawler_output.txt
    fi
fi

# 7. Busca em repositórios
echo "[7/35] Busca em repositórios..."
if command -v github-search &> /dev/null; then
    github-search $DOMAIN > log/github_search.txt 2>&1
else
    echo "GitHub Search não encontrado" > log/github_search.txt
fi

if command -v gitrob &> /dev/null; then
    gitrob -repo $DOMAIN > log/gitrob.txt 2>&1
else
    echo "Gitrob não encontrado" > log/gitrob.txt
fi

# 8. DNS e força bruta
echo "[8/35] DNS e força bruta..."
if command -v fierce &> /dev/null; then
    fierce --domain $DOMAIN > log/fierce.txt 2>&1
else
    echo "Fierce não encontrado" > log/fierce.txt
fi

if command -v dnsrecon &> /dev/null; then
    dnsrecon -u $DOMAIN -e * > log/dnsrecon.txt 2>&1
else
    echo "Dnsrecon não encontrado" > log/dnsrecon.txt
fi

# Ffuf com wordlist verificada
echo "Executando Ffuf..."
if command -v ffuf &> /dev/null; then
    ffuf -w "$WORDLIST" -u https://$DOMAIN/FUZZ -o log/ffuf.txt 2>&1
else
    echo "Ffuf não encontrado" > log/ffuf.txt
fi

# 9. Captura de tela dos hosts
echo "[9/35] Captura de tela..."
if [ -s log/live_hosts.txt ]; then
    if command -v gowitness &> /dev/null; then
        gowitness file -f log/live_hosts.txt -P log/screenshots/ 2>&1
    else
        echo "Gowitness não encontrado"
    fi
fi

# 10. Scan de vulnerabilidades
echo "[10/35] Scan de vulnerabilidades..."
if [ -s log/live_hosts.txt ]; then
    if command -v nuclei &> /dev/null; then
        nuclei -l log/live_hosts.txt -t templates/ -o log/nuclei.txt 2>&1
    else
        echo "Nuclei não encontrado" > log/nuclei.txt
    fi
fi

# 11. Metadados
echo "[11/35] Metadados..."
if command -v metabigor &> /dev/null; then
    metabigor net --org $DOMAIN > log/metabigor.txt 2>&1
else
    echo "Metabigor não encontrado" > log/metabigor.txt
fi

if command -v metagoofil &> /dev/null; then
    metagoofil -d $DOMAIN -t doc,pdf,xls,docx,xlsx,ppt,pptx -l 100 > log/metagoofil.txt 2>&1
else
    echo "Metagoofil não encontrado" > log/metagoofil.txt
fi

if command -v theHarvester &> /dev/null; then
    theHarvester -d $DOMAIN -l 500 -b all > log/theharvester.txt 2>&1
else
    echo "TheHarvester não encontrado" > log/theharvester.txt
fi

# 12. DNS avançado
echo "[12/35] DNS avançado..."
if command -v dnsenum &> /dev/null; then
    dnsenum $DOMAIN > log/dnsenum.txt 2>&1
else
    echo "Dnsenum não encontrado" > log/dnsenum.txt
fi

if command -v dnsrecon &> /dev/null; then
    dnsrecon -d $DOMAIN > log/dnsrecon_advanced.txt 2>&1
else
    echo "Dnsrecon não encontrado" > log/dnsrecon_advanced.txt
fi

# 13. Shodan/Censys
echo "[13/35] Shodan/Censys..."
if command -v shodan &> /dev/null; then
    shodan search hostname:$DOMAIN > log/shodan.txt 2>&1
else
    echo "Shodan CLI não encontrado" > log/shodan.txt
fi

if command -v censys &> /dev/null; then
    censys search $DOMAIN > log/censys.txt 2>&1
else
    echo "Censys não encontrado" > log/censys.txt
fi

# 14. SpiderFoot
echo "[14/35] SpiderFoot..."
if command -v spiderfoot &> /dev/null; then
    spiderfoot -s $DOMAIN -o log/spiderfoot_report.html 2>&1
else
    echo "SpiderFoot não encontrado" > log/spiderfoot_report.html
fi

# 15. Subfinder/Sn1per
echo "[15/35] Subfinder/Sn1per..."
if command -v sn1per &> /dev/null; then
    sn1per -t $DOMAIN > log/sn1per.txt 2>&1
else
    echo "Sn1per não encontrado" > log/sn1per.txt
fi

if command -v subfinder &> /dev/null; then
    subfinder -d $DOMAIN -o log/subfinder_results.txt 2>&1
else
    echo "Subfinder não encontrado" > log/subfinder_results.txt
fi

if command -v wafw00f &> /dev/null; then
    wafw00f $DOMAIN > log/wafw00f.txt 2>&1
else
    echo "Wafw00f não encontrado" > log/wafw00f.txt
fi

# 16. Testes de formulários
echo "[16/35] Testes de formulários..."
if command -v arjun &> /dev/null; then
    arjun -u https://$DOMAIN -oT log/arjun_output.txt 2>&1
else
    echo "Arjun não encontrado" > log/arjun_output.txt
fi

# 17. Subdomain takeover
echo "[17/35] Subdomain takeover..."
if [ -s log/subdomains.txt ]; then
    if command -v subjack &> /dev/null; then
        subjack -w log/subdomains.txt -t 20 -o log/subjack_results.txt 2>&1
    else
        echo "Subjack não encontrado" > log/subjack_results.txt
    fi
fi

# 18. Fuzz e coleta com MEG
echo "[18/35] Fuzz e coleta..."
if [ -s log/live_subdomains.txt ]; then
    if command -v meg &> /dev/null; then
        meg -d 1000 -v log/live_subdomains.txt > log/meg_results.txt 2>&1
    else
        echo "MEG não encontrado" > log/meg_results.txt
    fi
fi

if command -v waymore &> /dev/null; then
    waymore -u $DOMAIN -o log/waymore_results.txt 2>&1
else
    echo "Waymore não encontrado" > log/waymore_results.txt
fi

if command -v unfurl &> /dev/null; then
    unfurl -u $DOMAIN -o log/unfurl_results.txt 2>&1
else
    echo "Unfurl não encontrado" > log/unfurl_results.txt
fi

if [ -s log/live_hosts.txt ]; then
    if command -v dalfox &> /dev/null; then
        dalfox file log/live_hosts.txt > log/dalfox.txt 2>&1
    else
        echo "Dalfox não encontrado" > log/dalfox.txt
    fi
fi

# 19. Crawlers
echo "[19/35] Crawlers..."
if [ -s log/live_hosts.txt ]; then
    if command -v gospider &> /dev/null; then
        gospider -S log/live_hosts.txt -o log/gospider_output/ 2>&1
    else
        echo "Gospider não encontrado"
    fi
fi

if command -v recon-ng &> /dev/null; then
    recon-ng -w workspace1 > log/recon-ng.txt 2>&1
else
    echo "Recon-ng não encontrado" > log/recon-ng.txt
fi

if command -v xray &> /dev/null; then
    xray webscan --basic-crawler http://$DOMAIN > log/xray.txt 2>&1
else
    echo "Xray não encontrado" > log/xray.txt
fi

# 20. XSS, SQLi, etc
echo "[20/35] Testes de vulnerabilidades..."
if command -v vhost &> /dev/null; then
    vhost -u $DOMAIN -o log/vhost_results.txt 2>&1
else
    echo "Vhost não encontrado" > log/vhost_results.txt
fi

if command -v gf &> /dev/null; then
    gf xss > log/xss_payloads.txt 2>&1
    gf sqli > log/sqli_payloads.txt 2>&1
    gf lfi > log/lfi_payloads.txt 2>&1
    gf rfi > log/rfi_payloads.txt 2>&1
    gf ssti > log/ssti_payloads.txt 2>&1
else
    echo "GF não encontrado" > log/xss_payloads.txt
    echo "GF não encontrado" > log/sqli_payloads.txt
    echo "GF não encontrado" > log/lfi_payloads.txt
    echo "GF não encontrado" > log/rfi_payloads.txt
    echo "GF não encontrado" > log/ssti_payloads.txt
fi

# 21. Segredos
echo "[21/35] Busca de segredos..."
if command -v git-secrets &> /dev/null; then
    git-secrets --scan > log/git-secrets.txt 2>&1
else
    echo "Git-secrets não encontrado" > log/git-secrets.txt
fi

# 22. DNS avançado
echo "[22/35] DNS avançado..."
if command -v shuffledns &> /dev/null; then
    shuffledns -d $DOMAIN -list resolvers.txt -o log/shuffledns_results.txt 2>&1
else
    echo "Shuffledns não encontrado" > log/shuffledns_results.txt
fi

if [ -s log/subdomains.txt ]; then
    if command -v dnsgen &> /dev/null && command -v massdns &> /dev/null; then
        dnsgen -f log/subdomains.txt | massdns -r resolvers.txt -t A -o S -w log/dnsgen_results.txt 2>&1
    else
        echo "Dnsgen ou Massdns não encontrado" > log/dnsgen_results.txt
    fi
fi

# 23. Map CIDR e Subs
echo "[23/35] Map CIDR e Subs..."
if command -v mapcidr &> /dev/null; then
    mapcidr -silent -cidr $DOMAIN -o log/mapcidr_results.txt 2>&1
else
    echo "Mapcidr não encontrado" > log/mapcidr_results.txt
fi

if command -v tko-subs &> /dev/null; then
    tko-subs --domains=$DOMAIN --data=providers-data.csv > log/tko-subs.txt 2>&1
else
    echo "TKO-subs não encontrado" > log/tko-subs.txt
fi

# 24. Outras coletas
echo "[24/35] Outras coletas..."
if command -v kiterunner &> /dev/null; then
    kiterunner -w "$WORDLIST" -u https://$DOMAIN > log/kiterunner.txt 2>&1
else
    echo "Kiterunner não encontrado" > log/kiterunner.txt
fi

if command -v github-dorker &> /dev/null; then
    github-dorker -d $DOMAIN > log/github-dorker.txt 2>&1
else
    echo "GitHub-dorker não encontrado" > log/github-dorker.txt
fi

if command -v gfredirect &> /dev/null; then
    gfredirect -u $DOMAIN > log/gfredirect.txt 2>&1
else
    echo "Gfredirect não encontrado" > log/gfredirect.txt
fi

if command -v paramspider &> /dev/null; then
    paramspider --domain $DOMAIN --output log/paramspider_output.txt 2>&1
else
    echo "Paramspider não encontrado" > log/paramspider_output.txt
fi

if command -v dirb &> /dev/null; then
    dirb https://$DOMAIN -o log/dirb_output.txt 2>&1
else
    echo "Dirb não encontrado" > log/dirb_output.txt
fi

# 25. WPScan e Cloud
echo "[25/35] WPScan e Cloud..."
if command -v wpscan &> /dev/null; then
    wpscan --url $DOMAIN > log/wpscan.txt 2>&1
else
    echo "WPScan não encontrado" > log/wpscan.txt
fi

if command -v cloud_enum &> /dev/null; then
    cloud_enum -t $DOMAIN -l log/cloud_enum_output.txt 2>&1
else
    echo "Cloud_enum não encontrado" > log/cloud_enum_output.txt
fi

# 26. Gobuster DNS
echo "[26/35] Gobuster DNS..."
if command -v gobuster &> /dev/null; then
    gobuster dns -d $DOMAIN -t 50 -w "$WORDLIST" > log/gobuster_dns.txt 2>&1
else
    echo "Gobuster não encontrado" > log/gobuster_dns.txt
fi

# 27. Subdomain brute
echo "[27/35] Subdomain brute..."
if command -v subzero &> /dev/null; then
    subzero -d $DOMAIN > log/subzero.txt 2>&1
else
    echo "Subzero não encontrado" > log/subzero.txt
fi

if command -v dnswalk &> /dev/null; then
    dnswalk $DOMAIN > log/dnswalk.txt 2>&1
else
    echo "Dnswalk não encontrado" > log/dnswalk.txt
fi

if [ -s log/live_hosts.txt ]; then
    if command -v masscan &> /dev/null; then
        masscan -iL log/live_hosts.txt -p0-65535 -oX log/masscan_results.xml 2>&1
    else
        echo "Masscan não encontrado" > log/masscan_results.xml
    fi
fi

# 28. Ferramentas de fuzz
echo "[28/35] Ferramentas de fuzz..."
if command -v xsstrike &> /dev/null; then
    xsstrike -u https://$DOMAIN > log/xsstrike.txt 2>&1
else
    echo "XSStrike não encontrado" > log/xsstrike.txt
fi

if command -v by4xx &> /dev/null; then
    by4xx https://$DOMAIN/FUZZ > log/by4xx.txt 2>&1
else
    echo "By4xx não encontrado" > log/by4xx.txt
fi

# 29. DNSX
echo "[29/35] DNSX..."
if [ -s log/subdomains.txt ]; then
    if command -v dnsx &> /dev/null; then
        dnsx -l log/subdomains.txt --resp-only -o log/dnsx_results.txt 2>&1
    else
        echo "DNSX não encontrado" > log/dnsx_results.txt
    fi
fi

# 30. Wayback
echo "[30/35] Wayback..."
if command -v waybackpacket &> /dev/null; then
    waybackpacket -d log/waybackpacket/ 2>&1
else
    echo "Waybackpacket não encontrado"
fi

# 31. DNS puro
echo "[31/35] DNS puro..."
if [ -s log/subdomains.txt ]; then
    if command -v puredns &> /dev/null; then
        puredns resolve log/subdomains.txt -r resolvers.txt -w log/puredns_results.txt 2>&1
    else
        echo "Puredns não encontrado" > log/puredns_results.txt
    fi
fi

# 32. CTFR
echo "[32/35] CTFR..."
if command -v ctfr &> /dev/null; then
    ctfr -d $DOMAIN -o log/ctfr_results.txt 2>&1
else
    echo "CTFR não encontrado" > log/ctfr_results.txt
fi

# 33. Validação de resolvers
echo "[33/35] Validação de resolvers..."
if command -v dnsvalidator &> /dev/null; then
    dnsvalidator -t 100 -f resolvers.txt -o log/validated_resolvers.txt 2>&1
else
    echo "DNSValidator não encontrado" > log/validated_resolvers.txt
fi

# 34. Httpx avançado
echo "[34/35] Httpx avançado..."
if [ -s log/live_subdomains.txt ]; then
    if command -v httpx &> /dev/null; then
        httpx -silent -l log/live_subdomains.txt -mc 200 -title -tech-detect -o log/httpx_results.txt 2>&1
    else
        echo "Httpx não encontrado" > log/httpx_results.txt
    fi
fi

# 35. Cloud Enum (alternativo)
echo "[35/35] Cloud Enum (alternativo)..."
if command -v cloud_enum &> /dev/null; then
    cloud_enum -k $TARGET -l log/cloud_enum_results.txt 2>&1
else
    echo "Cloud_enum não encontrado" > log/cloud_enum_results.txt
fi

# Gerar relatório final
echo "[*] Gerando relatório final..."
echo "=== RELATÓRIO DE ENUMERAÇÃO ===" > log/relatorio_final.txt
echo "Alvo: $DOMAIN" >> log/relatorio_final.txt
echo "Data: $(date)" >> log/relatorio_final.txt
echo "Wordlist usada: $WORDLIST" >> log/relatorio_final.txt
echo "" >> log/relatorio_final.txt
echo "Arquivos gerados:" >> log/relatorio_final.txt
ls -la log/ >> log/relatorio_final.txt

echo "[*] Enumeração finalizada para: $DOMAIN"
echo "[*] Todos os logs foram salvos em: log/"
echo "[*] Relatório final: log/relatorio_final.txt"
echo ""
echo "💡 Dica: Execute ./baixar_wordlists.sh para baixar wordlists completas"
