#!/bin/bash

# Variável alvo (sem .com)
TARGET="target"
DOMAIN="$TARGET.com"

# Criar pasta log se não existir
mkdir -p log

echo "[*] Iniciando enumeração para: $DOMAIN"
echo "[*] Logs serão salvos em: log/"

# 1. Informações básicas
echo "[1/35] Informações básicas..."
whois $DOMAIN > log/whois.txt 2>&1
nslookup $DOMAIN > log/nslookup.txt 2>&1
dig $DOMAIN > log/dig.txt 2>&1
host -t ns $DOMAIN > log/host_ns.txt 2>&1
host -t mx $DOMAIN > log/host_mx.txt 2>&1

# 2. Subdomínios
echo "[2/35] Enumeração de subdomínios..."
sublist3r -d $DOMAIN -o log/sublist3r.txt 2>&1
amass enum -d $DOMAIN -o log/amass.txt 2>&1
assetfinder --subs-only $DOMAIN > log/assetfinder.txt 2>&1
findomain -t $DOMAIN -o log/findomain.txt 2>&1

# Combinar subdomínios
cat log/sublist3r.txt log/amass.txt log/assetfinder.txt log/findomain.txt 2>/dev/null | sort | uniq > log/subdomains.txt

# Massdns se subdomains.txt existir
if [ -s log/subdomains.txt ]; then
    massdns -r resolvers.txt -t A -o S -w log/massdns_results.txt log/subdomains.txt 2>&1
    httprobe < log/subdomains.txt > log/live_subdomains.txt 2>&1
fi

# 3. Hosts ativos
echo "[3/35] Verificação de hosts ativos..."
if [ -s log/subdomains.txt ]; then
    httpx -l log/subdomains.txt -o log/live_hosts.txt 2>&1
    nmap -iL log/live_hosts.txt -oA log/nmap_scan 2>&1
    whatweb -i log/live_hosts.txt > log/whatweb.txt 2>&1
fi

# 4. Screenshots de hosts
echo "[4/35] Capturando screenshots..."
if [ -s log/live_hosts.txt ]; then
    aquatone-discover -d $DOMAIN -o log/aquatone/ 2>&1
fi

# 5. URLs históricas
echo "[5/35] URLs históricas..."
waybackurls $DOMAIN > log/waybackurls.txt 2>&1
gau $DOMAIN > log/gau_urls.txt 2>&1

# 6. Rastreamento de links
echo "[6/35] Rastreamento de links..."
if [ -s log/live_hosts.txt ]; then
    hakrawler -url $DOMAIN -depth 2 -plain > log/hakrawler_output.txt 2>&1
fi

# 7. Busca em repositórios
echo "[7/35] Busca em repositórios..."
github-search $DOMAIN > log/github_search.txt 2>&1
gitrob -repo $DOMAIN > log/gitrob.txt 2>&1

# 8. DNS e força bruta
echo "[8/35] DNS e força bruta..."
fierce --domain $DOMAIN > log/fierce.txt 2>&1
dnsrecon -u $DOMAIN -e * > log/dnsrecon.txt 2>&1
ffuf -w /usr/share/wordlists/dirb/common.txt -u https://$DOMAIN/FUZZ -o log/ffuf.txt 2>&1

# 9. Captura de tela dos hosts
echo "[9/35] Captura de tela..."
if [ -s log/live_hosts.txt ]; then
    gowitness file -f log/live_hosts.txt -P log/screenshots/ 2>&1
fi

# 10. Scan de vulnerabilidades
echo "[10/35] Scan de vulnerabilidades..."
if [ -s log/live_hosts.txt ]; then
    nuclei -l log/live_hosts.txt -t templates/ -o log/nuclei.txt 2>&1
fi

# 11. Metadados
echo "[11/35] Metadados..."
metabigor net --org $DOMAIN > log/metabigor.txt 2>&1
metagoofil -d $DOMAIN -t doc,pdf,xls,docx,xlsx,ppt,pptx -l 100 > log/metagoofil.txt 2>&1
theHarvester -d $DOMAIN -l 500 -b all > log/theharvester.txt 2>&1

# 12. DNS avançado
echo "[12/35] DNS avançado..."
dnsenum $DOMAIN > log/dnsenum.txt 2>&1
dnsrecon -d $DOMAIN > log/dnsrecon_advanced.txt 2>&1

# 13. Shodan/Censys
echo "[13/35] Shodan/Censys..."
shodan search hostname:$DOMAIN > log/shodan.txt 2>&1
censys search $DOMAIN > log/censys.txt 2>&1

# 14. SpiderFoot
echo "[14/35] SpiderFoot..."
spiderfoot -s $DOMAIN -o log/spiderfoot_report.html 2>&1

# 15. Subfinder/Sn1per
echo "[15/35] Subfinder/Sn1per..."
sn1per -t $DOMAIN > log/sn1per.txt 2>&1
subfinder -d $DOMAIN -o log/subfinder_results.txt 2>&1
wafw00f $DOMAIN > log/wafw00f.txt 2>&1

# 16. Testes de formulários
echo "[16/35] Testes de formulários..."
arjun -u https://$DOMAIN -oT log/arjun_output.txt 2>&1

# 17. Subdomain takeover
echo "[17/35] Subdomain takeover..."
if [ -s log/subdomains.txt ]; then
    subjack -w log/subdomains.txt -t 20 -o log/subjack_results.txt 2>&1
fi

# 18. Fuzz e coleta com MEG
echo "[18/35] Fuzz e coleta..."
if [ -s log/live_subdomains.txt ]; then
    meg -d 1000 -v log/live_subdomains.txt > log/meg_results.txt 2>&1
