var videoId = get("v") || getByURL("v", urlParam("url"));
var start = parseInt(get("start"));
var vol = get("vol") ? parseInt(get("vol")) : 100;

function onYouTubeIframeAPIReady() {
}

function updateStats() {
	var state = player.getPlayerState();
	var stateText = "Unknow";
	if (state == -1) {
		stateText = "Unstarted"
	} else if (state == 0) {
		stateText = "COMPLETED"
	} else if (state == 1) {
		stateText = "PLAYING"
	} else if (state == 2) {
		stateText = "PAUSED"
	} else if (state == 3) {
		stateText = "BUFFERING"
	} else if (state == 5) {
		stateText = "Video Cued"
	}
	sendPlayerData({
		State: stateText,
		Position: player.getCurrentTime(),
		Duration: player.getDuration()
	})
}

function onPlayerReady(event) {
	setInterval(updateStats, 100);
	event.target.playVideo();
	player.setPlaybackQuality("hd1080");
	player.setVolume(vol)
}

window.onload= function () {
	player = new YT.Player("player", {
			width: window.innerWidth,
			height: window.innerHeight,
			videoId: videoId,
			host: "https://www.youtube-nocookie.com",
			playerVars: {
				origin: window.location.host,
				autoplay: 1,
				showinfo: 0,
				cc_load_policy: 0,
				iv_load_policy: 3,
				disablekb: 1,
				modestbranding: 1,
				rel: 0,
				controls: 1,
				start: start
			},
			events: {
				onReady: onPlayerReady
			}
		});
	}, 1000);
}