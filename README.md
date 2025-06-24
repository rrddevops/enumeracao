# 🛠️ Kit de Enumeração de Redes - WSL Ubuntu 22.04

Este repositório contém scripts e ferramentas para enumeração de redes e reconhecimento de alvos.

## 🚀 Início Rápido

### Opção 1: Instalação Rápida (Recomendada para começar)
```bash
chmod +x instalar_rapido.sh
./instalar_rapido.sh
```

### Opção 2: Instalação Essencial
```bash
chmod +x setup_essencial.sh
./setup_essencial.sh
```

### Opção 3: Instalação Completa
```bash
chmod +x setup.sh
./setup.sh
```

### Opção 4: Instalar ferramentas faltantes
```bash
chmod +x instalar_faltantes.sh
./instalar_faltantes.sh
```

### 2. Verificar instalação
```bash
chmod +x verificar_instalacao.sh
./verificar_instalacao.sh
```

### 3. Aplicar configurações do PATH
```bash
source ~/.bashrc
```

### 4. Configurar alvo
```bash
# Editar enum.sh e alterar a variável TARGET
nano enum.sh
# TARGET="seu_alvo"  # Sem .com
```

### 5. Executar enumeração completa
```bash
chmod +x enum.sh
./enum.sh
```

### 6. Ou usar o script de exemplo
```bash
chmod +x exemplo_uso.sh
# Editar o TARGET no script
nano exemplo_uso.sh
./exemplo_uso.sh
```

## 📁 Estrutura de Resultados

Todos os logs e resultados são salvos na pasta `log/`:

```
log/
├── subdomains.txt          # Lista de subdomínios
├── live_hosts.txt          # Hosts ativos
├── live_200.txt           # Hosts com status 200
├── all_urls.txt           # URLs descobertas
├── nuclei_results.txt     # Vulnerabilidades encontradas
├── screenshots/           # Screenshots dos hosts
├── nmap_scan.*           # Resultados do Nmap
├── relatorio.txt         # Relatório final
└── [outros arquivos de log]
```

## 🔧 Solução de Problemas

### Se as ferramentas não forem encontradas:

1. **Verificar instalação:**
   ```bash
   ./verificar_instalacao.sh
   ```

2. **Recarregar configurações:**
   ```bash
   source ~/.bashrc
   ```

3. **Instalar ferramentas faltantes:**
   ```bash
   # Para instalação rápida (mais estável)
   ./instalar_rapido.sh
   
   # Para instalação essencial
   ./setup_essencial.sh
   
   # Para instalação completa
   ./setup.sh
   
   # Para instalar apenas as faltantes
   ./instalar_faltantes.sh
   ```

4. **Verificar PATH manualmente:**
   ```bash
   echo $PATH
   ls ~/go/bin
   ```

### Problemas com repositórios Git:

Se você encontrar problemas com repositórios privados ou inacessíveis:

1. **Use a instalação rápida:**
   ```bash
   ./instalar_rapido.sh
   ```

2. **Instale manualmente as ferramentas que falharam:**
   ```bash
   # Exemplo para metabigor
   wget -O metabigor https://github.com/j3ssie/metabigor/releases/latest/download/metabigor_linux_amd64
   chmod +x metabigor
   sudo mv metabigor /usr/local/bin/
   ```

3. **Verifique quais ferramentas estão disponíveis:**
   ```bash
   ./verificar_instalacao.sh
   ```

## 📋 Ferramentas Incluídas

### Enumeração de Subdomínios
- **Amass** - Reconhecimento passivo e ativo
- **Subfinder** - Enumeração rápida
- **Assetfinder** - Busca de domínios relacionados
- **Findomain** - Enumeração via APIs
- **Sublist3r** - Enumeração via APIs

### Verificação de Hosts
- **Httpx** - Verificação de hosts ativos
- **Nmap** - Scan de portas e serviços
- **Whatweb** - Detecção de tecnologias

### Descoberta de URLs
- **Waybackurls** - URLs históricas
- **Gau** - URLs de múltiplas fontes
- **Hakrawler** - Rastreamento de links