fi
waymore -u $DOMAIN -o log/waymore_results.txt 2>&1
unfurl -u $DOMAIN -o log/unfurl_results.txt 2>&1
if [ -s log/live_hosts.txt ]; then
    dalfox file log/live_hosts.txt > log/dalfox.txt 2>&1
fi

# 19. Crawlers
echo "[19/35] Crawlers..."
if [ -s log/live_hosts.txt ]; then
    gospider -S log/live_hosts.txt -o log/gospider_output/ 2>&1
fi
recon-ng -w workspace1 > log/recon-ng.txt 2>&1
xray webscan --basic-crawler http://$DOMAIN > log/xray.txt 2>&1

# 20. XSS, SQLi, etc
echo "[20/35] Testes de vulnerabilidades..."
vhost -u $DOMAIN -o log/vhost_results.txt 2>&1
gf xss > log/xss_payloads.txt 2>&1
gf sqli > log/sqli_payloads.txt 2>&1
gf lfi > log/lfi_payloads.txt 2>&1
gf rfi > log/rfi_payloads.txt 2>&1
gf ssti > log/ssti_payloads.txt 2>&1

# 21. Segredos
echo "[21/35] Busca de segredos..."
git-secrets --scan > log/git-secrets.txt 2>&1

# 22. DNS avançado
echo "[22/35] DNS avançado..."
shuffledns -d $DOMAIN -list resolvers.txt -o log/shuffledns_results.txt 2>&1
if [ -s log/subdomains.txt ]; then
    dnsgen -f log/subdomains.txt | massdns -r resolvers.txt -t A -o S -w log/dnsgen_results.txt 2>&1
fi

# 23. Map CIDR e Subs
echo "[23/35] Map CIDR e Subs..."
mapcidr -silent -cidr $DOMAIN -o log/mapcidr_results.txt 2>&1
tko-subs --domains=$DOMAIN --data=providers-data.csv > log/tko-subs.txt 2>&1

# 24. Outras coletas
echo "[24/35] Outras coletas..."
kiterunner -w /usr/share/wordlists/dirb/common.txt -u https://$DOMAIN > log/kiterunner.txt 2>&1
github-dorker -d $DOMAIN > log/github-dorker.txt 2>&1
gfredirect -u $DOMAIN > log/gfredirect.txt 2>&1
paramspider --domain $DOMAIN --output log/paramspider_output.txt 2>&1
dirb https://$DOMAIN -o log/dirb_output.txt 2>&1

# 25. WPScan e Cloud
echo "[25/35] WPScan e Cloud..."
wpscan --url $DOMAIN > log/wpscan.txt 2>&1
cloud_enum -t $DOMAIN -l log/cloud_enum_output.txt 2>&1

# 26. Gobuster DNS
echo "[26/35] Gobuster DNS..."
gobuster dns -d $DOMAIN -t 50 -w /usr/share/wordlists/dirb/common.txt > log/gobuster_dns.txt 2>&1

# 27. Subdomain brute
echo "[27/35] Subdomain brute..."
subzero -d $DOMAIN > log/subzero.txt 2>&1
dnswalk $DOMAIN > log/dnswalk.txt 2>&1
if [ -s log/live_hosts.txt ]; then
    masscan -iL log/live_hosts.txt -p0-65535 -oX log/masscan_results.xml 2>&1
fi

# 28. Ferramentas de fuzz
echo "[28/35] Ferramentas de fuzz..."
xsstrike -u https://$DOMAIN > log/xsstrike.txt 2>&1
by4xx https://$DOMAIN/FUZZ > log/by4xx.txt 2>&1

# 29. DNSX
echo "[29/35] DNSX..."
if [ -s log/subdomains.txt ]; then
    dnsx -l log/subdomains.txt --resp-only -o log/dnsx_results.txt 2>&1
fi

# 30. Wayback
echo "[30/35] Wayback..."
waybackpacket -d log/waybackpacket/ 2>&1

# 31. DNS puro
echo "[31/35] DNS puro..."
if [ -s log/subdomains.txt ]; then
    puredns resolve log/subdomains.txt -r resolvers.txt -w log/puredns_results.txt 2>&1
fi

# 32. CTFR
echo "[32/35] CTFR..."
ctfr -d $DOMAIN -o log/ctfr_results.txt 2>&1

# 33. Validação de resolvers
echo "[33/35] Validação de resolvers..."
dnsvalidator -t 100 -f resolvers.txt -o log/validated_resolvers.txt 2>&1

# 34. Httpx avançado
echo "[34/35] Httpx avançado..."
if [ -s log/live_subdomains.txt ]; then
    httpx -silent -l log/live_subdomains.txt -mc 200 -title -tech-detect -o log/httpx_results.txt 2>&1
fi

# 35. Cloud Enum (alternativo)
echo "[35/35] Cloud Enum (alternativo)..."
cloud_enum -k $TARGET -l log/cloud_enum_results.txt 2>&1

# Gerar relatório final
echo "[*] Gerando relatório final..."
echo "=== RELATÓRIO DE ENUMERAÇÃO ===" > log/relatorio_final.txt
echo "Alvo: $DOMAIN" >> log/relatorio_final.txt
echo "Data: $(date)" >> log/relatorio_final.txt
echo "" >> log/relatorio_final.txt
echo "Arquivos gerados:" >> log/relatorio_final.txt
ls -la log/ >> log/relatorio_final.txt

echo "[*] Enumeração finalizada para: $DOMAIN"
echo "[*] Todos os logs foram salvos em: log/"
echo "[*] Relatório final: log/relatorio_final.txt"
