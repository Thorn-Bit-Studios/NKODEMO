import funkin.options.OptionsMenu;
import flixel.text.FlxTextBorderStyle as Border;
import funkin.menus.FreeplayState.FreeplaySonglist;
import funkin.editors.EditorPicker;
import funkin.menus.ModSwitchMenu;
import funkin.menus.credits.CreditsMain;
import flixel.addons.display.FlxGridOverlay as Grid; // im lazy.
import flixel.addons.display.FlxBackdrop;
import flixel.input.keyboard.FlxKey;
import funkin.editors.ui.UIState;
import lime.app.Application;

// Shared Variables
var p = "menus/menu/";
var buttons:Array<String> = ["Start Demo", "Options", "Credits", "Exit"];
var images = ["1", "2", "3"];
var imageSprites:Array<FunkinSprite> = [];
var logo:FunkinSprite;
var dumbarrow:FunkinSprite;
var buttonTexts:Array<FlxText> = [];
var curSelected:Int = 0;
var transitioning = false;
var holdOn = true;

function create() {
    CoolUtil.playMenuSong(false);

    var bg = new FunkinSprite(0, 0, Paths.image(p + "bg"));
    bg.scale.set(0.5, 0.5);
    bg.screenCenter();
    add(bg);

    var overlay = new FunkinSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
    overlay.alpha = 0.5;
    add(overlay);

    dumbarrow = new FunkinSprite(-640, 0, Paths.image(p + "dumbarrow"));
    dumbarrow.scale.set(0.5,0.5);
    dumbarrow.y = (FlxG.height - dumbarrow.height) / 2;
    dumbarrow.alpha = 0;
    add(dumbarrow);

    logo = new FunkinSprite(-400, -600, Paths.image(p + "logo"));
    logo.scale.set(0.25,0.25);
    add(logo);


    var spacing = 130;
    var totalWidth = (imageSprites.length - 1) * spacing;
    var startX = (FlxG.width / 2) - (totalWidth / 2);
    var buttonSpacing = 50;
    
    for (i in 0...images.length) {
        var img = new FunkinSprite(FlxG.width, 0, Paths.image(p + images[i]));
        img.scale.set(0.5, 0.5);
        img.updateHitbox();
        img.y = (FlxG.height - img.height) / 2;
        add(img);
        imageSprites.push(img);
    }

   versionText = new FunkinText(5, FlxG.height - 2, 0, ["NKO v1 Demo"].join('\n'));
	versionText.y -= versionText.height;
	versionText.scrollFactor.set();
	add(versionText);
    

    var buttonY = 200;
    for (button in buttons) {
        var btn = new FlxText(-500, buttonY, 0, button, 32);
        btn.setFormat(Paths.font("DIGIFIT.TTF"), 64, FlxColor.WHITE, "left", Border.SHADOW, FlxColor.BLACK);
        btn.borderSize = 4;
        btn.scrollFactor.set(0, 0);
        btn.alpha = 0;
        add(btn);
        buttonTexts.push(btn);
        buttonY += 100;
    }
    FlxTween.tween(logo, {y: -300}, 1.2, { ease: FlxEase.elasticOut, startDelay: 1.3 });
    FlxTween.tween(dumbarrow, {alpha: 1}, 1.2, {ease: FlxEase.expoInOut});
    for (i in 0...buttonTexts.length) {
        FlxTween.tween(buttonTexts[i], {x: buttonSpacing, alpha: 1}, 0.8, {ease: FlxEase.expoOut, startDelay: 0.3 + (i * 0.2)});
        buttonSpacing += 40;
    }
    for (i in 0...imageSprites.length) {
        var targetX = startX + (i * spacing);
        FlxTween.tween(imageSprites[i], {x: targetX}, 1.2, { ease: FlxEase.expoOut, startDelay: 0.5 + (i * 0.3) });
    }

   changeItem(0);
}

function update(elapsed:Float) {
    if (transitioning) return;

    logo.scale.set(FlxMath.lerp(logo.scale.x, 0.25, 0.1), FlxMath.lerp(logo.scale.y, 0.25, 0.1));
    logo.angle = FlxMath.lerp(logo.angle, 0, 0.1);

    var upP = controls.UP_P;
	var downP = controls.DOWN_P;
	var scroll = FlxG.mouse.wheel;
    if (upP || downP || scroll != 0) changeItem(upP ? -1 : downP ? 1 : -(scroll));

    if (controls.ACCEPT) {
        CoolUtil.playMenuSFX(1);
        transitioning = true;
        doTransition(() -> {
            switch (curSelected) {
               case 0: FlxG.switchState(new ModState("SongSelector")); transitioning = false;
               case 1: FlxG.sound.music.fadeOut(0.5, 0); FlxG.switchState(new OptionsMenu());
               case 2: FlxG.switchState(new CreditsMain());
               case 3: 
               if (FlxG.random.bool(6/10)) {
                  CoolUtil.playSound(Paths.sound("byebye"));
                  CoolUtil.openURL("https://www.youtube.com/watch?v=dQw4w9WgXcQ");
                  new FlxTimer().start(1, function(_) {
                     window.close();
                  });
               } else {
                  window.close();
               }
            }
        });
    }

	if (controls.SWITCHMOD) {
		openSubState(new ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}

   if (controls.DEV_ACCESS) {
      if (!Options.devMode) {
				FlxG.sound.play(Paths.sound(Flags.DEFAULT_EDITOR_DELETE_SOUND));
			} else {
            openSubState(new EditorPicker());
            persistentUpdate = false;
            persistentDraw = true;
         }
   }
    
	if (controls.BACK) {
		FlxG.switchState(new TitleState());
    }
}

function changeItem(ege) {
    CoolUtil.playMenuSFX(0);
    curSelected = FlxMath.wrap(curSelected + ege, 0, buttons.length - 1);

    for (i in 0...buttonTexts.length) {
        var btn = buttonTexts[i];
        var isSelected = (i == curSelected);
        var targetScale = isSelected ? 1.1 : 1.0;
        btn.color = i == curSelected ? 0xFFFBFF00 : 0xFFFFFFFF;

        if (btn.scale != targetScale)
            FlxTween.tween(btn.scale, {x: targetScale, y: targetScale}, 0.2, {ease: FlxEase.quadOut});

    }
}

function beatHit() {
    logo.scale.set(0.35, 0.3);
    logo.angle = (curBeat%2==0) ? -11 : 11;
}

function doTransition(callback:Void->Void) {
    FlxTween.tween(logo, {y: -200, alpha: 0}, 0.6, {ease: FlxEase.cubeIn});
    FlxTween.tween(dumbarrow, {alpha: 0}, 0.8, {ease: FlxEase.cubeIn});
    for (i in 0...buttonTexts.length) FlxTween.tween(buttonTexts[i], {x: FlxG.width + 300, alpha: 0}, 0.6, {ease: FlxEase.quadIn, startDelay: i * 0.05});
    new FlxTimer().start(1, callback);
}

function cleanup(obj:FlxObject) {
	if (obj != null) {
		remove(obj, true);
		obj.destroy();
	}
}