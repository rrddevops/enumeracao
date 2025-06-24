# Guia de Enumeração de Redes - WSL Ubuntu 22.04

## 📋 Pré-requisitos

### 1. Instalação do WSL Ubuntu 22.04
```bash
# No PowerShell como administrador
wsl --install -d Ubuntu-22.04
```

### 2. Executar o script de setup
```bash
# Dar permissão de execução
chmod +x setup.sh

# Executar o script
./setup.sh
```

## 🚀 Como Usar as Ferramentas

### 1. **Configuração Inicial**

```bash
# Editar o arquivo enum.sh e definir o alvo
nano enum.sh

# Alterar a linha:
TARGET="seu_alvo"  # Sem .com
```

### 2. **Execução do Script Principal**

```bash
# Dar permissão e executar
chmod +x enum.sh
./enum.sh
```

## 🛠️ Ferramentas Principais e Uso Manual

### **1. Enumeração de Subdomínios**

#### Amass (Reconhecimento Passivo)
```bash
# Enumeração básica
amass enum -d exemplo.com

# Enumeração agressiva
amass enum -d exemplo.com -brute -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt

# Enumeração com API keys
amass enum -d exemplo.com -active -api
```

#### Subfinder
```bash
# Enumeração básica
subfinder -d exemplo.com -o subdomains.txt

# Com múltiplos domínios
subfinder -dL domains.txt -o all_subdomains.txt

# Com resolvers personalizados
subfinder -d exemplo.com -r resolvers.txt -o subdomains.txt
```

#### Assetfinder
```bash
# Buscar subdomínios
assetfinder --subs-only exemplo.com > subdomains.txt

# Buscar domínios relacionados
assetfinder exemplo.com > all_domains.txt
```

### **2. Verificação de Hosts Ativos**

#### Httpx
```bash
# Verificar hosts ativos
httpx -l subdomains.txt -o live_hosts.txt

# Com detecção de tecnologias
httpx -l subdomains.txt -title -tech-detect -status-code -o detailed_hosts.txt

# Verificar apenas hosts com status 200
httpx -l subdomains.txt -mc 200 -o live_200.txt
```

#### Nmap
```bash
# Scan básico
nmap -iL live_hosts.txt -oA nmap_scan

# Scan mais detalhado
nmap -iL live_hosts.txt -sS -sV -O -p- -oA nmap_detailed

# Scan rápido
nmap -iL live_hosts.txt -F -oA nmap_quick
```

### **3. Descoberta de URLs**

#### Waybackurls
```bash
# URLs históricas do Wayback Machine
waybackurls exemplo.com > wayback_urls.txt

# Filtrar por extensões
waybackurls exemplo.com | grep "\.php\|\.asp\|\.aspx" > filtered_urls.txt
```

#### Gau (Get All URLs)
```bash
# URLs de múltiplas fontes
gau exemplo.com > gau_urls.txt

# Com filtros
gau exemplo.com | grep "\.js\|\.json" > js_urls.txt
```

#### Hakrawler
```bash
# Rastreamento de links
hakrawler -url https://exemplo.com -depth 2 -plain > hakrawler_output.txt

# Com profundidade específica
hakrawler -url https://exemplo.com -depth 3 -js -plain > js_links.txt
```

### **4. Fuzzing e Descoberta de Diretórios**

#### Ffuf
```bash
# Fuzzing básico
ffuf -w /usr/share/wordlists/dirb/common.txt -u https://exemplo.com/FUZZ

# Com extensões
ffuf -w /usr/share/wordlists/dirb/common.txt -u https://exemplo.com/FUZZ -e .php,.html,.txt

# Fuzzing de subdomínios
ffuf -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -u https://FUZZ.exemplo.com
```

#### Gobuster
```bash
# Descoberta de diretórios
gobuster dir -u https://exemplo.com -w /usr/share/wordlists/dirb/common.txt

# Descoberta de subdomínios
gobuster dns -d exemplo.com -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
```

#### Dirb
```bash
# Scan básico
dirb https://exemplo.com

# Com wordlist específica
dirb https://exemplo.com /usr/share/wordlists/dirb/big.txt
```

### **5. DNS e Reconhecimento**

#### Dnsrecon
```bash
# Enumeração DNS completa
dnsrecon -d exemplo.com

# Com força bruta
dnsrecon -d exemplo.com -D /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt -t brt
```

#### Dnsenum
```bash
# Enumeração DNS
dnsenum exemplo.com

# Com wordlist
dnsenum --wordlist /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt exemplo.com
```

