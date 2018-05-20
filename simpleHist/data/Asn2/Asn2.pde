/* This program calculates red, green, and blue histograms.
   It prints values to the console - it does not graph the
   histograms.
*/
//Define arrays for red, green, and blue counts
int[] rCounts = new int[256];  //bins for red histogram
int[] gCounts = new int[256];  //bins for green histogram
int[] bCounts = new int[256];  //bins for blue histogram
int[] srCounts = new int[256];  //bins for red histogram
int[] sgCounts = new int[256];  //bins for green histogram
int[] sbCounts = new int[256];
int[] cumCounts = new int[256];
String fname = "charlton vale 3.jpg";
PImage img, rimg, eimg, simg, currentImg; //Original, equalized, stretched, current
boolean showHists = false;
int posR=10; int posG=275; int posB=541;
int startX,startY, endX, endY;


void setup() {
  size(400, 400);
  surface.setResizable(true);
  //First make a test image to debug your histograms
  //img = makeTestImage(10, 10, color(128));
  img = loadImage(fname);
  surface.setSize(img.width, img.height);
  rectMode(CORNERS);
  strokeWeight(1);
  currentImg = img;
  calcHists(img);
  color c = color(255);
  eimg=makeTestImage(500,500,c);
  simg = makeStretched(eimg);
  //eimg = makeEqualized(img);
  rimg=img;
}

void draw() {
  if (showHists){
    drawHists();
      if ((mouseX-posR) < rCounts.length && mouseX >= posR && mouseX < posG){
        text(rCounts[(mouseX-posR)] + " # of pixels", 20, 20);
      }
      if ((mouseX-posG) < gCounts.length && mouseX >= posG && mouseX < posB){
        text(gCounts[(mouseX-posG)] + " # of pixels", 20, 20);
      }
      if ((mouseX-posB) < bCounts.length && mouseX >= posB && mouseX < (posB+bCounts.length)){
        text("x: " + (mouseX-posB) + " y: " + bCounts[(mouseX-posB)], 20, 20);
      }
  }else{
    image(currentImg, 0, 0);
    noFill();
    if (mousePressed) {
      rect(startX, startY, mouseX, mouseY);
      //println(startX + ":" + mouseX);
    }
  }

  //println(mouseX);
}
void calcHists(PImage img) {
  //Calculate red, green, & blue histograms
  //First initialize rCounts, gCounts, and bCounts to all 0

  /*For each pixel, get the red, green, and blue values as ints.
    Increment the counts for the red, green, and blue values.
    For example, if the red value is 25, the green value is 110,
    and the blue value is 42, increment rCounts[25], gCounts[110],
    and bCounts[42].
  */
  for (int i=0; i <= 255; i++){
    rCounts[i]=0;
    gCounts[i]=0;
    bCounts[i]=0;
  }
  for (int y = 0; y<img.height; y++){
    for (int x=0; x<img.width; x++){
      color p = img.get(x,y);
      int r = int(red(p));
      int g = int(green(p));
      int b = int(blue(p));
      rCounts[r]+=1;
      gCounts[g]+=1;
      bCounts[b]+=1;
    }
  }
}

void printHists() {
  //Use a for (int i...) loop to println i, rCounts[i], gCounts[i], and bCounts[i]
  for (int i=0; i<rCounts.length; i++){
    println("Index " + i + ": Red count is " + rCounts[i] + " Green count is " + gCounts[i] + " Blue count is " + bCounts[i]);
  }
}

int findMin(int[] trCounts, int[] tgCounts, int[] tbCounts){
  int min =255;
  for (int i=0; i <= 255; i++){
    if (trCounts[i]>0 && i < min) min = i;
    if (tgCounts[i]>0 && i < min) min = i;
    if (tbCounts[i]>0 && i < min) min = i;
  }
  return min;
}

int findMax(int[] trCounts, int[] tgCounts, int[] tbCounts) {
  int max=0;
   for (int i=0; i <= 255; i++){
    if (trCounts[i]>0 && i > max) max = i;
    if (tgCounts[i]>0 && i > max) max = i;
    if (tbCounts[i]>0 && i > max) max = i;
  }
  return max;
}
PImage makeStretched(PImage img) {
  //this is a function to create the new stretched image
  PImage newImg=img;
  calcHists(img);
  int min = findMin(rCounts, gCounts, bCounts);
  int max = findMax(rCounts, gCounts, bCounts);
  calcStretch(min);
  int newMax = findMax(srCounts, sgCounts, sbCounts);
  println(rCounts[255], max, min, newMax);
  /*int contrast = max/newMax;
  
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {
      color p = img.get(x,y);
      int r = (int(red(p))-min)*contrast;
      int g = (int(green(p))-min)*contrast;
      int b = (int(blue(p))-min)*contrast;
      color np = color(r,g,b);
      newImg.set(x,y,np);
    }
  }*/
  
  return newImg;
}

