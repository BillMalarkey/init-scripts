#!/bin/bash
mkdir -p ~/.config && touch ~/.config/starship.toml
mkdir -p ~/.local/bin/

sudo apt install zsh
sudo apt install fonts-firecode
curl -sS https://starship.rs/install.sh | sh

#---- INSTALL RUST ----#
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 

#---- INSTALL GO ----#
sudo apt install golang-go 
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile 
source ~/.profile 

#---- INSTALL PYTHON, PIP, PIPX ---#
sudo apt install python3 python3-pip pipx
pipx ensurepath
sudo pipx ensurepath --global
pipx completions

#---- RUST TOOL INSTALL ----#
cargo install cargo-update
cargo install feroxbuster
cargo install x8
cargo install findomain
cargo install rustscan
cargo install jwt-hack
cargo install urx
cargo install xh

#---- GO TOOL INSTALL ----#
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/003random/getJS/v2@latest
go install -v github.com/sensepost/gowitness@latest
go install -v github.com/praetorian-inc/fingerprintx/cmd/fingerprintx@latest
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/musana/fuzzuli@latest
go install -v github.com/hakluke/hakrawler@latest
go install -v github.com/d3mondev/puredns/v2@latest
go install -v github.com/x90skysn3k/brutespray@latest
GO111MODULE=on go install -v github.com/jaeles-project/gospider@latest

go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest
pdtm -ia

go install -v github.com/gwen001/github-subdomains@latest
go install -v github.com/gwen001/github-endpoints@latest
go install -v github.com/gwen001/gitlab-subdomains@latest

go install -v github.com/g0ldencybersec/gungnir/cmd/gungnir@latest
go install -v github.com/g0ldencybersec/Caduceus/cmd/caduceus@latest

#---- PYTHON TOOL INSTALL ----#
python3 -m pip install xnLinkFinder 
python3 -m pip install cewler
python3 -m pip install apkleaks
python3 -m pip install waymore

#---- MISC TOOL INSTALL ----#
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b ~/.local/bin

#---- CONFIG STEPS ----#
echo "export PDCP_API_KEY=39f4167c-390f-4457-8db6-771631396a1f" >> ~/.bashrc
echo "export PDCP_API_KEY=39f4167c-390f-4457-8db6-771631396a1f" >> ~/.zshrc

echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.zshrc
cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf

#---- GF PATTERNS ----#
mkdir Clones && cd Clones
git clone https://github.com/BillMalarkey/master-gf-patterns.git
cp master-gf-patterns/*.json ~/.gf

#---- NUCLEI TEMPLATES ----#
cd ../ && mkdir NUCLEI-TEMPLATES && cd NUCLEI-TEMPLATES
go install -v github.com/xm1k3/cent@latest
git clone https://github.com/Sachinart/manual-nuclei-templates.git
git clone https://github.com/N-N33/Community-Nuclei-Templates.git
git clone https://github.com/freelancermijan/custom-nuclei-templates.git
git clone https://github.com/jhonnybonny/nuclei-templates-bitrix.git
git clone https://github.com/exploit-io/nuclei-templates.git
git clone https://github.com/rahul-nakum14/Recon.git
git clone https://github.com/exploit-io/nuclei-fuzz-templates.git
git clone https://github.com/coffinxp/nuclei-templates.git
git clone https://github.com/nischalbijukchhe/crlf-testing-priv8-Nuclei-coffin.git
git clone https://github.com/nischalbijukchhe/specific-nuclei-templates.git
git clone https://github.com/topscoder/nuclei-wordfence-cve.git
git clone https://github.com/nischalbijukchhe/hexshadow-nuceli.git
git clone https://github.com/nischalbijukchhe/nepax-templates.git
git clone https://github.com/karkis3c/bugbounty.git
git clone https://github.com/schooldropout1337/nuclei-templates.git
nuclei -ud ./*

git clone https://github.com/emadshanab/Nuclei-Templates-Collection.git
cd Nuclei-Templates-Collection
cp {bulk_clone_repos.py,remove_duplicated_templates.py,README.txt,commands.md} ..
cd ..
python3 bulk_clone_repos.py
python3 remove_duplicated_templates.py

cent init
cent -p cent-nuclei-templates

#---- STARSHIP INIT ----#
echo 'eval "$(starship init bash)"' >> ~/.bashrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
