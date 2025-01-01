echo "---------------------------------------------------------------------------------"
echo "fork of <https://github.com/vm03/payload_dumper>"
echo "credits 'Github@vm03'"
echo "I just made this script to run the dumper at ease for every newbies on termux env"
echo "Parent repo for this script <https://github.com/foxcli/payload-dumper-termux.git>"
echo "---------------------------------------------------------------------------------"
se0="/storage/emulated/0"

file_count=$(find $se0 -type f -name '*.zip' -size +1G 2>/dev/null | wc -l)
if [ $file_count == 0 ]; then # testing for no zip files
	echo " "
	echo "[ .zip file not found, Download your rom first .. ]"
	echo " "
	sleep 5
	exit 1
fi

echo " "
echo "[ zip files found .. ]"
echo " "
find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | nl
sleep 1
echo " "
read -p "[ Select your 'rom.zip' by entering it's corresponding number ] : " input

# validate the input
if ! [[ "$input" =~ ^[0-9]+$ ]]; then # testing for number input
        echo " "
        echo "[ Invalid input '$input',  Enter a valid number in range (1-$file_count) ]"
        echo " "
	sleep 5
        exit 1
elif [ "$input" -lt 1 ] || [ "$input" -gt "$file_count" ]; then # testing for number input are in range
	echo " "
	echo "[ Invalid input '$input',  Enter a valid number in range (1-$file_count) ]"
	echo " "
	sleep 5
	exit 1
fi
sleep 1
echo " "
echo "[ You've selected .. ]"
echo " "
sleep 1
find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | nl | sed -n ${input}p
selected=$(find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | sed -n ${input}p)
sleep 1
if ! [ -d "$HOME/tmp" ]; then
	mkdir -p "$HOME/tmp"
else
	rm -rf $HOME/tmp/*
fi

echo " "
echo "[ Extracting payload.bin from selected rom.zip .. ]"
echo "	wait for 5-10 seconds until finished"
echo " "
sleep 1
unzip $selected payload.bin -d $HOME/tmp > /dev/null 2>&1
echo "[ payload.bin Extracted into $HOME/tmp .. ]"
echo " "
sleep 1
echo "[ Unpacking payload.bin .. ]"
echo "	wait for 30-60 seconds until finished"
echo " "
sleep 1
rm -rf $HOME/payload-dumper-termux/output/*
cd  $HOME/payload-dumper-termux
python $HOME/payload-dumper-termux/payload_dumper.py $HOME/tmp/payload.bin > /dev/null 2>&1
echo "[ boot.img Extracted .. ]"
echo " "
sleep 1
if ! [ -d "$se0/output" ]; then
	mkdir -p $se0/output
else
	mkdir -p $se0/output_bak
	mv $se0/output/* $se0/output_bak/ # to avoid overwrite conflicts
	echo "[ Moved existing files from Internal_Storage/output/ to Internal_Storage/output_bak/ (if any) ]"
	echo " "
	sleep 1
fi
cp $HOME/payload-dumper-termux/output/boot.img $se0/output/
rm -rf $HOME/tmp
rm -rf $HOME/payload-dumper-termux/output/*
echo "[ boot.img copied to Internal_Storage/output directory .. ]"
echo " "
sleep 1
echo "[ Hints : files and directories are altered .. ]"
echo "	1. added files ($HOME/payload-dumper-termux/*) i.e. setup of payload-dumper"
echo "	2. appended (export pdtrun=*) and (alias pdt=*) lines in ($HOME/.bashrc) for shortcuts"
echo " "
sleep 1
read -t 15 -p "[ Do you want to keep the setup for future use? (default=y) (y|n) ] : " choice
echo " "
sleep 1
if [ "$choice" == n ] || [ "$choice" == N ]; then
	rm -rf $HOME/payload-dumper-termux
	sed -i '/pdt/d' $HOME/.bashrc
	echo " "
	echo "[ Setup completely removed .. ]"
	echo " "
	echo "[https://github.com/foxcli/payload-dumper-termux.git]"
	echo " "
	sleep 1
elif [ "$choice" == y ] || [ "$choice" == Y ]; then
	echo " "
	echo "[ Setup preserved .. ]"
	echo " "
        echo "[ You can use <pdt> again to extract another boot.img ]"
	echo " "
	sleep 1
elif [ -z "$choice" ]; then
	echo " "
	echo "[ No input, setup preserved .. ]"
	echo " "
        echo "[ You can use <pdt> again to extract another boot.img ]"
	echo " "
	sleep 1
else
	echo " "
	echo "[ Wrong input '$choice' , BTW setup preserved .. ]"
	echo " "
        echo "[ You can use <pdt> again to extract another boot.img ]"
	echo " "
	sleep 1
fi
echo "[ (boot.img) is inside (Internal_Storage/output) directory ]"
echo " "
echo "Done.."
echo " "
