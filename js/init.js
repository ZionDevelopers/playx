jwplayer.key = "lmwviL3c55Ymnx4fMjEUQeiU00zeXf6TCiDHQA==";

// Get URL
var url = unescape(get("url"));
var start = get('start') ? parseInt(get('start')) : 0;
var vol = get('vol') ? parseInt(get('vol')) : 100;

jwplayer.pause = jwplayer.pauseVideo
jwplayer.play = jwplayer.playVideo

$(document).ready(function () {
    // Check for URL
    if (url != "false") {    
        /** Initialize player **/
        jwplayer("player").setup({
            "aspectratio": "auto",
            "autostart": true,
            "controls": true,
            "displaydescription": false,
            "displaytitle": true,
            "file": url,
            "preload": "auto",
            "primary": "flash", // Use HTML5 As Primary To Have Native YouTube WebM HTML5 Support, Flash Fallback For Other Content
            "repeat": false,
            "loop": false,
            "stagevideo": false,
            "stretching": "uniform",
            "visualplaylist": false,
            "width": window.innerWidth,
            "height": window.innerHeight
        });  
        
        function getStats(stats) {
            sendPlayerData({ State: jwplayer().getState(), Position: stats.position, Duration: stats.duration });
        }
        
        function updateState() {
            sendPlayerData({ State: jwplayer().getState()});
        }

        jwplayer().on('ready', function () {
            jwplayer().on('time', getStats);
            jwplayer().on('play', updateState);
            jwplayer().on('pause', updateState);
            jwplayer().on('buffer', updateState);
            jwplayer().on('complete', updateState);
            jwplayer().on('idle', updateState);
            jwplayer().setVolume(vol);
            jwplayer().seek(start);
        });
    }
});
