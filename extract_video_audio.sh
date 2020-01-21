#!/bin/bash

SOURCE_VIDEOS_DIR="$1"

cd "$SOURCE_VIDEOS_DIR"

RECORDINGS_ROOT="/Users/jorgecortes/Downloads/grabaciones_perros"

function generate_destination_dir () {
	FIRST_FILE=`ls | head -n 1`

	YEAR="${FIRST_FILE:0:4}"
	MONTH="${FIRST_FILE:5:2}"
	DAY="${FIRST_FILE:7:2}"

	DESTINATION_DIR="$RECORDINGS_ROOT/$YEAR/$MONTH/$YEAR$MONTH$DAY"
	mkdir -p "$DESTINATION_DIR"
	echo $DESTINATION_DIR
}

DESTINATION_DIR=`generate_destination_dir "$SOURCE_VIDEOS_DIR"`

function copy_videos () {
	for VIDEO_FILE in $SOURCE_VIDEOS_DIR/*.MP4
	do
		cp "$VIDEO_FILE" "$DESTINATION_DIR/"
	done
}

copy_videos


SOURCE_DISK=`df -P $SOURCE_VIDEOS_DIR | tail -1 | cut -d' ' -f 1`
# @todo make disk unmount unix friendly
diskutil unmount $SOURCE_DISK

###################################################################
cd "$DESTINATION_DIR"

EXTRACTED_AUDIO_DIR=$DESTINATION_DIR/extracted_audio
MERGED_AUDIO_FILE=$EXTRACTED_AUDIO_DIR/${PWD##*/}-merged_audio.mp3
FILE_LIST=$EXTRACTED_AUDIO_DIR/${PWD##*/}-files.txt
WAVE_IMAGE_FILE=$EXTRACTED_AUDIO_DIR/${PWD##*/}-wave.png

mkdir $EXTRACTED_AUDIO_DIR

function extract_audio () {

	for VIDEO_FILE in *.MP4
	do
	    AUDIO_FILE=$EXTRACTED_AUDIO_DIR/$VIDEO_FILE.mp3

	    echo "Extracting $VIDEO_FILE..."
	    ffmpeg -i $VIDEO_FILE -vn $AUDIO_FILE </dev/null > /dev/null 2>&1
	    echo file \'`echo $VIDEO_FILE.mp3`\' >> $FILE_LIST
	done

	echo "Merging audios..."
	ffmpeg -f concat -i $FILE_LIST $MERGED_AUDIO_FILE 2>&1 | tee -a $EXTRACTED_AUDIO_DIR/ffmpeg.log
	echo "Audios merged!"

	rm $EXTRACTED_AUDIO_DIR/*.MP4.mp3
}

function generate_wave_pic () {
	echo "Creating sound waves pic..."
	ffmpeg \
		-i $MERGED_AUDIO_FILE \
		-filter_complex "showwavespic=s=5000x1000" \
		-frames:v 1 $WAVE_IMAGE_FILE 2>&1 | tee \
		-a $EXTRACTED_AUDIO_DIR/ffmpeg.log
	echo "Sound waves pic created!"
}

function check_results () {
	# TODO: check for open and Audacity. Currently this is compatible only with MacOS
	open $MERGED_AUDIO_FILE -a /Applications/Audacity.app
	open $WAVE_IMAGE_FILE
}

extract_audio
generate_wave_pic
check_results

BACKUP_DESTINATION="pi@raspserver.local:/media/X-WING/grabaciones_perros/"
rsync -avzP --exclude=.DS_Store -e "ssh -p 50123" $RECORDINGS_ROOT $BACKUP_DESTINATION
