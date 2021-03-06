#/bin/bash
VIDEOS_DIR="${1}"
VIDEO_EXTENSION="MP4"
COMPRESSED_SUFFIX="compressed"

for VIDEO in $(find "${VIDEOS_DIR}" -name "*.${VIDEO_EXTENSION}" | sort -V);
do
        VIDEO_LENGTH=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$VIDEO")
        COMPRESSED="${VIDEO%.*}.${COMPRESSED_SUFFIX}.${VIDEO_EXTENSION}"

        if [[ "${VIDEO}" == *"${COMPRESSED_SUFFIX}"* ]]; then
                COMPRESSED="${VIDEO}"
                echo "$(date +"%Y%m%d_%H%M"): ${VIDEO} already compressed"
        fi

        if [ -f "$COMPRESSED" ]; then
                COMPRESSED_VIDEO_LENGTH=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$COMPRESSED")

                if [ ! "$VIDEO_LENGTH" = "$COMPRESSED_VIDEO_LENGTH"  ]; then
                        echo "$(date +"%Y%m%d_%H%M"): going to remove ${COMPRESSED}"
                        rm "$COMPRESSED"
                fi
        fi

        if [ ! -f "$COMPRESSED" ]; then
               echo "$(date +"%Y%m%d_%H%M"): going to compress ${VIDEO}"
               ffmpeg -i "$VIDEO" \
                        -c:v libx264 \
                        -preset veryfast \
                        -b:v 800k \
                        -bufsize 1200k \
                        -vf scale=1920:1080,format=yuv420p \
                        -c:a copy \
                        "$COMPRESSED"

                if [ -f "$COMPRESSED" ]; then
                        COMPRESSED_VIDEO_LENGTH=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$COMPRESSED")

                        if [  "$VIDEO_LENGTH" = "$COMPRESSED_VIDEO_LENGTH"  ]; then
                                echo "$(date +"%Y%m%d_%H%M"): going to remove ${VIDEO}"
                                rm "$VIDEO"
                        fi
                fi
        fi

done