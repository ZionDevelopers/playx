function get(variable)
{
       var query = window.location.search.substring(1);
       var vars = query.split("&");
       for (var i=0;i<vars.length;i++) {
               var pair = vars[i].split("=");
               if(pair[0] == variable){return pair[1];}
       }
       return(false);
}

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-43230779-1', 'ziondevelopers.github.io');
ga('send', 'pageview'); 

window.twitchPlayerAPI = {
	play: function () {},
	pause: function () {},
	volume: function () {}
}

$(document).ready(function () {
	var channel = "twitch";
	var video = "";
	var options = {
		width: window.innerWidth,
		height: window.innerHeight,
		channel: "twitch",	
		autoplay: true,
		mute: false,
		html5: false
	};

	channel = $.trim(unescape(get("channel")));	
	video = $.trim(unescape(get("video")));

	if (channel != "") {
		options.channel = channel;
	}

	if (video != "NaN" || video != false || video != "") {
		options.video = video;
	}

	if (channel != "") {
		$("div#player").html("");
		window.twitchPlayerAPI = new Twitch.Player("player", options);
		console.log("Starting Up!");
	}

	console.log("Channel: ");
	console.log(channel);
	console.log("video:");
	console.log(video);
	console.log("Options:");
	console.log(options);
});
