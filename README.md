# 🛠️ Kit de Enumeração de Redes - WSL Ubuntu 22.04

Este repositório contém scripts e ferramentas para enumeração de redes e reconhecimento de alvos.

## 🚀 Início Rápido

### 1. Instalar ferramentas
```bash
chmod +x setup.sh
./setup.sh
```

### 2. Configurar alvo
```bash
# Editar enum.sh e alterar a variável TARGET
nano enum.sh
# TARGET="seu_alvo"  # Sem .com
```

### 3. Executar enumeração completa
```bash
chmod +x enum.sh
./enum.sh
```

### 4. Ou usar o script de exemplo
```bash
chmod +x exemplo_uso.sh
# Editar o TARGET no script
nano exemplo_uso.sh
./exemplo_uso.sh
```

## 📋 Ferramentas Incluídas

### Enumeração de Subdomínios
- **Amass** - Reconhecimento passivo e ativo
- **Subfinder** - Enumeração rápida
- **Assetfinder** - Busca de domínios relacionados
- **Findomain** - Enumeração via APIs

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

### Screenshots
- **Gowitness** - Captura de screenshots

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

## 📁 Estrutura de Arquivos

```
enumeracao/
├── setup.sh              # Script de instalação
├── enum.sh               # Script principal de enumeração
├── exemplo_uso.sh        # Script de exemplo
├── resolvers.txt         # Servidores DNS
├── GUIA_ENUMERACAO.md    # Guia completo
└── README.md            # Este arquivo
```

## 🔧 Configurações Importantes

### Resolvers DNS
O arquivo `resolvers.txt` contém servidores DNS confiáveis para uso nas ferramentas.

### Wordlists
Instale SecLists para wordlists adicionais:
```bash
sudo apt install seclists
```

## ⚠️ Aviso Legal

**IMPORTANTE**: Use estas ferramentas apenas em:
- Sistemas próprios
- Sistemas com autorização explícita
- Ambientes de teste controlados

Sempre obtenha permissão antes de realizar qualquer teste de segurança.

## 📚 Documentação

- **GUIA_ENUMERACAO.md** - Guia completo com exemplos detalhados
- **exemplo_uso.sh** - Script de exemplo prático

## 🎯 Fluxo Recomendado

1. **Setup** → Executar `setup.sh`
2. **Configuração** → Definir alvo no script
3. **Enumeração** → Executar script de enumeração
4. **Análise** → Revisar resultados
5. **Testes** → Realizar testes manuais

## 🤝 Contribuição

Sinta-se à vontade para contribuir com melhorias, correções ou novas ferramentas.

---

**Lembre-se**: Sempre use estas ferramentas de forma ética e responsável! 🔒 