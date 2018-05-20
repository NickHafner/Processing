class Slider {
 int sliderL = 25, sliderW = 2;
 int xpos, ypos;
 float wordSpeed;
 color fillColor;
 
 Slider() {
   fillColor = color(255, 0, 0);
   ypos = 300;
   xpos = 200;
 }
 
 void move(int x) {
   if (x >= 120 && x <= 500){
     xpos = x;
   }
 }
 
 void calcWordSpeed() {
     wordSpeed = xpos;
 }
 
 float getWordRate(){
   float rate = wordSpeed;
   return rate;
 }
 
 void display(){
   fill(fillColor);
   noStroke();
   rectMode(CENTER);
   rect(xpos, ypos, sliderW, sliderL);
   textAlign(CENTER);
   textSize(10);
   fill(0);
   text(int(wordSpeed), xpos, ypos+1);
   textAlign(LEFT);
   textSize(14);
   calcWordSpeed();
   if (wordSpeed >= 400){
     fill(255,0,0);
   }else if (wordSpeed < 200) {
     fill(0,255,0);
   }else {
     fill(0,0,255);
   }
   text("WPM:  " + int(wordSpeed), 25, 375);
 }
 
}