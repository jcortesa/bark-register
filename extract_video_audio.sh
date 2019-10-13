#!/bin/bash
DESTIONATION_DIR="$1"
cd $DESTIONATION_DIR

EXTRACTED_AUDIO_DIR=extracted_audio
MERGED_AUDIO_FILE=$EXTRACTED_AUDIO_DIR/${PWD##*/}-merged_audio.mp3
FILE_LIST=$EXTRACTED_AUDIO_DIR/${PWD##*/}-files.txt
WAVE_IMAGE_FILE=$EXTRACTED_AUDIO_DIR/${PWD##*/}-wave.png

mkdir $EXTRACTED_AUDIO_DIR

function extract_audio () {

	for VIDEO_FILE in *.MP4
	do
	    AUDIO_FILE=$EXTRACTED_AUDIO_DIR/$VIDEO_FILE.mp3

	    echo "Extracting $VIDEO_FILE..."
	    ffmpeg -i $VIDEO_FILE -vn $AUDIO_FILE </dev/null > /dev/null 2>&1 &
	    echo file \'`echo $VIDEO_FILE.mp3`\' >> $FILE_LIST
	done
	wait

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

extract_audio "$1"
generate_wave_pic