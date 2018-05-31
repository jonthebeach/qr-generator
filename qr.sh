#!/bin/bash

# Name of the temporary file
INPUT="$1.tmp"
OLDIFS=$IFS
IFS=,

# Uncomment to skip header line, and comment the copy line
#tail -n +2 $1 > $INPUT
cp $1 $INPUT

# Obtain the current directory, where the output will be stored
currentDir=`pwd`
# The output folder name
bn=`basename $INPUT .csv.tmp`

echo "$bn"

echo "Creating directory (if not exists): $bn"
[ -d $bn ] || mkdir $bn

# Replacing internal commas to semicolons
sed -i '.original' 's/, /; /g' $INPUT
# Removing special characters
sed -i '.original' 'y/áÁàÀãÃâÂéÉêÊíÍóÓõÕôÔúÚñÑçÇŠČŽ/aAaAaAaAeEeEiIoOoOoOuUnNcCSCZ/' $INPUT

[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }

count=1
# Reading all the lines of the file
while read fullname company job email
do
	fullname="${fullname%\"}"
	fullname="${fullname#\"}"

	company="${company%\"}"
  company="${company#\"}"

	job="${job%\"}"
  job="${job#\"}"

  # Setting the file names to the fullname with underscore instead of spaces.
  # The output folder is the name of the input file without the .csv ending.
  fnameEPS=$(printf "%s/%s/%03d_%s.eps" $currentDir $bn $count ${fullname// /_})
	fnamePNG=$(printf "%s/%s/%03d_%s.png" $currentDir $bn $count ${fullname// /_})

	echo "File stored in: $fnameEPS"
	echo "File stored in: $fnamePNG"

  # Store the QR content in the content variable
	read -r -d '' content << EndOfMessage
Name: $fullname
Company: $company
Job description: $job
Email: $email
EndOfMessage

	echo "$content"

  # Using the qrencode library to generate the QR in EPS and PNG formats
	qrencode -t EPS -o $fnameEPS "$content"
	qrencode -o $fnamePNG -d 300 -s 18 "$content"

	(( count++ ))
done < $INPUT

# Setting the field separator back to its old value
IFS=$OLDIFS

# Deleting temporary files
rm $INPUT.original
rm $INPUT
