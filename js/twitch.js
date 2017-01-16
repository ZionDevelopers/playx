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

function run () {
	console.log("Running...");
	var channel = "twitch";
	var video = 0;
	var options = {
		width: window.innerWidth,
		height: window.innerHeight,
		channel: "twitch",	
		autoplay: true,
		mute: false
	};
	
	channel = unescape(get("channel"));	
	video = unescape(get("video"));
	
	if (channel != "") {
		options.channel = channel;
	}
	
	if (video != "NaN" && video !== 0) {
		options.video = video;
	}
	
	if (channel != "") {
		window.twitchPlayerAPI = new Twitch.Player("player", options);
		console.log("Starting Up!");
	}
	
	console.log("Channel: ");
	console.log(channel);
	console.log("video:" + video);
}

window.onload = run;