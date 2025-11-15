import Reflect;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import funkin.backend.system.Conductor;

var camera:FlxCamera;

function onEvent(e) {
    if (e.event.name == "Camera Flash") {
      var params:Array = e.event.params;

      if (FlxG.save.data.flashingLights) {
         camera = (params[3] == 'camHUD' ? camHUD : camGame);
         if (params[0]) {
            camera.fade(params[1], (Conductor.stepCrochet / 1000) * params[2], false, () -> {camera._fxFadeAlpha = 0;}, true);
         } else {
            camera.flash(params[1], (Conductor.stepCrochet / 1000) * params[2], null, true);
         }
      }
    }
}