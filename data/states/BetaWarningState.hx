var wipImage;
var p = "menus/disclaimer/";

function create() {
    titleAlphabet.x = 225;
    titleAlphabet.y = 0;
    
    disclaimer.text = "You are using an outdated version of Codename Engine! Please update to Codename v1.0.1 or higher!";
    disclaimer.size = 20;
    disclaimer.x = 25;
    disclaimer.y = 100;
    disclaimer.fieldWidth = 750;

    add(wipImage = new FunkinSprite(0, 0, Paths.image(p+"wipArt")).screenCenter());
    wipImage.x = wipImage.x+400;
    wipImage.scale.set(0.5, 0.5);
}