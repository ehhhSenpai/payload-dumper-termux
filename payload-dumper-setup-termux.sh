termux-setup-storage
apt update && apt upgrade -y
apt install git python -y
git clone https://github.com/vm03/payload_dumper.git $HOME/payload-dumper
cd $HOME/payload-dumper
python -m pip install -r requirements.txt


python payload_dumper.py /storage/emulated/0/payload.bin
