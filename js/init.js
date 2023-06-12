jwplayer.key = "lmwviL3c55Ymnx4fMjEUQeiU00zeXf6TCiDHQA==";

// Get URL
var url = unescape(get("url"));

// Youtube API Fallback

window.onYouTubeIframeAPIReady = function () {
    window.jwplayer = new YT.Player("player", {
        "width": window.innerWidth,
        "height": window.innerHeight,
        videoId: getByURL("v", url),
        playerVars: {
            controls: 0,
            autoplay: 1,
            showinfo: 0,
            iv_load_policy: 3,
            autohide: 0,
            rel: "0",
            wmode: "opaque",
            modestbranding: 1,
            //nohtml5: 1
        }
    });

    jwplayer.pause = jwplayer.pauseVideo
    jwplayer.play = jwplayer.playVideo
}

$(document).ready(function () {
    // Check for URL
    if (url != "false") {
        // Uncomment For Youtube API Fallack
        if (url.indexOf("youtube.com") === -1) {
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
        }
    }
});
