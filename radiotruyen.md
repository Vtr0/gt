# Get media url from https://radiotruyen.me

## Page to help create bookmarklet
Open [https://caiorss.github.io/bookmarklet-maker/](https://caiorss.github.io/bookmarklet-maker/) for pasting the pure js code to make bookmarklet.  
If the code is too long, you can use [https://www.uglifyjs.net/](https://www.uglifyjs.net/) to minify the code before pasting to make bookmarklet.

Note that, after pasting the code (below), there is an `bookmarklet` link created by the page that you can drag it directly to _browser bookmark bar_ to create the bookmarklet

## Code to get whole or part of playlist start from current item (so should start from item 1)
```javascript
/* JAVASCRIPT */
const statBar = document.querySelector('h4');
statBar.style.color = "red";
const nBtn = $('.jp-next'); //next button

function wait(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
window.cList = [];
window.dur0=[];
const _WAIT = 1000;

async function getLinks() {
  let curMed = $('#jquery_jplayer_1').data('jPlayer'); //get current media object
  let playlistLen = document.querySelectorAll(".jp-playlist ul li").length;

  //ask number of item to get information starting from current playing item
  let itemNum = parseInt( prompt('Number of items you want to get links (from current item). Put 0 for all. Max value is ' + playlistLen), 10 );
  if(isNaN(itemNum)) itemNum = 1
  else if(itemNum === 0) itemNum = playlistLen;

  for (let i = 0; i < itemNum; i++) {
    const curStat = curMed.status;
	
	// wait for some more time if duration is still not yet updated
	if(!curStat.duration) {
		let waitMore = 0;
		while(!curStat.duration && waitMore < 3){
			await wait(_WAIT); waitMore++;
		}
	}

    // curStat.media in the form {title: name, mp3: link}
    window.cList.push( Object.assign(curStat.media, {dur: curStat.duration}) );
	
	// remember chapter miss duration (because moving to next chapter too fast)
	if(curStat.duration == 0) window.dur0.push(curStat.media.title);
	
    statBar.textContent = curStat.media.title; //display title on the page showing we just done on that chapter
    nBtn.click();
    await wait(_WAIT);
  }
}
async function run() {
  await getLinks();

  navigator.clipboard.writeText(JSON.stringify(window.cList));
  alert('All items copied into clipboard OR in window.cList variable');

	if(window.dur0.length > 0) alert("Missing duration (or copy window.dur0 variable):\n" + window.dur0.join("\n"));
}

run();
```

## bookmarklet code after generated

```javascript
javascript:(function()%7Bconst%20statBar%20%3D%20document.querySelector('h4')%3B%0AstatBar.style.color%20%3D%20%22red%22%3B%0Aconst%20nBtn%20%3D%20%24('.jp-next')%3B%20%2F%2Fnext%20button%0A%0Afunction%20wait(ms)%20%7B%0A%20%20return%20new%20Promise(resolve%20%3D%3E%20setTimeout(resolve%2C%20ms))%3B%0A%7D%0Awindow.cList%20%3D%20%5B%5D%3B%0Awindow.dur0%3D%5B%5D%3B%0Aconst%20_WAIT%20%3D%201000%3B%0A%0Aasync%20function%20getLinks()%20%7B%0A%20%20let%20curMed%20%3D%20%24('%23jquery_jplayer_1').data('jPlayer')%3B%20%2F%2Fget%20current%20media%20object%0A%20%20let%20playlistLen%20%3D%20document.querySelectorAll(%22.jp-playlist%20ul%20li%22).length%3B%0A%0A%20%20%2F%2Fask%20number%20of%20item%20to%20get%20information%20starting%20from%20current%20playing%20item%0A%20%20let%20itemNum%20%3D%20parseInt(%20prompt('Number%20of%20items%20you%20want%20to%20get%20links%20(from%20current%20item).%20Put%200%20for%20all.%20Max%20value%20is%20'%20%2B%20playlistLen)%2C%2010%20)%3B%0A%20%20if(isNaN(itemNum))%20itemNum%20%3D%201%0A%20%20else%20if(itemNum%20%3D%3D%3D%200)%20itemNum%20%3D%20playlistLen%3B%0A%0A%20%20for%20(let%20i%20%3D%200%3B%20i%20%3C%20itemNum%3B%20i%2B%2B)%20%7B%0A%20%20%20%20const%20curStat%20%3D%20curMed.status%3B%0A%09%0A%09%2F%2F%20wait%20for%20some%20more%20time%20if%20duration%20is%20still%20not%20yet%20updated%0A%09if(!curStat.duration)%20%7B%0A%09%09let%20waitMore%20%3D%200%3B%0A%09%09while(!curStat.duration%20%26%26%20waitMore%20%3C%203)%7B%0A%09%09%09await%20wait(_WAIT)%3B%20waitMore%2B%2B%3B%0A%09%09%7D%0A%09%7D%0A%0A%20%20%20%20%2F%2F%20curStat.media%20in%20the%20form%20%7Btitle%3A%20name%2C%20mp3%3A%20link%7D%0A%20%20%20%20window.cList.push(%20Object.assign(curStat.media%2C%20%7Bdur%3A%20curStat.duration%7D)%20)%3B%0A%09%0A%09%2F%2F%20remember%20chapter%20miss%20duration%20(because%20moving%20to%20next%20chapter%20too%20fast)%0A%09if(curStat.duration%20%3D%3D%200)%20window.dur0.push(curStat.media.title)%3B%0A%09%0A%20%20%20%20statBar.textContent%20%3D%20curStat.media.title%3B%20%2F%2Fdisplay%20title%20on%20the%20page%20showing%20we%20just%20done%20on%20that%20chapter%0A%20%20%20%20nBtn.click()%3B%0A%20%20%20%20await%20wait(_WAIT)%3B%0A%20%20%7D%0A%7D%0Aasync%20function%20run()%20%7B%0A%20%20await%20getLinks()%3B%0A%0A%20%20navigator.clipboard.writeText(JSON.stringify(window.cList))%3B%0A%20%20alert('All%20items%20copied%20into%20clipboard%20OR%20in%20window.cList%20variable')%3B%0A%0A%09if(window.dur0.length%20%3E%200)%20alert(%22Missing%20duration%20(or%20copy%20window.dur0%20variable)%3A%5Cn%22%20%2B%20window.dur0.join(%22%5Cn%22))%3B%0A%7D%0A%0Arun()%3B%7D)()%3B
```

The result will be a json on `{window.cList}` variable 

## Using one of following js code to get one by one chapter
You can copy following code to paste to `URL` field of any bookmark
```javascript
/* JAVASCRIPT */
navigator.clipboard.writeText(JSON.stringify($("#jquery_jplayer_1").data("jPlayer").status.media)+",\n")

$(".jp-next").click();navigator.clipboard.writeText(JSON.stringify($("#jquery_jplayer_1").data("jPlayer").status.media)+",\n")
```

## Convert result to My App DB format Json
```javascript
/* JAVASCRIPT */
var toHhMmSs = (sec) => {
	function pad(n, width, z) {
		z = z || '0';
		n = n + '';
		return String(n).padStart(width, z); // '0009'
	}
	
	if (isNaN(sec)) return "00:00";
	sec = sec << 0; //make sec to be integer
	let h = (sec / 3600) << 0; sec = sec % 3600;
	let m = (sec / 60) << 0;
	s = sec % 60;
	return (h ? h + ":" : "") + pad(m, 2) + ":" + pad(s, 2);
}
```
Then do following to change to duration from number to H:mm:ss format
```javascript
c = {Paste the above result (from window.cList)}
//may do more processing on title if needed
m = c.map(t => {return {tit:t.title, url: [t.mp3], dur: toHhMmSs(t.dur)} } ); copy(m)
```

# BATCH DOWNLOAD FILES USING CURL

## Install cURL
Curl is a command-line tool for transferring data from or to a server using URLs. You can go [github](https://github.com/curl/curl) or [https://curl.se/](https://curl.se/). To install cURL on window
```batch
winget install cUrl
```

## Download single url
Single window prompt to download a file. Note that curl can download a file even if the link preven cross-origin, even if the link does not work when paste directly into browser
```batch
curl -L -H "User-Agent: Mozilla/5.0" -H "Referer: https://radiotruyen.me" -o "121.mp3" "https://files.radiotruyen.me/4817--vdck/vNUmXGaQ6CidTRYZOL~ViQ==.mp3"
```

## Batch download and rename
----------
batch file to using curl to download even if radiotruyen.me prevents cross-origin and we cannot download file directly from browser

### input.txt file format
files.txt should look as follows
```txt
119.mp3 https://files.radiotruyen.me/4817--vdck/eY2inG1vzzMsz9JbENsT0g==.mp3
120.mp3 https://files.radiotruyen.me/4817--vdck/qZ%2B74vpV54Ih8ujG4l5MOg==.mp3
```
### Batch file to run cUrl
Create batch file as follows:
```batch
REM download_mp3.bat
@echo off
setlocal enabledelayedexpansion

REM Path to your text file
set "filelist=files.txt"

REM Loop through each line in the text file
for /f "tokens=1* delims= " %%A in (%filelist%) do (
     set "output=%%A"
     set "url=%%B"
     echo Downloading !url! to !output! ...
     REM curl -L -o "!output!" "!url!"
     curl -L -H "User-Agent: Mozilla/5.0" -H "Referer: https://radiotruyen.me" -o "!output!" "!url!"

)

echo All downloads completed.
pause
```

# Get duration for all mp3 files

## Using batch file
grab_dur.bat will get durations of all url stored in "input.txt" and save to "output.txt"
Note that this using Curl and ffprobe (which part of ffmpeg - can install by "winget install ffmpeg")
Install Curl: winget install curl

__Requirement__  
```command
winget install curl ffmpeg
```
### Input file
`input.txt`
```text
25.mp3 https://archive.org/download/DPTK2_NgheAudio/25.mp3
26.mp3 https://archive.org/download/DPTK2_NgheAudio/26.mp3
27.mp3 https://archive.org/download/DPTK2_NgheAudio/27.mp3
```

### Batch file to get duration
```batch
@echo off
setlocal enabledelayedexpansion

rem === Input and output files ===
set "INPUT_FILE=input.txt"
set "OUTPUT_FILE=output.txt"

rem === Clear old output ===
if exist "%OUTPUT_FILE%" del "%OUTPUT_FILE%"

echo Processing MP3 durations...
echo -------------------------------------

for /f "tokens=1,* delims= " %%A in (%INPUT_FILE%) do (
    set "NAME=%%A"
    set "URL=%%B"
    echo Getting duration for !NAME!...

    rem Run curl and ffprobe as a single line
	rem orginal command which can run on cmd window: curl -L -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"  -e "https://radiotruyen.me"  "https://files.radiotruyen.me/4817--vdck/BvEMe46abfYCX9AIjFdTfg==.mp3" | ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 -
    for /f "usebackq tokens=* delims=" %%D in (`
	curl -L -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"  -e "https://radiotruyen.me" "!URL!" ^| ffprobe -v error -show_entries format^=duration -of default^=noprint_wrappers^=1:nokey^=1 - 2^>nul
      `) do (
        set "DURATION=%%D"
    )

    if not defined DURATION (
        echo !NAME! ERROR >> "%OUTPUT_FILE%"
        echo   Failed to get duration for !NAME!
    ) else (
        rem --- Convert seconds to H:MM:SS ---
        for /f "tokens=1,2 delims=." %%m in ("!DURATION!") do set /a "SEC=%%m"
        set /a "HOUR=SEC/3600"
        set /a "MIN=(SEC%%3600)/60"
        set /a "SEC=SEC%%60"

        rem Format with leading zeros
        if !MIN! lss 10 set "MIN=0!MIN!"
        if !SEC! lss 10 set "SEC=0!SEC!"

        if !HOUR! gtr 0 (
            set "TIME=!HOUR!:!MIN!:!SEC!"
        ) else (
            set "TIME=!MIN!:!SEC!"
        )

        echo {"tit": "!NAME!", "dur": "!TIME!"},>>"%OUTPUT_FILE%"
        echo   SUCCESS !NAME! : !TIME!
    )

    set "DURATION="
)

echo -------------------------------------
echo Results saved to "%OUTPUT_FILE%"
pause
```
### Output file
`output.txt`
```json
{"tit": "100.mp3", "dur": "1:02:14"},
{"tit": "119.mp3", "dur": "58:05"},
{"tit": "120.mp3", "dur": "48:34"},
{"tit": "121.mp3", "dur": "48:59"},
```

## Using python
Using python to get the duration of all mp3 files in the same folder

__Requirement__  
we need Mutagen - which is a Python library used for handling audio metadata, also known as tags. It supports a wide range of audio formats, including MP3, Ogg Vorbis, FLAC, and others.
```command
pip install mutagen
```

### python file
`get_dur.py`
```python
import os
from mutagen.mp3 import MP3
from datetime import timedelta

# Path to your folder containing MP3 files
folder_path = "."

# Path to output text file
output_file = "mp3_durations.txt"

def format_duration(seconds):
    """Convert seconds to H:mm:ss or mm:ss format (omit hours if < 1 hour)."""
    td = timedelta(seconds=int(seconds))
    total_seconds = int(td.total_seconds())
    hours, remainder = divmod(total_seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    if hours > 0:
        return f"{hours}:{minutes:02}:{seconds:02}"
    else:
        return f"{minutes}:{seconds:02}"

with open(output_file, "w", encoding="utf-8") as f:
    for file_name in os.listdir(folder_path):
        if file_name.lower().endswith(".mp3"):
            file_path = os.path.join(folder_path, file_name)
            audio = MP3(file_path)
            duration = audio.info.length
            formatted_duration = format_duration(duration)
            #line = f'{{"dur": "{formatted_duration}"}},\n'
            line = f'{{"tit": "{file_name}", "dur": "{formatted_duration}"}},\n'
            f.write(line)
            print(line.strip())

print(f"\nAll durations saved to: {output_file}")
```