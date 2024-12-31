# binex
echo " "
echo "zip files found .."
echo " "
find /storage/emulated/0 -type f -name '*.zip' -size +1G -print 2>/dev/null | nl
file_count=$(find /storage/emulated/0 -type f -name '*.zip' -size +1G 2>/dev/null | wc -l)
echo $file_count

echo " "
read -p "Select your rom by entering it's corresponding number : " input

# validate the input
if ! [[ "$input" =~ ^[0-9]+$ ]]; then # testing for numbers
        echo " "
        echo "Invalid input "\'$input\'"  Please enter a valid number in range (1-$file_count)"
        echo " "
        exit 1
elif [ "$input" -lt 1 ] || [ "$input" -gt "$file_count" ]; then # testing for numbers are in range
	echo " "
	echo "Invalid input "\'$input\'"  Please enter a valid number in range (1-$file_count)"
	echo " "
	exit 1
fi

echo " "
echo "You've selected"
echo " "
find /storage/emulated/0 -type f -name '*.zip' -size +1G -print 2>/dev/null | nl | sed -n ${input}p
selected=$(find /storage/emulated/0 -type f -name '*.zip' -size +1G -print 2>/dev/null | sed -n ${input}p)
echo $selected
