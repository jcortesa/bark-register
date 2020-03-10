#/bin/bash

#Remove non compressed files
find ${1:'.'} -type f \( -name "*.MP4" -and ! -name "*compressed*" \) -print0 | xargs -0 rm

# @todo: remove only files that have a `.compressed.` "twin"