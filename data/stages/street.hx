function update(elapsed) {
    if (car.x > 3000) {
      if if (FlxG.save.data.consoleLog) {
         trace("Resetting Car");
      }
		car.x = FlxG.random.int(-20000, -10000);
    }
}
