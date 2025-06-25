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
go install -v github.com/d3mondev/puredns/v2@latest
go install -v github.com/x90skysn3k/brutespray@latest
GO111MODULE=on go install -v github.com/jaeles-project/gospider@latest

pdtm -ua
cent update

go install -v github.com/gwen001/github-subdomains@latest
go install -v github.com/gwen001/github-endpoints@latest
go install -v github.com/gwen001/gitlab-subdomains@latest

go install -v github.com/g0ldencybersec/gungnir/cmd/gungnir@latest
go install -v github.com/g0ldencybersec/Caduceus/cmd/caduceus@latest

#---- PYTHON ----#
python3 -m pip install --upgrade xnLinkfinder
python3 -m pip install --upgrade cewler
python3 -m pip install --upgrade apkleaks
python3 -m pip install --upgrade waymore

#---- MISC ----#
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b ~/.local/bin
