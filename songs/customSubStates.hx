function postCreate() {
   if (!PlayState.chartingMode) {
	   PauseSubstate.script = 'data/scripts/NKOPauseMenu';
   } else {
      PauseSubstate.script = 'data/scripts/vslicePause';
   }
	GameOverSubstate.script = 'data/scripts/deathLines';
}