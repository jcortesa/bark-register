#Usage

First time, assign execution permissions:

```sh
$ chmod u+x ./extract_video_audio.sh
```

To execute it:

```sh
$ ./extract_video_audio.sh <video_files_directory>
```

It will generate inside the `<video_files_directory>` a new folder named `extracted_audio` with all the generated files, such as:

- `xxx_merged_audio.mp3`: a complete audio extract from the video source
- `xxx_wave.png`: a wave diagram that can be used to see if there are any hight volume noises (barks) in the audio extract

# Compress script

```sh
nohup /home/pi/compress-avconv-videos-mp4.sh 2> foo.err < /dev/null &
```

#Dependencies
* MacOS-like
	** `rsync`
	** `ffmpeg`
	** `avconv` (a `ffmpeg` fork)
	** `diskutil`
	** `open`
	** `audacity`

* UNIX-like
	** `cd`
	** `ls`
	** `head`
	** `mkdir`
	** `echo`
	** `cp`
	** `df`
	** `tail`
	** `cut`
	** `rm`