void calcStretch(int min) {
  for (int i=min; i <= 255; i++){
    srCounts[i-min]=rCounts[i];
    sgCounts[i-min]=gCounts[i];
    sbCounts[i-min]=bCounts[i];
  }
  printHists();
}

PImage makeEqualized(PImage img) {
  PImage newImg=img;
  
  return newImg;
}

PImage makeTestImage(int w, int h, color c) {
  //Make a test image of width w and height h and color c
  PImage target = createImage(w, h, RGB);  //First create a new image
  //Your code here to set all the pixel values to c (use a nested loop)
  color test=color(120);
  for (int y=0; y<=h; y++){
    for (int x=0; x<=w; x++){
      if (y>50) test=color(50);
      target.set(x,y,test);
    }
  }   
  return target;  //Return the image
}

void makeRegionImage(int sw, int sh, int w, int h, PImage currImg) {
  rimg = createImage(w-sw,h-sh,RGB);
  for (int y=sh; y<=h; y++){
    for (int x=sw; x<=w; x++){
      color c = currImg.get(x,y);
      //color c = color(255,255,255);
      rimg.set(x-sw,y-sh,c);
    }
  }
  currentImg=rimg;
  surface.setSize(currentImg.width, currentImg.height);
}

void drawHists() {
  background(0);
  int maxval = 0;
  for (int i = 0; i < rCounts.length; i++) {
    if (maxval < rCounts[i]) maxval = rCounts[i];
    if (maxval < gCounts[i]) maxval = gCounts[i];
    if (maxval < bCounts[i]) maxval = bCounts[i];
  }

  //use map() to scale line values
  for (int i = 0; i < rCounts.length; i++) {
      stroke(255,0,0);
    int valr =  int(map(rCounts[i], 0, maxval, 0, height/2));
    line(i + posR, height, i+posR, height - valr);
      stroke(0,255,0);
    int valg =  int(map(gCounts[i], 0, maxval, 0, height/2));
    line(i + posG, height, i+posG, height - valg);
      stroke(0,0,255);
    int valb =  int(map(bCounts[i], 0, maxval, 0, height/2));
    line(i + posB, height, i+posB, height - valb);
  }
}

void mousePressed() {
  startX = mouseX;
  startY = mouseY;
}

void mouseReleased() {
  if (!showHists){
  if (mouseX < startX) {
    endX = startX;
    startX = mouseX;
  } else {
    endX = mouseX;
  }
  if (mouseY < startY) {
    endY = startY;
    startY = mouseY;
  } else {
    endY = mouseY;
  }
  rect(startX,startY,endX,endY);
  //println("End : "+ endX);
  makeRegionImage(startX, startY,endX,endY, currentImg);
  }
}

void keyReleased() {
  background(0);
  if (key == '1') {
    currentImg = img;
    showHists = false;
    surface.setSize(currentImg.width, currentImg.height);
  }
  if (key == '2') {
    currentImg = simg;
    showHists = false;
    surface.setSize(currentImg.width, currentImg.height);
  }
  if (key == '3') {
    currentImg = eimg;
    showHists = false;
    surface.setSize(currentImg.width, currentImg.height);
  }
  if (key == '4') {
    currentImg = rimg;
    showHists = false;
    surface.setSize(currentImg.width, currentImg.height);
  }
  
  if (key == 'h') {
    calcHists(img);
    showHists = true;
    surface.setSize(posB+bCounts.length, currentImg.height);
  }
  
  if (key == 's') {
    calcHists(simg);
    showHists = true;
    surface.setSize(posB+bCounts.length, currentImg.height);
  }
  
  if (key == 'e') {
    calcHists(eimg);
    showHists = true;
    surface.setSize(posB+bCounts.length, currentImg.height);
  }

  if (key == 'r') {
    calcHists(rimg);
    showHists = true;
    surface.setSize(posB+bCounts.length, currentImg.height);
  }
}
      