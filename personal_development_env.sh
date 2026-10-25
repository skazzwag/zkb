#!/bin/bash

# Update and upgrade
sudo apt update && sudo apt upgrade -y

# Install common packages
sudo apt install -y git curl wget build-essential

# Create a .bash_profile that sources the .bashrc and .bash_secrets
cat > ~/.bash_profile << 'EOF'
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if [ -f ~/.bash_secrets ]; then
    . ~/.bash_secrets
fi
EOF

# Install alacritty terminal emulator
sudo apt install alacritty

# Install uv package manager for python work
curl -LsSf https://astral.sh/uv/install.sh | sh
echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc
echo 'eval "$(uvx --generate-shell-completion bash)"' >> ~/.bashrc

# Install duckdb for analytics work
curl https://install.duckdb.org | sh
# Add DuckDB latest to path
export PATH="/home/zak/.duckdb/cli/latest":$PATH

# Install PostgreSQL CLI for version 17
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail \
  https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] \
  https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" \
  > /etc/apt/sources.list.d/pgdg.list'

# Install only the client (no server)
sudo apt update
sudo apt install postgresql-client-17

# Can connect with
# 1. psql -d mydb -h db.example.com -p 5432 -U myuser
# 2. psql "postgres://myuser@db.example.com:5432/mydb?sslmode=require"
# 3. psql -d mydb (local database)

# Install xclip
sudo apt install xclip

# Install Midnight Commander
sudo apt install mc

# Install fzf
sudo apt install fzf

# Silly modules
sudo add-apt-repository ppa:ytvwld/asciiquarium
sudo apt update && sudo apt install asciiquarium
sudo apt install cmatrix
sudo apt install cbonsai
sudo apt install cowsay
sudo apt install sl
uv tool install snowmachine

# Install herdr instead of tmux
curl -fsSL https://herdr.dev/install.sh | sh

# Install fresh as terminal text editor
curl https://raw.githubusercontent.com/sinelaw/fresh/refs/heads/master/scripts/install.sh | sh
echo 'export EDITOR="fresh"' >> ~/.bashrc
echo 'export VISUAL="fresh"' >> ~/.bashrc

# Install tools to make fresh more IDE-like
uv tool install ruff
uv tool install ty
uv tool install sqlfluff
uv tool install shandy-sqlfmt
uv tool install pre-commit
sudo apt install -y jq
curl -fsSL https://j-clemons.com/dbt-language-server/install | bash

# Install hunk diff veiwer (needs a shell restart I think)
curl -fsSL https://hunk.dev/install.sh | sh

# Set git defaults
git config --global core.editor "fresh"
git config --global user.name "skazzwag"
git config --global user.email "zak.n.bell@proton.me"
git config --global init.defaultBranch main
git config --global core.pager "hunk pager"

# Install GitHub CLI
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    
# Authenticate GitHub CLI
gh auth login

# Install the skill (user scope recommended)
gh skill install cli/cli gh --scope user

# Update the skill after a `gh` release
gh skill update gh

# Install gh-dash
gh extension install dlvhdr/gh-dash

# Install gh-review
sudo apt update
sudo apt install cargo
cargo install gh-review

# Install npm and nodejs
sudo apt update
sudo apt install nodejs npm

# Install opencode
curl -fsSL https://opencode.ai/install | bash

# Setup a Nerd Font
FONT_NAME="FiraMono"
VERSION="v3.4.0"

# Create fonts directory
mkdir -p ~/.local/share/fonts

# Download and extract
cd ~/.local/share/fonts
curl -fLo "${FONT_NAME}.zip" \
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/FiraMono.zip"

# Extract (you may need to install unzip first)
sudo apt install unzip
unzip -o "${FONT_NAME}.zip"
rm "${FONT_NAME}.zip"

# Rebuild font cache
fc-cache -fv

# Go back to home directory
cd ~

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Install direnv
sudo apt install direnv

# Install GNU stow for dotfile syncing dotfiles (do at the end!)
sudo apt install stow