#### Fierce
```bash
# Reconhecimento de rede
fierce --domain exemplo.com

# Com range específico
fierce --domain exemplo.com --range 192.168.1.0/24
```

### **6. Screenshots e Visualização**

#### Gowitness
```bash
# Screenshots de hosts
gowitness file -f live_hosts.txt -P screenshots/

# Screenshot de URL específica
gowitness single https://exemplo.com
```

### **7. Scan de Vulnerabilidades**

#### Nuclei
```bash
# Scan básico
nuclei -l live_hosts.txt

# Com templates específicos
nuclei -l live_hosts.txt -t cves/

# Scan completo
nuclei -l live_hosts.txt -severity critical,high,medium
```

#### WPScan (WordPress)
```bash
# Scan básico
wpscan --url https://exemplo.com

# Scan agressivo
wpscan --url https://exemplo.com --enumerate p,t,u

# Com usuários específicos
wpscan --url https://exemplo.com --usernames admin,user1,user2
```

### **8. Testes de Parâmetros**

#### Arjun
```bash
# Descoberta de parâmetros
arjun -u https://exemplo.com -oT arjun_output.txt

# Com método POST
arjun -u https://exemplo.com -m POST -oT arjun_post.txt
```

#### Paramspider
```bash
# Extração de parâmetros
paramspider --domain exemplo.com --output params.txt

# Com extensões específicas
paramspider --domain exemplo.com --exclude php,asp --output params.txt
```

### **9. Cloud Enumeration**

#### Cloud_enum
```bash
# Enumeração de serviços cloud
cloud_enum -t exemplo -l cloud_results.txt

# Com múltiplos alvos
cloud_enum -k exemplo,teste,admin -l cloud_results.txt
```

### **10. Ferramentas de Fuzz**

#### XSStrike
```bash
# Teste de XSS
xsstrike -u https://exemplo.com

# Com crawling
xsstrike -u https://exemplo.com --crawl
```

#### Dalfox
```bash
# Scan de XSS
dalfox file urls.txt

# Com payloads específicos
dalfox file urls.txt --payload '"><script>alert(1)</script>'
```

## 📁 Estrutura de Arquivos Recomendada

```
enumeration/
├── targets/
│   ├── exemplo.com/
│   │   ├── subdomains.txt
│   │   ├── live_hosts.txt
│   │   ├── screenshots/
│   │   ├── nmap_results/
│   │   └── reports/
├── wordlists/
├── resolvers.txt
└── scripts/
```

## 🔧 Configurações Importantes

### **1. Resolvers DNS**
Crie um arquivo `resolvers.txt` com servidores DNS confiáveis:
```
8.8.8.8
8.8.4.4
1.1.1.1
1.0.0.1
208.67.222.222
208.67.220.220
```

### **2. Wordlists Recomendadas**
```bash
# Instalar SecLists
sudo apt install seclists

# Wordlists úteis:
/usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-5000.txt
/usr/share/wordlists/dirb/common.txt
/usr/share/wordlists/dirb/big.txt
/usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
```

## ⚠️ Considerações Legais e Éticas

1. **Sempre obtenha autorização** antes de realizar testes
2. **Use apenas em ambientes controlados** ou próprios
3. **Respeite rate limits** das APIs
4. **Documente todas as atividades** realizadas
5. **Não cause danos** aos sistemas testados

## 🎯 Fluxo de Trabalho Recomendado

1. **Reconhecimento Passivo**: Amass, Subfinder, Assetfinder
2. **Verificação de Hosts**: Httpx, Nmap
3. **Descoberta de URLs**: Waybackurls, Gau, Hakrawler
4. **Fuzzing**: Ffuf, Gobuster, Dirb
5. **Screenshots**: Gowitness
6. **Scan de Vulnerabilidades**: Nuclei, WPScan
7. **Testes Específicos**: Arjun, XSStrike, Dalfox

## 📊 Análise de Resultados

```bash
# Contar subdomínios encontrados
wc -l subdomains.txt

# Filtrar hosts com status 200
grep "200" httpx_results.txt

# Extrair tecnologias detectadas
grep "tech" httpx_results.txt | cut -d' ' -f2 | sort | uniq

# Analisar screenshots
ls screenshots/ | wc -l
```

Este guia fornece uma base sólida para começar com enumeração de redes no WSL Ubuntu 22.04. Lembre-se de sempre usar essas ferramentas de forma ética e responsável! 