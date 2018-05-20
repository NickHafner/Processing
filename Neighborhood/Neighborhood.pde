/* 
Nick Hafner
545 Test 1
3/8/2018
Performs median filtering on an image
Programs fulfills all requirements
*/
String fname1 = "Test1_img1.png", fname2 = "Test1_img2.jpg", test="Before3x3.jpg";
String loadName = fname1;  //Use this to easily change loaded image
int regionSize = 3;
PImage[] img = new PImage[2];
int imgIndex;

void setup() {
  size(500, 500);
  surface.setResizable(true);
  //Load and display initial image
  img[0] = loadImage(loadName);
  img[1] = median(img[0]);
  surface.setSize(img[0].width, img[0].height);
  imgIndex = 0;
}
void draw() {
  image(img[imgIndex], 0, 0);
}
PImage median(PImage src) {
  PImage target = createImage(src.width, src.height, RGB);
  //Arrays to hold the pixel values
  int[] r = new int[regionSize*regionSize];
  int[] g = new int[regionSize*regionSize];
  int[] b = new int[regionSize*regionSize];
  int medianIndex = ceil(float(regionSize*regionSize)/2);
  for (int y = 0; y < src.height; y++){
    for (int x = 0; x < src.width; x++){
      int minusX = -(regionSize/2)-1;
      int minusY = -(regionSize/2);
      for (int i = 0; i < r.length; i++){
        if (i != 0 && (i%regionSize)==0) {
          minusY+=1;
          minusX=-(regionSize/2);
        }
        else {
          minusX+=1;
        }
        color c = src.get(x-minusX, y-minusY);
        int red = int(red(c)); 
        int green = int(green(c));
        int blue = int(blue(c));
        r[i] = red;
        g[i] = green;
        b[i] = blue;
      }
      r = sort(r);
      g = sort(g);
      b = sort(b);
      color nc = color(r[medianIndex],g[medianIndex],b[medianIndex]);
      target.set(x,y,nc);
      //Don't forget to return the filtered image
    }
  }
  return target;
}
void keyReleased() {
  //'1' displays original image; '2' displays filtered image
  if (key == '1') imgIndex = 0;
  else if (key ==  '2') imgIndex = 1;
}
      