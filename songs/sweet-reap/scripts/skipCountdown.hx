introLength = 0;
var overlay:FunkinSprite;

function postCreate() {
    overlay = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    overlay.cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    overlay.screenCenter();
    add(overlay);
}
var swagCounter:Int = 0;
function stepHit(s) {
    if (s == 108) {
        new FlxTimer().start(Conductor.crochet / 1000, () -> {
            countdown(swagCounter++);
        }, 5);
    }
}

function onSongStart() overlay.destroy();