//Changes window title to include the current song name, as well as it's composer.

import funkin.backend.utils.WindowUtils;

function create() {
   WindowUtils.winTitle = window.title = PlayState.SONG.meta.customValues?.composer + " - " + PlayState.SONG.meta.displayName + " | NKO";
}

function destroy() {
   WindowUtils.winTitle = window.title = "NKO";
}