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
	  "autostart": true,
	  "controls": false,
	  "displaydescription": false,
	  "displaytitle": false,
	  "flashplayer": "swf/jwplayer.flash.swf",  
	  "key": "oNx4/gANnEVNwZY7h+rheEEvZ53JPu6MP5nChFnRZat5izBC1hh+eynqYd0=",
	  "ph": 1,
	  "preload": "none",
	  "repeat": false,
	  "stagevideo": false,
	  "stretching": "uniform",
	  "width": '100%',
	  "playlist": [
		{
		  "sources": [
			{
			  "file": get('url'),
			}
		  ],
		  "tracks": []
		}
	  ]
	});
}