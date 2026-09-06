var list = get("list");
var videoId = get("v");
var index = get("index") ? parseInt(get("index")) : 1;
var start = get("start") ? parseInt(get("start")) : 0;
var vol = get("vol") ? parseInt(get("vol")) : 100;
index = index-1;

window.onload = function () {
	player = new YT.Player("player", {
		width: window.innerWidth,
		height: window.innerHeight,
		host: "https://www.youtube-nocookie.com",	
		videoId: videoId,	
		playerVars: {
			origin: window.location.host,
			autoplay: 1,
			showinfo: 0,
			cc_load_policy: 0,
			iv_load_policy: 3,
			disablekb: 1,
			modestbranding: 1,
			rel: 0,
			controls: 1
		},
		events: {
			onReady: onPlayerReady,
			/** Credit: https://github.com/PurrCoding/gm-mediaplayer/blob/master/public/youtube.html  */			
			onApiChange: () => {
				// Captions module has (re)loaded — force it off. Cover both
				// module name variants and clear any active track, since
				// unloadModule alone is unreliable across player builds.
				try { player.unloadModule('captions'); } catch (e) {}
				try { player.unloadModule('cc'); } catch (e) {}
				try { player.setOption('captions', 'track', {}); } catch (e) {}
				try { player.setOption('cc', 'track', {}); } catch (e) {}
			},
		}
	})
}

function updateStats() {
	var state = player.getPlayerState();
	var stateText = "Unknown";
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
	event.target.loadPlaylist({ list: list, listType: 'playlist', index: index, startSeconds: start });
	setInterval(updateStats, 100);
	event.target.playVideo();
	player.setPlaybackQuality("hd1080");
	player.setVolume(vol);	
}