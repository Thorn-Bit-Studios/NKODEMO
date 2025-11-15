// Plays the options music instead of the menu music
function create() {
    trace("Switched to Options Music!");
    CoolUtil.playMusic(Paths.music("optionsMenu"), false, 1, true, 130);
}