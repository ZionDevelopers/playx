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

window.onload = function () { 
	/** Initialize player **/
	jwplayer("player").setup({
	  "aspectratio": "16:9",
	  "autostart": true,
	  "controls": false,
	  "displaydescription": false,
	  "displaytitle": true,
	  "flashplayer": "//ssl.p.jwpcdn.com/player/v/7.4.4/jwplayer.flash.swf",
	  "ga": {
		"idstring": "title"
	  },	  
	  "hlshtml": true,
	  "mute": false,
	  "ph": 1,
	  "pid": "IJzySFh8",	  
	  "plugins": {
		"https://assets-jpcust.jwpsrv.com/player/6/6124956/ping.js": {
		  "pixel": "https://content.jwplatform.com/ping.gif"
		}
	  },
	  "playlist": [
		{
		  "sources": [
			{
			  "file": escape(get("url"))
			}
		  ]
		}
	  ],
	  "plugins": {
		"https://assets-jpcust.jwpsrv.com/player/6/6124956/ping.js": {
		  "pixel": "https://content.jwplatform.com/ping.gif"
		}
	  },
	  "preload": "auto",
	  "primary": "flash",
	  "repeat": false,
	  "stagevideo": false,
	  "stretching": "uniform",
	  "visualplaylist": false,
	  "width": window.innerWidth,
	  "height": window.innerHeight
	});
}