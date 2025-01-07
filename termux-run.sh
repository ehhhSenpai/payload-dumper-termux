# description
 clear
 echo " "
 echo "----------------------------------------"
 echo "script to run the payload dumper easily "
 echo "    on termux environment for newbie    "
 echo "repo for this script with payload dumper"
 echo " github.com/foxcli/payload-dumper-termux"
 echo "               ----------               "
 echo "credits 'Github@vm03' for payload_dumper"
 echo "----------------------------------------"
 sleep 0.1

# check for zip > 1GiB
 se0="/storage/emulated/0"
 file_count=$(find $se0 -type f -name '*.zip' -size +1G 2>/dev/null | wc -l)
 if [ $file_count == 0 ]; then  # testing for no zip files
   echo " "
   echo "[ .zip file not found, Download your rom first .. ]"
   echo " "
   sleep 0.1
   exit 1
 fi

# zip listing and selection
 echo " "
 echo "[ zip files found .. ]"
 echo " "
 sleep 0.1
 se0="/storage/emulated/0"
 find $se0 -type f -name '*.zip' -size +1G -print 2> /dev/null | nl | awk -F'/' '{printf "\033[1;33m" $1 $NF "\033[0m"; printf "  ( Internal_Storage > "; for (i=5; i<NF; i++) printf $i"/"; print " )"}'
 sleep 0.1
 echo " "
 echo " "
 read -p "[ Select your 'rom.zip' by entering it's corresponding number ] : " input
 if ! [[ "$input" =~ ^[0-9]+$ ]]; then  # testing for number input
   sleep 0.1
   echo " "
   echo "[ Invalid input '$input',  Enter a valid number in range (1-$file_count) ]"
   echo "Retry from the start by running <pdt> .."
   echo " "
   sleep 0.1
   exit 1
 elif [ "$input" -lt 1 ] || [ "$input" -gt "$file_count" ]; then  # testing for number input i.e. in listed range
   sleep 0.1
   echo " "
   echo "[ Invalid input '$input',  Enter a valid number in range (1-$file_count) ]"
   echo "Retry from the start by running <pdt> .."
   echo " "
   sleep 0.1
   exit 1
 fi
 sleep 0.1
 echo " "
 echo " "
 echo "[ You've selected .. ]"
 echo " "
 sleep 0.1
 find $se0 -type f -name '*.zip' -size +1G -print 2> /dev/null | nl | awk -F'/' '{printf "\033[1;33m" $1 $NF "\033[0m"; printf "  ( Internal_Storage > "; for (i=5; i<NF; i++) printf $i"/"; print " )"}' | sed -n ${input}p
 selected=$(find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | sed -n ${input}p)
 rom_name=$(find $se0 -type f -name '*.zip' -size +1G -print 2>/dev/null | sed -n ${input}p | awk -F'/' '{print "\033[1;33m" $NF "\033[0m"}')
 echo " "
 unzip -l $selected | grep "payload.bin" > /dev/null
 if ! [ $? -eq 0 ];then  # testing the zip contains payload.bin
   sleep 0.1
   echo "$rom_name does not contain payload.bin"
   echo "Retry from the start by running <pdt> .."
   echo " "
   exit 1
 fi
 sleep 0.1
 echo " "
 echo -e "Note : \033[1;31mFLASHING WRONG <boot.img> MAY BRICK YOUR DEVICE\033[0m"
 echo "BTW, you are just extracting it now .."
 echo " "
 sleep 0.1
 echo " "
 read -p "[ Confirm your selection by replying (y|n) ] : " confirm
 echo " "
 if [ "$confirm" == y ] || [ "$confirm" == Y ]; then
   echo "OK, Wait .."
   echo " "
   sleep 0.1
 elif [ "$confirm" == n ] || [ "$confirm" == N ]; then
   echo "Don't worry, Retry from the start by running <pdt> .."
   echo " "
   sleep 0.1
   exit 0
 elif [ -z "$confirm" ]; then
   echo "No confirmation, exiting .."
   echo "Don't worry, Retry from the start by running <pdt> .."
   echo " "
   sleep 0.1
   exit 1
 else
   echo "Wrong input '$confirm' , exiting .."
   echo "Don't worry, Retry from the start by running <pdt> .."
   echo " "
   sleep 0.1
   exit 1
 fi
# unzipping rom and unpacking payload.bin
 sleep 0.1
 if ! [ -d "$HOME/payload-dumper-termux/tmp" ]; then
   mkdir -p "$HOME/payload-dumper-termux/tmp"
 else
   rm -rf $HOME/payload-dumper-termux/tmp/*
 fi

 echo " "
 echo "[ Extracting payload.bin from $rom_name .. ]"
 echo " "
 sleep 0.2
 unzip $selected payload.bin -d $HOME/payload-dumper-termux/tmp > /dev/null 2>&1
 echo "[ payload.bin Extracted .. ]"
 echo " "
 sleep 0.2
 echo "[ Extracting boot.img .. ]"
 echo " "
 sleep 0.2
 rm -rf $HOME/payload-dumper-termux/output/*
 cd  $HOME/payload-dumper-termux
 unpack="python $HOME/payload-dumper-termux/payload_dumper.py $HOME/payload-dumper-termux/tmp/payload.bin"
 $unpack 2> /dev/null| while read -r o; do
   if [[ $o == "Processing boot partition"*"Done" ]]; then
     pkill -f $unpack 2> /dev/null
     break
   fi
 done
 sleep 0.2
 echo "[ boot.img Extracted .. ]"
 echo " "
 sleep 0.2
 output="output_$RANDOM"
 mkdir -p $se0/$output
 cp $HOME/payload-dumper-termux/output/boot.img $se0/$output/
 rm -rf $HOME/payload-dumper-termux/tmp/*
 rm -rf $HOME/payload-dumper-termux/output/*
 echo -e "[ \033[1;32m<boot.img>\033[0m copied to ( \033[1;36mInternal_Storage\033[0m > \033[1;36m$output\033[0m ) directory .. ]"
 echo " "
 echo " "
 sleep 0.1
 echo "[ Note : these files and directories are altered .. ]"
 echo "  1. added files ($HOME/payload-dumper-termux/*) i.e. setup of payload-dumper-termux"
 echo "  2. appended (export pdtrun=*) and (alias pdt=*) lines in ($HOME/.bashrc) for shortcuts"
 echo "  3. and ($se0/$output/*) the extracted <boot.img> copied here"
 echo " "
 sleep 0.2
 echo "[ You can use <pdt> again to extract another boot.img ]"
 echo " "
 echo " (╯°□°）╯︵ ǝlƃooƃ "
 echo " "
