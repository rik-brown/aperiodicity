// Aperiodicity by Richatrd Brown (c)
// 2017-12-02 Exploring aperiodicity when drawing elements in a cartesian grid

import com.hamoid.*;

VideoExport videoExport;

int period = 1; // Unit length for one modulo cycle
float A = 600; // Periodic multiplier A
float B = 400; // Periodic multiplier B
float C = 1200; // Periodic multiplier C

float ra = 20;
float rb = 20;
float rc = 20;
float offsetA = 0;
float offsetB = 0.5;
float offsetC = 0;

int columns, rows;
float colOffset, rowOffset;
color bkgCol, fillCol, strokeCol, fillCol2;

void setup() {
  colorMode(HSB,360,255,255,100);
  size(1000,1000);
  bkgCol = color(180, 0, 0);
  fillCol = color(0, 255, 255, 100);
  strokeCol = color(0, 0, 1, 32);
  background(bkgCol);
  fill(fillCol);
  stroke(strokeCol);
  noStroke();
  //frameRate(10);
  ellipseMode(RADIUS);
  columns = 37;
  //rows = 9;
  rows = columns;
  colOffset = width/(columns*2);
  rowOffset = height/(rows*2);
  ra = colOffset;
  rb = rowOffset;
  videoExport = new VideoExport(this, "../videoExport/aperiodicity_006.mp4"); //WARNING! The destination folder must exist already!
  videoExport.setQuality(75, 128);
  videoExport.setFrameRate(30);
  videoExport.setDebugging(false);
  videoExport.startMovie();

}

void draw() {
  background(bkgCol);
  float modulo_A = (frameCount-1) % A; //Varies in range 0 - ((period * A)-1)
  float modulo_B = (frameCount-1) % B; //Varies in range 0 - ((period * B)-1)
  float modulo_C = (frameCount-1) % C; //Varies in range 0 - ((period * C)-1)
  float exitCondition = frameCount % C;
  //println (frameCount, "     ", modulo_A, "    ", modulo_B, "     ", modulo_C);
  float angleA = map(modulo_A, 0, A-1, 0, TWO_PI);
  float angleB = map(modulo_B, 0, B-1, 0, TWO_PI);
  float angleC = map(modulo_C, 0, C-1, 0, TWO_PI);
  for(int col = 0; col<columns; col++) {
    for(int row = 0; row<rows; row++) {
      float x = map (col, 0, columns, 0, width) + colOffset;
      float y = map (row, 0, rows, 0, height) + rowOffset;
      float xOffsetAngle = map (x, 0, width, 0, TWO_PI);
      float yOffsetAngle = map (y, 0, height, 0, TWO_PI);
      float xa = map(sin(angleA + xOffsetAngle), -1, 1, ra*0.25, ra);
      float ya = map(cos(angleA + yOffsetAngle), -1, 1, ra, ra*0.25);
      float xb = map(sin(angleB + xOffsetAngle), -1, 1, rb*0.25, rb);
      float yb = map(cos(angleB + yOffsetAngle), -1, 1, rb, rb*0.25);
      float xc = map(sin(angleC + xOffsetAngle), -1, 1, -rc, rc);
      float yc = map(cos(angleC + yOffsetAngle), -1, 1, -rc, rc);
      pushMatrix();
      //fillCol = color(degrees(angleC + xOffsetAngle + yOffsetAngle)%360, 255, 255, 100);
      fillCol = color(240, map(yc, -rc, rc, 128, 255), map(xc, -rc, rc, 128, 255), 100);
      fill(fillCol);
      translate(x, y);
      rotate(angleC + xOffsetAngle + yOffsetAngle);
      ellipse(0, 0, xa, yb);
      //noStroke();
      //triangle(0, -ry, (rx*0.866), (ry*0.5) ,-(rx*0.866), (ry*0.5));
      //rect(0, 0, rx, ry);
      //ellipse(0, 0, ry*0.5, ry*0.5);
      popMatrix();
    }
  }
  videoExport.saveFrame();
  println (exitCondition);
  if (exitCondition==0) {
    videoExport.endMovie();
    exit();
  }
}