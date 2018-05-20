/* 
1 is original 
2 is streched
3 is equalized
4 is region (Regional image starts as original
r is region hist
h is original hist
s is streched hist
e is equalized hist
*/
//Define arrays for red, green, and blue counts
int[] rCounts = new int[256];  //bins for red histogram
int[] gCounts = new int[256];  //bins for green histogram
int[] bCounts = new int[256];  //bins for blue histogram
float[] rCum = new float[256];
float[] bCum = new float[256];
float[] gCum = new float[256];
String fname = "lc.png";//"emptyroad.jpg";
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
  eimg = makeEqualized(img);
  simg = makeStretched(img);
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
        text(bCounts[(mouseX-posB)] + " # of pixels", 20, 20);
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

int findMin(){
  int min =255;
  for (int i=0; i <= 255; i++){
    if (i<min && rCounts[i]!=0) min = i;
    if (i<min && gCounts[i]!=0) min = i;
    if (i<min && bCounts[i]!=0) min = i;
  }
  return min;
}

float findMax() {
  int max=0;
   for (int i=0; i <= 255; i++){
    if (i>max && rCounts[i]!=0) max = i;
    if (i>max && gCounts[i]!=0) max = i;
    if (i>max && bCounts[i]!=0) max = i;
  }
  return max;
}

PImage makeEqualized(PImage img) {
  PImage newImg = createImage(img.width, img.height, RGB);
  rCum[0]=rCounts[0];
  bCum[0]=bCounts[0];
  gCum[0]=gCounts[0];
  for (int i=1; i<rCounts.length; i++) {
    rCum[i] = rCum[i-1] + rCounts[i];
    gCum[i] = gCum[i-1] + gCounts[i];
    bCum[i] = bCum[i-1] + bCounts[i];
  }
  for (int i=0; i<rCounts.length; i++) {
    rCum[i] = (rCum[i]/rCum[255])*255; 
    gCum[i] = (gCum[i]/gCum[255])*255; 
    bCum[i] = (bCum[i]/bCum[255])*255; 
  }
  for (int x=0; x<img.width; x++) {
    for (int y=0; y<img.height; y++) {
      color c = img.get(x,y);
      int r = int(red(c));
      int g = int(green(c));
      int b = int(blue(c));
      color nc = color(int(rCum[r]), int(gCum[g]), int(bCum[b]));
      newImg.set(x,y,nc);
    }
  }
  return newImg;
}

PImage makeStretched(PImage img) {
  //this is a function to create the new stretched image
  PImage newImg=createImage(img.width,img.height, RGB);
  int min = findMin();
  float max;
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {
      color p = img.get(x,y);
      int r = int(red(p))-min;
      int g = int(green(p))-min;
      int b = int(blue(p))-min;
      color nc = color(r,g,b);
      newImg.set(x,y,nc);
    }
  }
  calcHists(newImg);
  max = findMax();
  max = 255/max;  
  for (int y=0; y<newImg.height; y++) {
    for (int x=0; x<newImg.width; x++) {
      color p = newImg.get(x,y);
      int r = int(red(p)*max);
      int g = int(green(p)*max);
      int b = int(blue(p)*max);
      color nc = color(r,g,b);
      newImg.set(x,y,nc);
    }
  }
  return newImg;
}

PImage makeTestImage(int w, int h, color c) {
  //Make a test image of width w and height h and color c
  PImage target = createImage(w, h, RGB);  //First create a new image
  //Your code here to set all the pixel values to c (use a nested loop)
  for (int y=0; y<=h; y++){
    for (int x=0; x<=w; x++){
      target.set(x,y,c);
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
  rimg = makeStretched(rimg);
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
      