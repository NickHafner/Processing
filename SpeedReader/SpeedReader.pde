String fname = "gb.txt";
String[] lines;
float rate;
int i = 0;
String line;
boolean pause = false, done = false;
Slider slide = new Slider();

void setup() {
 lines = loadStrings(fname);
 textSize(14);
 size(600,400); 
}

void draw(){
  background(225,225,225);
  
  if (mousePressed && mouseY >299 && mouseY < 325){
    slide.move(mouseX);
  }
  slide.display();
  rate = slide.getWordRate();
  //println(rate);
  fill(0);
  if (!pause) {
    displayText(rate);
  }
  text("Slower", 70, 305);
  text("Faster", 520, 305);
  noFill();
  stroke(0);
  rect(310, 300, 380, 25);
}

void displayText(float rate){
  textSize(50);
  textAlign(CENTER);
  float t1 = 60000/rate;
  int wait = int(t1);
  String linesOfText = lines[0];
  String[] tokens = linesOfText.split(" ");
  delay(int(wait));
  if (i < tokens.length){
    text(tokens[i], 300, 150);
    i++;
  } else {
    done = true;
  }
  textSize(14);
  textAlign(LEFT);
}

void keyReleased() { 
  if (key == ' '){
    if (done) {
      lines = loadStrings(fname);
      i = 0;
      pause = false;
      
    }
    else { if (pause == false){
      noLoop();
      pause = true;
    }
    else {
      loop();
      pause = false;
    }
    }
  }
}