/* 
    Nick Hafner
    CSC 545
    5/10/2018
   Test 2: Magnify a section of an image
   Control magnification level using the mouse wheel
   Control magnified region size using up and down arrows
*/
PImage img;
int regionSize = 200;
final int REGIONDEFAULT = 200;
final int REGIONDELTA = 10;  //Increment for changing regionSize
final int MINREGION = 50, MAXREGION = 300;
float magFactor = 2.0;
final float MAGDEFAULT = 2.0;
final float MAGDELTA = 0.1;  //Modification factor for changing magFactor
final float MAGMIN = 1.5, MAGMAX = 5.0;  //Range for magFactor
String[] fnames = {"us_texas-1839_small.jpg", "maps_future_small.jpg"};
void setup() {
  surface.setResizable(true);
  noTint();
  img = loadImage(fnames[0]);
  size(1442,911);
}
void draw() {
  imageMode(CORNER);
  image(img, 0,0);
  imageMode(CENTER);
  //image(img, 721,461);
  PImage target = img.get(mouseX-regionSize/2, mouseY-regionSize/2, regionSize, regionSize);
  image(target, mouseX, mouseY);
  int place = int(regionSize*magFactor);
  copy(target, 0, 0, regionSize, regionSize, mouseX-place/2,mouseY-place/2, place, place);  
}



void mouseWheel(MouseEvent event){
  float e = event.getCount();
  if (e < 0) {
    if (magFactor <= MAGMAX){
      magFactor += MAGDELTA;
    }
  } else {
   if (magFactor >= MAGMIN){
     magFactor -= MAGDELTA;
   }
  }
}

void keyReleased() {
  if (key == CODED) { 
    if (keyCode == UP){
      if (regionSize <= MAXREGION){
        regionSize += REGIONDELTA;
      }
    }
    else if (keyCode == DOWN) {
       if (regionSize >= MINREGION){
         
         regionSize -= REGIONDELTA;
       }
    }

  } else if (key == 'r') { 
  regionSize = 200;
  magFactor = 2.0;
  }
}