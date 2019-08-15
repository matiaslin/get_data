#!/bin/bash

# Full path of where the script is
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Checking for empty vars
empty() {
  if [ -z "$1" ]
  then
    echo "Didn't quite get that... Please enter your answer again."
  else
    answered=1
  fi
}

echo
echo "######################################################################################"
echo
echo " Welcome!"
echo " This program will allow you to create your own dataset extracted from Google images."
echo " USAGE: Just help us out with the following information and we'll do the rest."
echo " RECOMMENDATIONS: Look up the query beforehand in Google Images."
echo " NOTE: Expect the quality of the images to be as good as a Google Images search".
echo
echo "######################################################################################"

redo=1
while [ $redo -eq 1 ]; do
  echo 
  # Query
  answered=0
  while [ $answered -eq 0 ]
  do
    echo "What are we looking for today:"
    read x
    empty $x
  done

  # Format
  answered=0
  while [ $answered -eq 0 ]
  do
    echo "Format (jpg, png):"
    read format
    empty $format
    if [ $answered -eq 1 ]; then
      if [ $format != "jpg" -a $format != "png" ]; then
        answered=0
        echo "Wrong format. Please try that again."
      fi
    fi
  done

  # Related Images
  answered=0
  while [ $answered -eq 0 ]
  do
    echo "Want more images (look for related images)? [y/n]:"
    read want
    empty $want
    if [ $answered -eq 1 ]; then
      if [ $want != "y" -a $want != "n" ]; then
        answered=0
        echo "Wrong answer. Please try that again."
      fi
    fi
  done

  # Image Limit
  answered=0
  while [ $answered -eq 0 ]
  do
    echo "Limit of images per search (Recommended 0-1000):"
    read limit
    empty $limit
    if [ $answered -eq 1 ]; then
      if [[ -n ${limit//[0-9]/} ]]; then
        answered=0
        echo "Your limit needs to be a valid integer"
      fi
    fi
  done

  # Folder Number Maximum
  if [ $want == 'y' ]; then
    answered=0
    while [ $answered -eq 0 ]
    do
      echo "Maximum number of folders (Recommended 5-15, 8 ~3000 images):"
      read max 
      empty $max
      if [ $answered -eq 1 ]; then
        if [[ -n ${max//[0-9]/} ]]; then
          answered=0
          echo "Your max needs to be a valid integer"
        fi
      fi
    done
  fi

  echo
  echo ------------------------------------------------------------------
  echo "OK! Here's what we've got..."
  echo "Query: $x"
  echo "Format: $format"
  echo "Related Images: $want"
  echo "Limit: $limit"
  if [ $want == 'y' ]; then
    echo "Max folders: $max"
  fi
  echo ------------------------------------------------------------------

  echo
  answered=0
  while [ $answered -eq 0 ]
  do
    echo "Do you want to proceed with the download? [y/n]"
    read redo
    empty $redo
    if [ $answered -eq 1 ]; then
      if [ $redo != "y" -a $redo != "n" ]; then
        answered=0
        echo "Wrong answer. Please try that again."
      elif [ $redo == "y" ]; then
        redo=0
        echo OK... Starting download.
      else
        redo=1
      fi
    fi
  done
done

# Renaming the filename
query=$x
x=$(echo "$x" | tr " " _)

# PART 1: Downloading the images 
mining_path=$DIR/mining/google-images-download/google_images_download/
log_file=$mining_path"downloads/download_"$x".log"

if [ $want == "n" ]; then
  echo Downloading $query now...
  python $mining_path/google_images_download.py -k "$query" -l $limit -f $format -cd $DIR/bin/chromedriver.exe &>$log_file
else
  echo Downloading $query now...
  clock=$((limit/10 * 3))
  python $mining_path/google_images_download.py -k "$query" -l $limit -f $format -cd $DIR/bin/chromedriver.exe -ri &>$log_file &
  PID=$!
  # Checking the amount of folders it downloaded so far
  echo .
  echo .
  echo .
  num_folders=0
  while [ $((num_folders)) -lt $((max)) ]; do 
    sleep $clock
    num_folders=$(ls | find $DIR/downloads -type d -name "$query*" | wc -l)
    echo "Number of folders downloaded: "$num_folders"..."
  done
  kill $PID
fi

# Dealing with download folder
for d in $DIR/downloads/*/; do
  if [[ $d == $DIR/downloads/$query* ]]; then
    mv "$d" $mining_path/downloads
  fi
done
if [ -z "$(ls -A $DIR/downloads)" ]; then
  rm -r $DIR/downloads
fi

# PART 2: Creating total folder
path=$DIR/mining/google-images-download/google_images_download/downloads/
dir_name=$path$format'_'$x
echo Creating $dir_name
extra=0
while test -d "$dir_name"; do
  ((extra++))
  echo Folder already exists.
  dir_name=$path$format'_'$x'_'$extra
  echo Creating $dir_name
done
mkdir $dir_name
target=$path/$query
for d in $path/*/ ; do
  if [[ $d != $target* ]]; then
    continue
  fi
  echo Moving $d
  mv "$d" $dir_name
done

mkdir $dir_name/total
echo
echo "Copying over the images... This will take a while"
for d in $dir_name/*/; do
  if [[ $d == $dir_name/total/ ]]; then
    continue
  fi
  cp "$d"/*.jpg $dir_name/total/
done

# PART 3: Applying malformed filter
echo
echo Looking for corrupted images...
cp $DIR/image_filtering/malformed.* $dir_name/total/
cp $DIR/image_filtering/remove.sh $dir_name/total/
errlog='asdlflkdj_'$x'.err'
bash $dir_name/total/malformed.sh $dir_name/total 2> $DIR/$errlog
rm $DIR/$errlog
echo
echo Removing corrupted images...
bash $dir_name/total/remove.sh $dir_name/total
mv $dir_name/total/malformed.txt $dir_name/

# Moving everything to our location
echo .
echo .
echo .
echo Finalizing everything...
mv $log_file $dir_name/
target_dir=$DIR/dataset_get_data/
mkdir -p $target_dir 
mv $dir_name/ $target_dir$format'_'$x
# Creating tar files
cd $target_dir$format'_'$x && tar -cvf $format'_'$x'.tar' total/*

echo
echo Your images are ready! Go to $DIR/dataset_get_data/$format'_'$x/total/
echo Note: You may have to run additional filters.
