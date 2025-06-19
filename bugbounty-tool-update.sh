#!/bin/sh
cd ~

sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

#---- RUST ----#
cargo install-update -a

#---- GO ----#
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/003random/getJS/v2@latest
go install -v github.com/sensepost/gowitness@latest
go install -v github.com/praetorian-inc/fingerprintx/cmd/fingerprintx@latest
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/tomnomnom/anew@latest
go install -v github.com/musana/fuzzuli@latest
go install -v github.com/hakluke/hakrawler@latest
go install -v github.com/gwen001/github-subdomains@latest
go install -v github.com/d3mondev/puredns/v2@latest
go install -v github.com/x90skysn3k/brutespray@latest
GO111MODULE=on go install -v github.com/jaeles-project/gospider@latest

CGO_ENABLED=1 go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/asnmap/cmd/asnmap@latest
go install -v github.com/projectdiscovery/cdncheck/cmd/cdncheck@latest
go install -v github.com/projectdiscovery/tldfinder/cmd/tldfinder@latest
go install -v github.com/projectdiscovery/tlsx/cmd/tlsx@latest
go install -v github.com/projectdiscovery/alterx/cmd/alterx@latest
go install -v github.com/projectdiscovery/cloudlist/cmd/cloudlist@latest
go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest
go install -v github.com/projectdiscovery/wappalyzergo/cmd/update-fingerprints@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install -v github.com/xm1k3/cent@latest

go install -v github.com/gwen001/github-subdomains@latest
go install -v github.com/gwen001/github-endpoints@latest
go install -v github.com/gwen001/gitlab-subdomains@latest

#---- PYTHON ----#
python3 -m pip install --upgrade xnLinkfinder
python3 -m pip install --upgrade cewler
python3 -m pip install --upgrade apkleaks
python3 -m pip install --upgrade waymore

#---- MISC ----#
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b ~/.local/bin
