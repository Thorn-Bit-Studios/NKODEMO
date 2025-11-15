import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.text.FlxTextBorderStyle;
import funkin.savedata.FunkinSave;
import funkin.backend.chart.Chart;
import funkin.backend.utils.NativeAPI;
import funkin.editors.ui.UISubstateWindow;

import Sys;

var songs = FreeplaySonglist.get().songs;
var songPortraits:Array<FunkinSprite> = [];
var sticker:FunkinSprite;
var oppStickers:Array;
var songTable:Array<Dynamic> = [];
var difficulties = ["normal", "hard"];
var variations = ["normal"];
var p = "menus/songselect/";
var curSelected:Int = 0;
var diffIndex:Int = 0;
var varIndex:Int = 0;
var lerpScore = 0;
var scorings;
var intededScore = 0;
var e = false;
var chartPath;

var stickerX = 400;
var stickerY = 300;

static public var priorSelected:Int;
static public var priorDiff:Int;
static public var priorVar:Int;

static public var warnedAboutHard:Int;

function create() {

   for (index in [priorSelected, priorDiff, priorVar]) {
      if (index == null) {
         index = 0;
      }
   }

    CoolUtil.playMenuSong();
    add(bg = new FunkinSprite(0, 0, Paths.image(p+"bg")).screenCenter());
    add(notbg = new FunkinSprite(650, 280, Paths.image(p+"notbg")));
    add(difficulty = new FunkinSprite(640, 15, Paths.image(p+'difficulty')));
    add(score = new FunkinSprite(30, 530, Paths.image(p+'score')));
    for (s in songs) songTable.push(s);
    for (s => song in songTable) {
        var png = new FunkinSprite();
        png.makeGraphic(512, 512, FlxColor.TRANSPARENT);
        png.x = 50 + (200 * s);
        png.screenCenter(0x10);
        png.alpha = (s == 0 ? 1 : 0.6);
        png.scale.set((s == 0 ? 0.7 : 0.6), (s == 0 ? 0.7 : 0.6));
        add(png);
        songPortraits.push(png);
    }
    songTxt = new FlxText(700, 42, FlxG.width, "ege", 48).setFormat(Paths.font("DIGIFIT.TTF"), 28, FlxColor.WHITE, "left", FlxTextBorderStyle.SHADOW, FlxColor.BLACK);
    songScore = new FlxText(-440, 570, FlxG.width, "ege", 32).setFormat(Paths.font("DIGIFIT.TTF"), 32, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    songDiff = new FlxText(-440, 630, FlxG.width, "ege", 32).setFormat(Paths.font("DIGIFIT.TTF"), 32, FlxColor.WHITE, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    songVar = new FlxText(42, 42, FlxG.width, "ege", 32).setFormat(Paths.font("DIGIFIT.TTF"), 32, FlxColor.WHITE, "left", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    for (idk in [songTxt, songScore, songDiff]) {
        idk.borderSize = 2;
        add(idk);
    }

    sticker = new FunkinSprite(0, 0, Paths.image("transitionSwag/stickers-set-1/nateSticker3"));
    sticker.scale.set(0.8,0.8);
    sticker.updateHitbox();

    setSong();
    loadSticker();

    add(sticker);
}

function update() {
    sticker.angle = lerp(sticker.angle, 0, 0.1);
    sticker.scale.set(lerp(sticker.scale.x, 0.6, 0.1), lerp(sticker.scale.y, 0.6, 0.1));
}

function postUpdate() {
    if (!e) {
        if (controls.RIGHT_P || controls.LEFT_P) change(controls.LEFT_P ? -1 : 1);
        if (controls.UP_P || controls.DOWN_P) changeDiff(controls.UP_P ? -1 : 1);
        if (controls.BACK) {
            CoolUtil.playMenuSFX(2);
            FlxG.switchState(new MainMenuState());
            priorSelected = priorDiff = priorVar = 0;
        }
        if (controls.ACCEPT) {
            if (chartPlayable()) {
                e = true;
                CoolUtil.playMenuSFX(1);
                PlayState.loadSong(songTable[curSelected].name, difficulties[diffIndex], variations[varIndex] == "normal" ? null : variations[varIndex]);
                FlxG.camera.fade(FlxColor.BLACK, 1);
                FlxG.sound.music.fadeOut(1);
                FlxTween.tween(FlxG.camera, {zoom:1.5}, 1.5, {ease:FlxEase.cubeInOut, onComplete: () -> FlxG.switchState(new PlayState())});
                priorSelected = curSelected;
                priorDiff = diffIndex;
                priorVar = varIndex;
                if (FlxG.save.data.consoleLog) {
                    trace("priorSelected: " + priorSelected + ", priorDiff: " + priorDiff + ", priorVar: " + priorVar);
                    trace(FunkinSave.getSongHighscore(songTable[curSelected].name, difficulties[diffIndex], variations[varIndex] == "normal" ? null : variations[varIndex]));
                }
            } else {
                CoolUtil.playMenuSFX(2);
                for (e in [songDiff, songVar]) {
                    FlxTween.cancelTweensOf(e.scale);
                    e.scale.set(1.4, 1.4);
                    FlxTween.tween(e.scale, {x: 1, y: 1}, 0.4, {ease: FlxEase.elasticOut});
                    e.color = FlxColor.RED;
                    FlxTween.color(e, 0.4, FlxColor.RED, FlxColor.GRAY, {ease: FlxEase.sineInOut});
                }
            }
        }
    songPortraits[curSelected].scale.set(lerp(songPortraits[curSelected].scale.x, 0.7, 0.1), lerp(songPortraits[curSelected].scale.y, 0.7, 0.1));
    songPortraits[curSelected].angle = lerp(songPortraits[curSelected].angle, 0, 0.1);
    lerpScore = lerp(lerpScore, intededScore, 0.1);
    songScore.text = Std.string(Math.round(lerpScore));
    }
}

function startSong() {
    transitioning = true;
    CoolUtil.playMenuSFX(1);

    var song = songTable[curSelected];
    var diff = difficulties[diffIndex];
    var varName = (variations[varIndex] == "normal" ? null : variations[varIndex]);

    PlayState.loadSong(song.name, diff, varName);
    FlxG.camera.fade(FlxColor.BLACK, 1);
    FlxG.sound.music.fadeOut(1);
    FlxTween.tween(FlxG.camera, {zoom: 1.5}, 1.5, {ease: FlxEase.cubeInOut, onComplete: () -> FlxG.switchState(new PlayState())});

    priorSelected = curSelected;
    priorDiff = diffIndex;
    priorVar = varIndex;
}

function getVisibleIndices(cur:Int):Array<Int> return [FlxMath.wrap(cur - 1, 0, songPortraits.length - 1), cur, FlxMath.wrap(cur + 1, 0, songPortraits.length - 1)];

function beatHit(b) {
    sticker.angle = b%2==0 ? -6 : 6;
    sticker.scale.set(0.65, 0.65);
}

function change(c:Int) {
    CoolUtil.playMenuSFX(0);
    curSelected = FlxMath.wrap(curSelected + c, 0, songPortraits.length - 1);
    var visible = getVisibleIndices(curSelected);

    for (i in 0...songPortraits.length) {
        var spr = songPortraits[i];
        FlxTween.cancelTweensOf(spr);

        if (i == curSelected) {
            var song = songTable[i];
            spr.loadGraphic(Paths.getPath("songs/" + song.name + "/portrait.png"), true) ?? spr.makeGraphic(512, 512, FlxColor.GRAY);
            spr.screenCenter(0x10);
            spr.x = 200;
            FlxTween.tween(spr, {x: 50, alpha: 1, angle: 0}, 0.45, {ease: FlxEase.backOut});
            spr.scale.set(0.55, 0.55);
            FlxTween.tween(spr.scale, {x: 0.7, y: 0.7}, 0.35, {ease: FlxEase.elasticOut});
            var idx = members.indexOf(spr);
            if (idx != -1) {
                members.remove(spr);
                insert(members.length, spr);
            }
            var scorings = FunkinSave.getSongHighscore(songTable[curSelected].name, difficulties[diffIndex], variations[varIndex] == "normal" ? null : variations[varIndex]);
            songTxt.text = song.displayName + " by " + (song.customValues?.composer ?? "Unknown");
            intededScore = scorings.score;
        }
        else if (visible.contains(i)) {
            spr.loadGraphic(Paths.getPath("songs/" + songTable[i].name + "/portrait.png"), true) ?? spr.makeGraphic(512, 512, FlxColor.GRAY);
            spr.screenCenter(0x10);
            FlxTween.tween(spr, {x: 300, alpha: 0.4, angle: (c > 0 ? -5 : 5)}, 0.35, {ease: FlxEase.quadOut});
            spr.scale.set(0.5, 0.5);
            FlxTween.tween(spr.scale, {x: 0.6, y: 0.6}, 0.25, {ease: FlxEase.sineOut});
            var idx = members.indexOf(spr);
            if (idx != -1) {
                members.remove(spr);
                insert(members.length - 1, spr);
            }
        }
        else {
            FlxTween.tween(spr, {alpha: 0, angle: (c > 0 ? 15 : -15)}, 0.4, {ease: FlxEase.quadIn});
        }
    }

    for (e in [songDiff, songScore]) {
        if (chartPlayable() == true) {
            e.color = FlxColor.WHITE;
        } else {
            e.color = FlxColor.GRAY;
        }
    }

    updateColor();
    loadSticker();
}

function changeDiff(c:Int) {
    diffIndex = FlxMath.wrap(diffIndex + c, 0, difficulties.length - 1);
    songDiff.text = difficulties[diffIndex].toUpperCase();
    scorings = FunkinSave.getSongHighscore(songTable[curSelected].name, difficulties[diffIndex], variations[varIndex] == "normal" ? null : variations[varIndex]);
    intededScore = scorings.score;
    for (e in [songDiff, songScore]) {
        FlxTween.cancelTweensOf(e.scale);
        e.scale.set(1.4, 1.4);
        FlxTween.tween(e.scale, {x: 1, y: 1}, 0.4, {ease: FlxEase.elasticOut});
        e.color = FlxColor.YELLOW;
        if (chartPlayable() == true) {
            FlxTween.color(e, 0.4, FlxColor.YELLOW, FlxColor.WHITE, {ease: FlxEase.sineInOut});
        } else {
            FlxTween.color(e, 0.4, FlxColor.YELLOW, FlxColor.GRAY, {ease: FlxEase.sineInOut});
        }
    }
}

function updateColor() {
    priorColor = songTable[curSelected].color;
    for (e in [notbg, difficulty, score]) {
        FlxTween.color(e, 0.25, e.color, songTable[curSelected].color);
    }
}

function setSong() {
   if (FlxG.save.data.consoleLog) {
      trace("Song Number is " + priorSelected);
      trace("Diff Number is " + priorDiff);
      trace("Var Number is " + priorVar);
   }

   if (priorSelected == null) priorSelected = 0;
   curSelected = priorSelected;
   diffIndex = priorDiff;
   varIndex = priorVar;

   if (FlxG.save.data.consoleLog) {
      trace("Setting song to " + songTable[curSelected].name + " with difficulty " + difficulties[diffIndex] + " and variation " + variations[varIndex]);
   }

   change(0);
   changeDiff(0);
}

function chartExists() {
    if (variations[varIndex] == "normal") {
        chartPath = '../songs/'+songTable[curSelected].name+"/charts/"+difficulties[diffIndex];
    } else {
        chartPath = '../songs/'+songTable[curSelected].name+"/charts/"+variations[varIndex]+"/"+difficulties[diffIndex];
    }
    if (Assets.exists(Paths.json(chartPath))) {
        return true;
    } else {
        return false;
    }
}

function chartUnlocked() {
    if ((difficulties[diffIndex] == "hard") && FlxG.save.data.forceLocked) {
        return false;
    }

    var normalScore = FunkinSave.getSongHighscore(songTable[curSelected].name, difficulties[0], variations[varIndex] == "normal" ? null : variations[varIndex]);
    if (((difficulties[diffIndex] == "hard") && normalScore.score != 0) || (difficulties[diffIndex] == "normal")) {
        return true;
    } else {
        return false;
    }
}

function chartPlayable() {
   if (FlxG.save.data.miscLog) {
      trace("Chart Exists: "+ chartExists());
      trace("Chart Unlocked: "+ chartUnlocked());
   }


   if (chartExists() && chartUnlocked()) {
     return true;
   } else {
     return false;
   }
}

function loadSticker() {
   if (Assets.exists(Paths.json('../songs/'+songTable[curSelected].name+'/stickers'))) {
      var songStickers:Array = Json.parse(Assets.getText(Paths.json('../songs/'+songTable[curSelected].name+'/stickers')));
      var stickerNumber = FlxG.random.int(0, (songStickers.opponentStickers.length-1));
      if (FlxG.save.data.miscLog) {
         trace("Sticker json for " + songTable[curSelected].name + " loaded!");
         trace("Number selected: " + stickerNumber);
      }
      if (Assets.exists(Paths.image(songStickers.opponentStickers[stickerNumber], null, false, 'png'))) {
         sticker.loadGraphic(Paths.image(songStickers.opponentStickers[stickerNumber]));
         if (FlxG.save.data.miscLog) {
            trace("Updated sticker path to " + songStickers.opponentStickers[stickerNumber]);
         }
      }
        if (songStickers.stickerOffset != null) {
            if (FlxG.save.data.miscLog) {
               trace("Offset detected! X:" + songStickers.stickerOffset[0] + ", Y:" + songStickers.stickerOffset[1]);
            }
            sticker.x = (FlxG.width-stickerX) + (songStickers.stickerOffset[0]);
            sticker.y = (FlxG.height-stickerY) + (songStickers.stickerOffset[1]);
        } else {
            sticker.x = FlxG.width-stickerX;
            sticker.y = FlxG.height-stickerY;
        }
   }
}