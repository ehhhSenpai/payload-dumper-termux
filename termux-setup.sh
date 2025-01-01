termux-setup-storage
apt update && apt upgrade -y
apt install git python -y
git clone https://github.com/foxcli/payload-dumper-termux.git $HOME/payload-dumper-termux
python -m pip install -r $HOME/payload-dumper-termux/requirements.txt
echo 'export pdt="$HOME/payload-dumper-termux/termux-run.sh"' >> $HOME/.bashrc
echo "alias pdt='bash \$pdt'" >> $HOME/.bashrc
source "$HOME/.bashrc"

# copy the below line (without #) and run this in termux to setup payload-dumper-termux

# termux-setup-storage && apt update && apt upgrade -y && apt install git python -y && git clone https://github.com/foxcli/payload-dumper-termux.git $HOME/payload-dumper-termux && python -m pip install -r $HOME/payload-dumper-termux/requirements.txt && echo 'export pdt="$HOME/payload-dumper-termux/extract.sh"' >> $HOME/.bashrc && echo "alias pdt='bash \$pdt'" >> $HOME/.bashrc && source $HOME/.bashrc

