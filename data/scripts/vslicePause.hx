import flixel.util.FlxStringUtil;

var artistChartInfo:FunkinText;

function create() {
   if (FlxG.save.data.consoleLog) {
      trace(PlayState.SONG.meta.customValues?.charter);
      trace(PlayState.SONG.meta.customValues?.charterHard);
   }
}

function postCreate() {
    for(label in [levelInfo, levelDifficulty, deathCounter, multiplayerText]) {
        if(label == null) continue;
        FlxTween.cancelTweensOf(label);
    }
    
    //TODO: add translations
    artistChartInfo = new FunkinText(20, 15, 0, "Composer: " + (PlayState.SONG.meta.customValues?.composer ?? "Unknown (change in the metadata)"), 32, false);
    levelDifficulty.text = "Difficulty: " + FlxStringUtil.toTitleCase(PlayState.difficulty);
    deathCounter.text = PlayState.deathCounter + " Blue Balls";

	for(k=>label in [levelInfo, artistChartInfo, levelDifficulty, deathCounter, multiplayerText]) {
		if(label == null) continue;
		label.scrollFactor.set();
		label.alpha = 0;
		label.x = FlxG.width - (label.width + 20);
		label.y = 15 + (32 * k);
		FlxTween.tween(label, {alpha: 1, y: label.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3 * (k+1)});
		add(label);
	}

  startFadeTimer();
}

var CHARTER_FADE_DELAY:Float = 15.0;
var CHARTER_FADE_DURATION:Float = 0.75;

var charterFadeTween:Null<FlxTween> = null;

var switchToCharter:Bool = true;

function startFadeTimer(){
    charterFadeTween = FlxTween.tween(artistChartInfo, {alpha: 0.0}, CHARTER_FADE_DURATION,
      {
        startDelay: CHARTER_FADE_DELAY,
        ease: FlxEase.quartOut,
        onComplete: (_) -> {
          if (PlayState.difficulty == "normal" || PlayState.SONG.meta.customValues?.charterHard == null) {
            artistChartInfo.text = switchToCharter ? "Charter (Normal): " + (PlayState.SONG.meta.customValues?.charter ?? "Unknown (change in the metadata)") : "Composer: " + PlayState.SONG.meta.customValues?.composer;
          } else if (PlayState.difficulty == "hard") {
            artistChartInfo.text = switchToCharter ? "Charter (Hard): " + PlayState.SONG.meta.customValues?.charterHard : "Composer: " + PlayState.SONG.meta.customValues?.composer;
          }
            artistChartInfo.x = FlxG.width - (artistChartInfo.width + 20);
            switchToCharter = !switchToCharter;

            FlxTween.tween(artistChartInfo, {alpha: 1.0}, CHARTER_FADE_DURATION,
            {
              ease: FlxEase.quartOut,
              onComplete: startFadeTimer
            });
        }
      }
    );
}