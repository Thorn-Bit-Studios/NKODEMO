// Original script by BASHIR, edited by SA64ds to support the new Camera Movement parameters

function postCreate(){
   newstrLine = new StrumLine([dad,boyfriend]);
   strumLines.add(newstrLine);
   camHUD.alpha = 1;
}

function onEvent(e) {
if (e.event.name == 'Follow Both') {
      var params:Array = e.event.params;
      executeEvent({name: 'Camera Movement', params: [strumLines.members.length-1, (params[0]), (params[1]), (params[2])]});
   }
}