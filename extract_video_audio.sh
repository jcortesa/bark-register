#!/bin/bash
cd "$1"

EXTRACTED_AUDIO_DIR=extracted_audio
MERGED_AUDIO_FILE=$EXTRACTED_AUDIO_DIR/${PWD##*/}-merged_audio.mp3
FILE_LIST=$EXTRACTED_AUDIO_DIR/${PWD##*/}-files.txt
WAVE_IMAGE_FILE=$EXTRACTED_AUDIO_DIR/${PWD##*/}-wave.png
GNUPLOT_DATA_FILE=$EXTRACTED_AUDIO_DIR/${PWD##*/}-gnuplot.data

mkdir $EXTRACTED_AUDIO_DIR

for VIDEO_FILE in *.MP4
do
    AUDIO_FILE=$EXTRACTED_AUDIO_DIR/$VIDEO_FILE.mp3

    echo "Extracting $VIDEO_FILE..."
    ffmpeg -i $VIDEO_FILE -vn $AUDIO_FILE 2>&1 | tee -a $EXTRACTED_AUDIO_DIR/ffmpeg.log
    echo file \'`echo $VIDEO_FILE.mp3`\' >> $FILE_LIST
done

echo "Merging audios..."
ffmpeg -f concat -i $FILE_LIST $MERGED_AUDIO_FILE 2>&1 | tee -a $EXTRACTED_AUDIO_DIR/ffmpeg.log
echo "Audios merged!"

rm $EXTRACTED_AUDIO_DIR/*.MP4.mp3

echo "Creating sound waves pic..."
ffmpeg \
	-i $MERGED_AUDIO_FILE \
	-filter_complex "showwavespic=s=5000x1000" \
	-frames:v 1 $WAVE_IMAGE_FILE 2>&1 | tee \
	-a $EXTRACTED_AUDIO_DIR/ffmpeg.log
echo "Sound waves pic created!"

# echo "Creating gnuplot data..."
# ffmpeg -i $MERGED_AUDIO_FILE -ac 1 -filter:a aresample=8000 -map 0:a -c:a pcm_s16le -f data - > $GNUPLOT_DATA_FILE
# echo "Gnuplot data created!"

