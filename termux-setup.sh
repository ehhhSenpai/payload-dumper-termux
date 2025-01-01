termux-setup-storage
apt update && apt upgrade -y
apt install git python -y
git clone https://github.com/foxcli/payload-dumper-termux.git $HOME/payload-dumper-termux
python -m pip install -r $HOME/payload-dumper-termux/requirements.txt
echo 'export pdtrun="$HOME/payload-dumper-termux/termux-run.sh"' >> $HOME/.bashrc
echo "alias pdt='bash \$pdtrun'" >> $HOME/.bashrc
clear
for i in {10..1}; do
	echo " "
	echo "run <pdt> after restarting termux"
	echo " "
	echo "exit in $i seconds"
	sleep 1
	clear
done
exit

# alternate setup method
# copy the below line (without #) and run this in termux to setup payload-dumper-termux

# termux-setup-storage && apt update && apt upgrade -y && apt install git python -y && git clone https://github.com/foxcli/payload-dumper-termux.git $HOME/payload-dumper-termux && python -m pip install -r $HOME/payload-dumper-termux/requirements.txt && echo 'export pdtrun="$HOME/payload-dumper-termux/termux-run.sh"' >> $HOME/.bashrc && echo "alias pdt='bash \$pdtrun'" >> $HOME/.bashrc && source $HOME/.bashrc && clear && echo "\n	[ run <pdt> to invoke the dumper ]" && sleep 10
