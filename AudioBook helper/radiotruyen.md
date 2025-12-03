# Get media url from https://radiotruyen.me

## Page to help create bookmarklet
Open [https://caiorss.github.io/bookmarklet-maker/](https://caiorss.github.io/bookmarklet-maker/) for pasting the pure js code to make bookmarklet.  
If the code is too long, you can use [https://www.uglifyjs.net/](https://www.uglifyjs.net/) to minify the code before pasting to make bookmarklet.

Note that, after pasting the code (below). After click `Generate Bookmarklet` button on the page, there is an `bookmarklet` link (right below the button) created by the page that you can drag it directly to _browser bookmark bar_ to create the bookmarklet

## Code to get whole or part of playlist start from current playing item (so should start from item 1)
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

## Bookmarklet code after generated
> The below code already been minimized before transforming to a `bookmakrlet`

```javascript
javascript:(function()%7Bconst%20statBar%3Ddocument.querySelector(%22h4%22)%3BstatBar.style.color%3D%22red%22%3Bconst%20nBtn%3D%24(%22.jp-next%22)%3Bfunction%20wait(i)%7Breturn%20new%20Promise(t%3D%3EsetTimeout(t%2Ci))%7Dwindow.cList%3D%5B%5D%3Bwindow.dur0%3D%5B%5D%3Bconst%20_WAIT%3D1e3%3Basync%20function%20getLinks()%7Blet%20i%3D%24(%22%23jquery_jplayer_1%22).data(%22jPlayer%22)%3Blet%20t%3Ddocument.querySelectorAll(%22.jp-playlist%20ul%20li%22).length%3Blet%20n%3DparseInt(prompt(%22Number%20of%20items%20you%20want%20to%20get%20links%20(from%20current%20item).%20Put%200%20for%20all.%20Max%20value%20is%20%22%2Bt)%2C10)%3Bif(isNaN(n))n%3D1%3Belse%20if(n%3D%3D%3D0)n%3Dt%3Bfor(let%20t%3D0%3Bt%3Cn%3Bt%2B%2B)%7Bconst%20e%3Di.status%3Bif(!e.duration)%7Blet%20t%3D0%3Bwhile(!e.duration%26%26t%3C3)%7Bawait%20wait(_WAIT)%3Bt%2B%2B%7D%7Dwindow.cList.push(Object.assign(e.media%2C%7Bdur%3Ae.duration%7D))%3Bif(e.duration%3D%3D0)window.dur0.push(e.media.title)%3BstatBar.textContent%3De.media.title%3BnBtn.click()%3Bawait%20wait(_WAIT)%7D%7Dasync%20function%20run()%7Bawait%20getLinks()%3Bnavigator.clipboard.writeText(JSON.stringify(window.cList))%3Balert(%22All%20items%20copied%20into%20clipboard%20OR%20in%20window.cList%20variable%22)%3Bif(window.dur0.length%3E0)alert(%22Missing%20duration%20(or%20copy%20window.dur0%20variable)%3A%5Cn%22%2Bwindow.dur0.join(%22%5Cn%22))%7Drun()%3B%7D)()%3B
```
Notes:
* The script can only scan for the `link`+`duration` from current playing chapter to the end of playlist, so if you want to grab links from any chapter, play that chapter first.
* The result will be a json on `window.cList` variable (which you can get from browser's `Developer Tool`). It also being copied to clipboard, and can paste into [json-editor](https://jsoneditoronline.org/) for online formatting.
*>* The list of chapter that can't get the `duration` is in variable `window.dur0`.

## Using one of following js code to get one by one chapter
One of following code to paste the current chapter link to clipboard
```javascript
navigator.clipboard.writeText(JSON.stringify($("#jquery_jplayer_1").data("jPlayer").status.media)+",\n")
```
```javascript
$(".jp-next").click();navigator.clipboard.writeText(JSON.stringify($("#jquery_jplayer_1").data("jPlayer").status.media)+",\n")
```

## Convert result to Json database format of my AudioBook webapp
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
