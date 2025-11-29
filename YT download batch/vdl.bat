@echo off
setlocal

echo download video - video download mode
echo input: video url as "%~1"
echo output: mkv video file with best video+audio quality merged
echo.

set "DOWNLOAD_DIR=%userprofile%\Downloads\YouTube-MP3"
set "URL=%~1"

yt-dlp -f "bv*+ba/b" --merge-output-format mkv ^
  -o "%DOWNLOAD_DIR%\%%(title)s.%%(ext)s" "%URL%"

endlocal
