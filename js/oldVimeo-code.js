
var checkReady = setInterval(function(){ if(document.readyState === "complete"){ playerReady(); clearInterval(checkReady);} }, 10);
    var knownState = "Loading...";
    var player = document.getElementsByTagName('object')[0];
    
    function sendPlayerData(data) {
        var str = "";
        for (var key in data) {
            str += encodeURIComponent(key) + "=" + encodeURIComponent(data[key]) + "&"
        }
        playx.processPlayerData(str);
    }
    
    function updateState() {
      sendPlayerData({ Title: "test", State: knownState, Position: player.api_getCurrentTime(), Duration: player.api_getDuration() });
    }
    
    function onPlayerStateChange(state) {
      var msg;
      
      if (state == -1) {
        msg = "LOADING";
      } else if (state == 0) {
        msg = "COMPLETED";
      } else if (state == 1) {
        msg = "PLAYING";
      } else if (state == 2) {
        msg = "PAUSED";
      } else if (state == 3) {
        msg = "BUFFERING";
      } else {
        msg = "Unknown state: " + state;
      }
      
      knownState = msg;  
      sendPlayerData({ State: msg, Position: player.api_getCurrentTime(), Duration: player.api_getDuration() });
    }
    
    function onFinish(){
        onPlayerStateChange(0);	
    }
    
    function onPlay(){
        onPlayerStateChange(1);	
    }
    
    function onPause(){
        onPlayerStateChange(2);	
    }
    
    function playerReady() {  
      try {
          player.api_setVolume(]] .. playxlib.volumeFloat(volume) .. [[);
          player.api_addEventListener('finish', 'onFinish');
          player.api_addEventListener('play', 'onPlay');
          player.api_addEventListener('pause', 'onPause');
          player.api_seekTo(]]..start..[[);
          setInterval(updateState, 250);
      } catch (e) {}
    }