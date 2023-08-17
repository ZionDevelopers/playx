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
        
        function translateState(state) {
            if (state == 'playing') {
                state = 'PLAYING';
            } else if(state == 'paused') {
                state = 'PAUSED';
            } else if (state == 'buffering') {
                state = 'BUFFERING';
            } else if (state == 'idle') {
                state = 'Idle';
            }
           
           return state;
        }
        
        function getStats(stats) {
            sendPlayerData({ State: translateState(jwplayer().getState()), Position: stats.position, Duration: stats.duration });
        }
        
        function updateState() {
            sendPlayerData({ State: translateState(jwplayer().getState())});
        }

        jwplayer().on('ready', function () {
            jwplayer().on('time', getStats);
            jwplayer().on('play', updateState);
            jwplayer().on('pause', updateState);
            jwplayer().on('buffer', updateState);
            jwplayer().on('complete', function () {
                sendPlayerData({ State: 'COMPLETED'});
            });
            jwplayer().on('idle', updateState);
            jwplayer().setVolume(vol);
            jwplayer().seek(start);
        });
    }
});
