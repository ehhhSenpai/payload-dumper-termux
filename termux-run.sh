
se0="/storage/emulated/0"

file_count=$(find $se0 -type f -name '*.zip' -size +1G 2>/dev/null | wc -l)
if [ $file_count == 0 ]; then # testing for no zip files
	echo " "
	echo ".zip file not found, Download your rom first .."
	echo " "
	exit 1
fi

echo " "
echo "zip files found .."
echo " "
find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | nl

echo " "
read -p "Select your 'rom.zip' by entering it's corresponding number : " input

# validate the input
if ! [[ "$input" =~ ^[0-9]+$ ]]; then # testing for number input
        echo " "
        echo "Invalid input "\'$input\'"  Please enter a valid number in range (1-$file_count)"
        echo " "
        exit 1
elif [ "$input" -lt 1 ] || [ "$input" -gt "$file_count" ]; then # testing for number input are in range
	echo " "
	echo "Invalid input "\'$input\'"  Please enter a valid number in range (1-$file_count)"
	echo " "
	exit 1
fi

echo " "
echo "You've selected"
echo " "
find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | nl | sed -n ${input}p
selected=$(find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | sed -n ${input}p)

if ! [ -d "$HOME/tmp" ]; then
	mkdir -p "$HOME/tmp"
fi

echo " "
echo "extracting rom.zip .."
echo " "

unzip $selected payload.bin -d $HOME/tmp
echo " "
echo "payload.bin extracted into $HOME/tmp .."
echo " "
sleep 1
echo "unpacking payload.bin .."
echo " "
python $HOME/payload-dumper-termux/payload_dumper.py $HOME/tmp/payload.bin
echo " "
if ! [ -d "$se0/output" ]; then
	mkdir -p "$se0/output"
fi
cp $HOME/payload-dumper-termux/output/boot.img $se0/output/
rm -rf $HOME/tmp
rm -rf $HOME/payload-dumper-termux/output/*
echo "[ boot.img copied to Internal_Storage/output dir .. ]"
echo " "
echo "hints : files and directories are altered"
echo "	1. $HOME/payload-dumper-termux/* i.e. setup of payload-dumper"
echo "	2. append (pdt=*) and (alias pdt=*) in $HOME/.bashrc for shortcuts"
echo " "
read -p "Do you want to keep the setup for future use? (default=y) (y|n) : " choice
if [ "$choice" == n || "$choice" == N ]; then
	rm -rf $HOME/payload-dumper-termux
	sed -i '/pdt/d' $HOME/.bashrc
	echo " "
	echo "setup completely removed .."
elif [ "$choice" == y || "$choice" == Y || -z "$choice" ]; then
	echo " "
	echo "setup preserved .."
	echo " "
fi
