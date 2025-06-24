#!/bin/bash

#Ubuntu
sudo apt update && sudo apt install -y \
  whatweb \
  fierce \
  dnsrecon \
  dnsenum \
  dirb \
  gobuster \
  masscan \
  dnswalk

pip install ffuf gowitness nuclei metagoofil theHarvester dnsgen \
  git-secrets subjack dalfox paramspider xsstrike by4xx \
  waybackpacket ctfr dnsvalidator

# Go tools via Git
git clone https://github.com/tomnomnom/gf && cd gf && go install && cd ..
git clone https://github.com/tomnomnom/waybackurls && cd waybackurls && go install && cd ..
git clone https://github.com/tomnomnom/gau && cd gau && go install && cd ..
git clone https://github.com/projectdiscovery/httpx && cd httpx/cmd/httpx && go install && cd ../../..
git clone https://github.com/projectdiscovery/nuclei && cd nuclei/v2/cmd/nuclei && go install && cd ../../..

# Outras ferramentas
git clone https://github.com/hakluke/hakrawler && cd hakrawler && go install && cd ..
git clone https://github.com/laramies/metabigor && cd metabigor && chmod +x metabigor && cp metabigor /usr/local/bin && cd ..
git clone https://github.com/OWASP/Amass.git && cd Amass && go install && cd ..

git clone https://github.com/projectdiscovery/subfinder && cd subfinder/v2/cmd/subfinder && go install && cd ../../..
git clone https://github.com/projectdiscovery/shuffledns && cd shuffledns/cmd/shuffledns && go install && cd ../../..

git clone https://github.com/blechschmidt/massdns && cd massdns && make && sudo cp bin/massdns /usr/local/bin && cd ..

git clone https://github.com/projectdiscovery/dnsx && cd dnsx/cmd/dnsx && go install && cd ../../..
git clone https://github.com/projectdiscovery/naabu && cd naabu/v2/cmd/naabu && go install && cd ../../..

git clone https://github.com/assetnote/kiterunner && cd kiterunner && ./install.sh && cd ..
git clone https://github.com/toniblyx/gitrob && cd gitrob && go install && cd ..
git clone https://github.com/greenbone/gospider && cd gospider && go install && cd ..

sudo apt install ruby-full
sudo gem install wpscan

git clone https://github.com/initstring/cloud_enum.git
cd cloud_enum
pip install -r requirements.txt

git clone https://github.com/s0md3v/Arjun.git
cd Arjun
pip install -r requirements.txt

# Baixar e descompactar manualmente do repositório oficial
wget https://github.com/chaitin/xray/releases/download/1.9.13/xray_linux_amd64.zip
unzip xray_linux_amd64.zip
chmod +x xray
sudo mv xray /usr/local/bin/

sudo apt install golang -y
