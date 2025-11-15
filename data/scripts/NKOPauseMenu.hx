import funkin.ui.FunkinText;
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxAxes;

import funkin.editors.charter.Charter;
import funkin.menus.StoryMenuState;
import funkin.options.OptionsMenu;
import funkin.options.keybinds.KeybindsOptions;


// Backend
var dumbarrow:FunkinSprite;
var curSelected:Int = 0;
var pauseButtonTexts:Array<FlxText> = [];

// Song Info
var levelInfo:FunkinText;
var levelDifficulty:FunkinText;

var pauseMusic:FlxSound;

var pauseCam = new FlxCamera();
var p:String = "menus/menu/";
var buttonSpacing:Float = 100;

function create(event) {
    // cancel default pause menu!!
   event.cancel();
   event.music = "breakfast";

   cameras = [];

   FlxG.cameras.add(pauseCam, false);

   pauseCam.bgColor = 0x55000000;
   pauseCam.alpha = 1;

	levelInfo = new FunkinText(20, 15, 0, PlayState.SONG.meta.displayName, 16, false);
	levelDifficulty = new FunkinText(20, 15, 0, PlayState.difficulty.toUpperCase(), 16, false);

	levelInfo.text = PlayState.SONG.meta.displayName + " by " + PlayState.SONG.meta.customValues?.composer;
	levelDifficulty.text = PlayState.difficulty.toUpperCase() + " (Charted by " + (PlayState.difficulty=="hard" && PlayState.SONG.meta.customValues?.charterHard != null ? PlayState.SONG.meta.customValues?.charterHard : PlayState.SONG.meta.customValues?.charter) + ")";

   for(k=>label in [levelInfo, levelDifficulty]) {
		if(label == null) continue;
		label.scrollFactor.set();
		label.alpha = 0;
		label.x = FlxG.width - 620;
		label.y = 15 + (32 * k);
    	formatMenuText(label);
		FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k+1)});
		add(label);
	}

   dumbarrow = new FunkinSprite(-640, 0, Paths.image(p + "dumbarrow"));
   dumbarrow.scale.set(0.5,0.5);
   dumbarrow.scrollFactor.set(0, 0);
   dumbarrow.y = (FlxG.height - dumbarrow.height) / 2;
   dumbarrow.alpha = 0;
   dumbarrow.color = PlayState.SONG.meta.color;
   add(dumbarrow);
   FlxTween.tween(dumbarrow, {alpha: 1}, 1.2, {ease: FlxEase.expoInOut});

	var pauseButtonY = 100;
   for (button in menuItems) {
      var btn = new FlxText(0, pauseButtonY, 0, button, 32);
      btn.setFormat(Paths.font("DIGIFIT.TTF"), 64, FlxColor.WHITE, "left", FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
      btn.borderSize = 4;
      btn.scrollFactor.set(0, 0);
      btn.alpha = 0;
      add(btn);
      pauseButtonTexts.push(btn);
      pauseButtonY += 100;
   }
   
    for (i in 0...pauseButtonTexts.length) {
      FlxTween.tween(pauseButtonTexts[i], {x: buttonSpacing, alpha: 1}, 0.8, {ease: FlxEase.expoOut, startDelay: 0.3 + (i * 0.2)});
      buttonSpacing += 50;
   }

   cameras = [pauseCam];

   changeSelection(0);
}

function update(elapsed:Float) {
	var upP = controls.UP_P;
	var downP = controls.DOWN_P;
	var scroll = FlxG.mouse.wheel;
	if (upP || downP || scroll != 0) {
		changeSelection(upP ? -1 : downP ? 1 : -(scroll));
	}

	if (controls.ACCEPT) {
		selectOption();
	}
}

function changeSelection(change) {
    CoolUtil.playMenuSFX(0);
    curSelected += change;
    if (curSelected < 0) {
		curSelected = menuItems.length - 1;
    } else if (curSelected >= menuItems.length) {
		curSelected = 0;
    }

    for (i in 0...pauseButtonTexts.length) {
        var btn = pauseButtonTexts[i];
        var isSelected = (i == curSelected);
        var targetScale = isSelected ? 1.1 : 1.0;
        btn.color = i == curSelected ? 0xFFFBFF00 : 0xFFFFFFFF;

        if (btn.scale != targetScale)
            FlxTween.tween(btn.scale, {x: targetScale, y: targetScale}, 0.2, {ease: FlxEase.quadOut});

    }
}

function formatMenuText(text) {
   text.font = Paths.font("SMB3.TTF");
   text.autoSize = false;
   text.fieldWidth = 600;
   text.alignment = "right";
   text.borderStyle = FlxTextBorderStyle.OUTLINE;
   text.borderColor = 0xFF000000;
}

function destroy() {
	if(FlxG.cameras.list.contains(pauseCam)) {
		FlxG.cameras.remove(pauseCam);
   }
}

function selectOption() {
		switch (menuItems[curSelected])
		{
			case "Resume":
				close();
			case "Restart Song":
				parentDisabler.reset();
				game.registerSmoothTransition();
				FlxG.resetState();
			case "Change Controls":
				persistentDraw = false;
				openSubState(new KeybindsOptions());
			case "Change Options":
				FlxG.switchState(new OptionsMenu((_) -> FlxG.switchState(new PlayState())));
			case "Exit to charter":
				FlxG.switchState(new Charter(PlayState.SONG.meta.name, PlayState.difficulty, PlayState.variation, false));
			case "Exit to menu":
				if (PlayState.chartingMode && Charter.undos.unsaved)
					game.saveWarn(false);
				else {
					if (Charter.instance != null) Charter.instance.__clearStatics();

					// prevents certain notes to disappear early when exiting  - Nex
					game.strumLines.forEachAlive(function(grp) grp.notes.__forcedSongPos = Conductor.songPosition);

					CoolUtil.playMenuSong();
					FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
				}

		}
	}