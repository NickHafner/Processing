import processing.video.*;
String vidname = "Ready-Player-One.mp4"; //640 x 272
String subs = "Ready-Player-One-Trailer-HD-English-French-Subtitles.srt";
Movie m;
boolean paused = false, reversed = false;
float playSpeed = 1.0;
Subs sp;
int counter = 0; //Which time we are in

void setup() {
  size(640, 372);
  frameRate(30);
  textSize(16);
  m = new Movie(this, vidname);
  m.play();
  sp = new Subs(subs);  
}

void draw() {
  background(0);
  image(m, 0, 0);
  //This is to keep track of which index currently needs to be played
  if (!reversed){
    if (m.time() <= sp.endArr.get(counter)/1000.0){
      
    } else {
      if (counter < 36){
        counter++;
      }
    }
  } else {
    if (m.time() >= sp.startArr.get(counter)/1000.0){
      
    } else {
      if (counter > 0){
        counter--;
      }
    }
  }
  text(sp.subArr.get(counter), 10, 325);
  text("Speed: " + playSpeed, 520, 355);
}

void movieEvent(Movie m) {
 m.read(); 
}

void mouseWheel(MouseEvent event){
  //Spamming mouse wheel events cause lag in video and subs
  //Only while playing the video not in reverse
  float e = event.getCount();
  if (!reversed){
    if (e > 0) {
      if (playSpeed > 0.1){
        playSpeed =  playSpeed - .1;
      }
    } else {
      if (playSpeed < 2.0){
        playSpeed = playSpeed + .1;
      }
    }
    m.speed(playSpeed);
  }
}

void checkReverse(){
  //checks whether the video is playing in reverse
    if (playSpeed >= 0) {
      reversed = false;
     } else {
      reversed = true;
    }
}

void keyReleased() {
  if (key == ' ') { //toggle pause
    if (paused){
      paused =false;
      m.play();
    } else {
      paused = true;
      m.pause();
    }
  } else if (key == 'r') { //toggle reverse
  //Reverse swaps the speed currently at to go in reverse at the same speed
    if (playSpeed > 0) {
      playSpeed = -playSpeed;
      m.speed(playSpeed);
    } else {
      playSpeed = -playSpeed;
      m.speed(playSpeed);
    }
    checkReverse();
  }
}
