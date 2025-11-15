import lime.graphics.Image;
import flixel.FlxState;
import funkin.backend.MusicBeatState;
import funkin.backend.utils.NativeAPI;
import funkin.backend.utils.WindowUtils;
import funkin.backend.system.framerate.Framerate;
import hxvlc.util.Handle;
import haxe.io.Path;

import Type;
import Sys;

function new() {
    Handle.init([]);
    if (!Assets.exists(Paths.image('lore/themoreimportantfileever', null, false, 'png'))) {
        NativeAPI.showMessageBox('Error', 'File "../images/lore/themoreimportantfileever.png" is missing. The game will now close.');
        Sys.exit(0);
    } else {
        trace("All important files found. Continuing startup...");
    }

    // Default Mod Options
   FlxG.save.data.flashingLights ??= true;
   FlxG.save.data.deathLinesEnabled ??= true;
   FlxG.save.data.stickerOption ??= "perSong";
   FlxG.save.data.noteSkin ??= "psx";

   FlxG.save.data.spriteLog ??= false;
   FlxG.save.data.consoleLog ??= false;
   FlxG.save.data.miscLog ??= false;
}

function preStateSwitch() {
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('icon'))));
    WindowUtils.winTitle = window.title = "NKO";
    Framerate.codenameBuildField.text = "NKO v1 Demo";
}

function onModSwitch(newMod:String) {
	if (newMod != "NKO") {
	WindowUtils.title = title != null ? title : (Flags.WINDOW_TITLE_USE_MOD_NAME ? Flags.MOD_NAME : Flags.TITLE);
    Framerate.codenameBuildField.text = "Codename Engine v1.0.1";

    var iconPath = image != null ? image : Flags.MOD_ICON;
    if (Assets.exists(Paths.image(iconPath))) {
        window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image(iconPath))));
    }
	}
}