function onEvent(e) {
   if (e.event.name == 'Change HUD Alpha') {
      var params:Array = e.event.params;
      if params[0] == true {
         
      } else {
         camHUD.alpha = params[1];
      }
   }
}