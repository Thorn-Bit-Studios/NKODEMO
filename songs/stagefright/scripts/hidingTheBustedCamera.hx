function postCreate() {
    overlay = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    overlay.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    overlay.screenCenter();
    add(overlay);
}

function onSongStart() {
    overlay.destroy();
}