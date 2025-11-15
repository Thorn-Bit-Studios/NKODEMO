import funkin.game.PlayState;

// This is a heavily edited version of the original script from base Codename for Week 7 to support deathlines for multiple characters
// Modified script by SA64ds

var sound:Sound;
// Gets the full name of the opponent character
var charFullName = PlayState.instance.dad.curCharacter;
// incase the character is a variant of an existing character
var charName =PlayState.instance.dad.curCharacter.split('-')[0]; // gets the character name before any '-' in the name
var charVariant = (PlayState.instance.dad.curCharacter.split('-')[1] + "/");

if (charVariant == "null/") charVariant = ""; // if there is no variant, set it to nothing

// Creates two variables
var maxLines = PlayState.instance.dad.xml.get("maxLines"); // the max amount of death lines
var naughtyLines = PlayState.instance.dad.xml.get("naughtyLines"); // lines that should not be played when naughtyness is off

if (FlxG.save.data.consoleLog) {
   trace("Max Lines: " + maxLines);
   trace("Naughty Lines: " + naughtyLines);
}

var lineChosen:Int;

function create() {
	// Finds the sound file for the death line based on the character name and the random number generated, while excluding anything in the naughtyLines array if naughtyness is off

   lineChosen = FlxG.random.int(1, (maxLines), !Options.naughtyness ? naughtyLines : null);

	sound = Paths.sound('deathLines/' + charName + '/' + charVariant + charName + 'Death-' + lineChosen);
}
function stepHit(cur:Int) if (cur == 1) {
	if (PlayState.instance.dad.xml.get("maxLines") != null && FlxG.save.data.deathLinesEnabled) { // checks if the character has death lines and if death lines are enabled in options
      if (FlxG.save.data.consoleLog) {
         trace('Playing line ' + lineChosen + ' for ' + charFullName);
      }
		FlxG.sound.music.volume = 0.2;
		FlxG.sound.play(sound, 1, false, null, true, () -> if (!isEnding) FlxG.sound.music.fadeIn(4, 0.2, 1));
	} else {
      trace('No death lines found for ' + charName);
   }
}