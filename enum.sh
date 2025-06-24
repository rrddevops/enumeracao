#!/bin/bash

# Variável alvo (sem .com)
TARGET="target"
DOMAIN="$TARGET.com"

echo "[*] Iniciando enumeração para: $DOMAIN"

# 1. Informações básicas
whois $DOMAIN
nslookup $DOMAIN
dig $DOMAIN
host -t ns $DOMAIN
host -t mx $DOMAIN

# 2. Subdomínios
sublist3r -d $DOMAIN
amass enum -d $DOMAIN
assetfinder --subs-only $DOMAIN
findomain -t $DOMAIN
massdns -r resolvers.txt -t A -o S -w results.txt subdomains.txt
httprobe < subdomains.txt > live_subdomains.txt

# 3. Hosts ativos
httpx -l subdomains.txt -o live_hosts.txt
nmap -iL live_hosts.txt -oA nmap_scan
whatweb -i live_hosts.txt

# 4. Screenshots de hosts
aquatone-discover -d $DOMAIN

# 5. URLs históricas
waybackurls $DOMAIN | tee waybackurls.txt
gau $DOMAIN | tee gau_urls.txt

# 6. Rastreamento de links
hakrawler -url $DOMAIN -depth 2 -plain | tee hakrawler_output.txt

# 7. Busca em repositórios
github-search $DOMAIN
gitrob -repo $DOMAIN

# 8. DNS e força bruta
fierce --domain $DOMAIN
dnsrecon -u $DOMAIN -e *
ffuf -w wordlist.txt -u https://$DOMAIN/FUZZ

# 9. Captura de tela dos hosts
gowitness file -f live_hosts.txt -P screenshots/

# 10. Scan de vulnerabilidades
nuclei -l live_hosts.txt -t templates/

# 11. Metadados
metabigor net --org $DOMAIN
metagoofil -d $DOMAIN -t doc,pdf,xls,docx,xlsx,ppt,pptx -l 100
theHarvester -d $DOMAIN -l 500 -b all

# 12. DNS avançado
dnsenum $DOMAIN
dnsrecon -d $DOMAIN

# 13. Shodan/Censys
shodan search hostname:$DOMAIN
censys search $DOMAIN

# 14. SpiderFoot
spiderfoot -s $DOMAIN -o spiderfoot_report.html

# 15. Subfinder/Sn1per
sn1per -t $DOMAIN
subfinder -d $DOMAIN -o subfinder_results.txt
wafw00f $DOMAIN

# 16. Testes de formulários
arjun -u https://$DOMAIN -oT arjun_output.txt

# 17. Subdomain takeover
subjack -w subdomains.txt -t 20 -o subjack_results.txt

# 18. Fuzz e coleta com MEG
meg -d 1000 -v /path/to/live_subdomains.txt
waymore -u $DOMAIN -o waymore_results.txt
unfurl -u $DOMAIN -o unfurl_results.txt
dalfox file live_hosts.txt

# 19. Crawlers
gospider -S live_hosts.txt -o gospider_output/
recon-ng -w workspace1
xray webscan --basic-crawler http://$DOMAIN

# 20. XSS, SQLi, etc
vhost -u $DOMAIN -o vhost_results.txt
gf xss | tee xss_payloads.txt
gf sqli | tee sqli_payloads.txt
gf lfi | tee lfi_payloads.txt
gf rfi | tee rfi_payloads.txt
gf ssti | tee ssti_payloads.txt

# 21. Segredos
git-secrets --scan

# 22. DNS avançado
shuffledns -d $DOMAIN -list resolvers.txt -o shuffledns_results.txt
dnsgen -f subdomains.txt | massdns -r resolvers.txt -t A -o S -w dnsgen_results.txt

# 23. Map CIDR e Subs
mapcidr -silent -cidr $DOMAIN -o mapcidr_results.txt
tko-subs --domains=$DOMAIN --data=providers-data.csv

# 24. Outras coletas
kiterunner -w wordlist.txt -u https://$DOMAIN
github-dorker -d $DOMAIN
gfredirect -u $DOMAIN
paramspider --domain $DOMAIN --output paramspider_output.txt
dirb https://$DOMAIN -o dirb_output.txt

# 25. WPScan e Cloud
wpscan --url $DOMAIN
cloud_enum -t $DOMAIN -l cloud_enum_output.txt

# 26. Gobuster DNS
gobuster dns -d $DOMAIN -t 50 -w wordlist.txt

# 27. Subdomain brute
subzero -d $DOMAIN
dnswalk $DOMAIN
masscan -iL live_hosts.txt -p0-65535 -oX masscan_results.xml

# 28. Ferramentas de fuzz
xsstrike -u https://$DOMAIN
by4xx https://$DOMAIN/FUZZ

# 29. DNSX
dnsx -l subdomains.txt --resp-only -o dnsx_results.txt

# 30. Wayback
waybackpacket -d output/

# 31. DNS puro
puredns resolve subdomains.txt -r resolvers.txt -w puredns_results.txt

# 32. CTFR
ctfr -d $DOMAIN -o ctfr_results.txt

# 33. Validação de resolvers
dnsvalidator -t 100 -f resolvers.txt -o validated_resolvers.txt

# 34. Httpx avançado
httpx -silent -l live_subdomains.txt -mc 200 -title -tech-detect -o httpx_results.txt

# 35. Cloud Enum (alternativo)
cloud_enum -k $TARGET -l cloud_enum_results.txt

echo "[*] Enumeração finalizada para: $DOMAIN"
