#!/bin/bash

SOURCE_VIDEOS_DIR="$1"

cd "$SOURCE_VIDEOS_DIR"

RECORDINGS_ROOT="${2:-/Users/jorgecortes/Downloads/grabaciones_perros}"

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

function unmount_source_disk () {
	SOURCE_DISK=`df -P $1 | tail -1 | cut -d' ' -f 1`
	# @todo make disk unmount unix friendly
	diskutil unmount $SOURCE_DISK
}

unmount_source_disk $SOURCE_VIDEOS_DIR

echo $DESTINATION_DIR
