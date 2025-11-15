// Skips the countdown with a black overlay

var overlay:FunkinSprite;

function postCreate() {
    overlay = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    overlay.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    overlay.screenCenter();
    add(overlay);
}

function onCountdown(event) {
    event.cancel();
}

function onSongStart() {
    overlay.destroy();
}