### Fuzzing e Diretórios
- **Ffuf** - Fuzzing web rápido
- **Gobuster** - Descoberta de diretórios
- **Dirb** - Scan de diretórios

### DNS e Reconhecimento
- **Dnsrecon** - Enumeração DNS
- **Dnsenum** - Enumeração DNS avançada
- **Fierce** - Reconhecimento de rede
- **Massdns** - Resolução DNS em massa

### Screenshots
- **Gowitness** - Captura de screenshots
- **Aquatone** - Screenshots e análise

### Vulnerabilidades
- **Nuclei** - Scan de vulnerabilidades
- **WPScan** - Scan de WordPress
- **XSStrike** - Teste de XSS
- **Dalfox** - Scanner de XSS

### Parâmetros
- **Arjun** - Descoberta de parâmetros
- **Paramspider** - Extração de parâmetros

### Cloud
- **Cloud_enum** - Enumeração de serviços cloud

### Outras Ferramentas
- **Metabigor** - Reconhecimento de infraestrutura
- **Metagoofil** - Busca de metadados
- **TheHarvester** - Coleta de informações
- **Gitrob** - Busca de segredos no GitHub
- **Sn1per** - Framework de reconhecimento
- **Recon-ng** - Framework de reconhecimento
- **Spiderfoot** - OSINT automation
- **Xray** - Scanner de vulnerabilidades

## 📁 Estrutura de Arquivos

```
enumeracao/
├── setup.sh                 # Script de instalação completa
├── setup_essencial.sh       # Script de instalação essencial
├── instalar_rapido.sh       # Script de instalação rápida
├── instalar_faltantes.sh    # Script para instalar faltantes
├── verificar_instalacao.sh  # Script de verificação
├── enum.sh                  # Script principal de enumeração
├── exemplo_uso.sh           # Script de exemplo
├── resolvers.txt            # Servidores DNS
├── .gitignore              # Ignora pasta log e arquivos sensíveis
├── GUIA_ENUMERACAO.md       # Guia completo
└── README.md               # Este arquivo
```

## 🔧 Configurações Importantes

### Resolvers DNS
O arquivo `resolvers.txt` contém servidores DNS confiáveis para uso nas ferramentas.

### Wordlists
Instale SecLists para wordlists adicionais:
```bash
sudo apt install seclists
```

### Diretórios Criados
- `~/go/bin/` - Ferramentas Go
- `~/tools/` - Ferramentas adicionais
- `~/wordlists/` - Wordlists
- `log/` - Todos os logs e resultados (ignorado pelo git)

## ⚠️ Aviso Legal

**IMPORTANTE**: Use estas ferramentas apenas em:
- Sistemas próprios
- Sistemas com autorização explícita
- Ambientes de teste controlados

Sempre obtenha permissão antes de realizar qualquer teste de segurança.

## 📚 Documentação

- **GUIA_ENUMERACAO.md** - Guia completo com exemplos detalhados
- **exemplo_uso.sh** - Script de exemplo prático
- **verificar_instalacao.sh** - Script para verificar instalação

## 🎯 Fluxo Recomendado

1. **Setup** → Executar `instalar_rapido.sh` (recomendado)
2. **Verificação** → Executar `verificar_instalacao.sh`
3. **Configuração** → `source ~/.bashrc`
4. **Configuração** → Definir alvo no script
5. **Enumeração** → Executar script de enumeração
6. **Análise** → Revisar resultados em `log/`
7. **Testes** → Realizar testes manuais

## 📊 Análise de Resultados

Após executar a enumeração, analise os arquivos em `log/`:

```bash
# Ver relatório final
cat log/relatorio.txt

# Contar subdomínios encontrados
wc -l log/subdomains.txt

# Ver hosts ativos
cat log/live_200.txt

# Ver vulnerabilidades encontradas
cat log/nuclei_results.txt

# Listar todos os arquivos gerados
ls -la log/
```

## 🤝 Contribuição

Sinta-se à vontade para contribuir com melhorias, correções ou novas ferramentas.

---

**Lembre-se**: Sempre use estas ferramentas de forma ética e responsável! 🔒 