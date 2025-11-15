var wipImage;
var p = "menus/disclaimer/";

function create() {
    titleAlphabet.x = 155;
    titleAlphabet.y = 0;
    titleAlphabet.text = "disclaimer";
    
    disclaimer.text = "What you are about to play is a #demo version of NKO#. That means everything you see in this version is *not respresentative of what the final mod will look like*.\n
    \nYou must be using #Codename Engine v1.0.1 or higher# to play this demo. *We can not help you if you are using an older version of the engine.* If a future update does break something in this demo, let us know and we will try to look into it.\n
    \nThe mod features *Screen Flashes* in many of the songs, which can be disabled using the #Flashing Lights# setting in the Options.\n
    \nThe two base game mixes in this demo are *not a part of NKO* and *will not be in the final mod*. They were originally going to be part of a base game mix mod starring Nate. However, they are instead going to be used for a slightly different project. Hope you look forward to that!\n
    \nWith all that out of the way, #hope you enjoy what we put together#!\n
    \n#Press ENTER to continue!#";
    disclaimer.size = 20;
    disclaimer.x = 25;
    disclaimer.y = 100;
    disclaimer.fieldWidth = 750;

    add(wipImage = new FunkinSprite(0, 0, Paths.image(p+"wipArt")).screenCenter());
    wipImage.x = wipImage.x+400;
    wipImage.scale.set(0.5, 0.5);
}

CoolUtil.playMusic(Paths.music("optionsMenu"), false, 1, true, 130);