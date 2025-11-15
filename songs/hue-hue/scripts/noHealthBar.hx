function postCreate() {
    remove(healthBar);
    remove(healthBarBG);
    remove(iconP1);
    remove(iconP2);
}

function onPlayerHit(event) {
    PlayState.instance.health = 0.5;
}

function onPlayerMiss(event) {
    PlayState.instance.health = 0.5;
}