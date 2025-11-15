function update(elapsed) {
   if (controlsP1.getJustPressed("taunt")) {
       boyfriend.playAnim("hey", true, null);
   }
   if (controlsP2.getJustPressed("taunt")) {
       dad.playAnim("hey", true, null);
   }
}