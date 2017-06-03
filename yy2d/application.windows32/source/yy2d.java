import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class yy2d extends PApplet {

int fc, num = 5500;
ArrayList ballCollection; 
boolean save = false;
float scal, theta;
PGraphics letter;
PFont font;
String l = "HELLO"; 

public void setup() {
  background(20);
  
  letter = createGraphics(width, height);
  font = loadFont("Arial-Black-250.vlw");
  ballCollection = new ArrayList();
  createStuff();
  frameRate(30);//zhenlu
}

public void draw() {
  background(0);

  for (int i=0; i<ballCollection.size (); i++) {
    Ball mb = (Ball) ballCollection.get(i);
    mb.run();
  }  

  theta += .1f;

  if (save) {
    if (frameCount%1==0 && frameCount < fc + 30) saveFrame("image-####.gif");
  }
}

public void keyPressed() {
  if (key != CODED) l = str(key);
  createStuff();
}

public void mouseReleased() {
  //createStuff();
  //fc = frameCount;
  //save = true;
  //saveFrame("image-###.gif");
}

public void createStuff() {
  ballCollection.clear();
  
  letter.beginDraw();
  letter.noStroke();
  letter.background(255);
  letter.fill(0);
  letter.textFont(font,300);
  letter.textAlign(CENTER);
  letter.text(l, 600, 500);
  letter.endDraw();
  letter.loadPixels();

  for (int i=0; i<num; i++) {
    int x = (int)random(width);
    int y = (int)random(height);
    //color c = letter.get(x, y);
    int c = letter.pixels[x+y*width];
    if (brightness(c)<255) {
      PVector org = new PVector(x, y);
      float radius = random(5, 10);
      PVector loc = new PVector(org.x+radius, org.y);
      float offSet = random(TWO_PI);
      int dir = 1;
      float r = random(1);
      if (r>.5f) dir =-1;
      Ball myBall = new Ball(org, loc, radius, dir, offSet);
      ballCollection.add(myBall);
    }
  }
}
class Ball {

  PVector org, loc;
  float sz = 2;
  float radius, offSet, a;
  int s, dir, countC, d = 20;
  boolean[] connection = new boolean[num];

  Ball(PVector _org, PVector _loc, float _radius, int _dir, float _offSet) {
    org = _org;
    loc = _loc;
    radius = _radius;
    dir = _dir;
    offSet = _offSet;
  }

  public void run() {
    display();
    move();
    lineBetween();
  }

  public void move() {
    loc.x = org.x + sin(theta*dir+offSet)*radius;
    loc.y = org.y + cos(theta*dir+offSet)*radius;
  }

  public void lineBetween() {
    countC = 1;
    for (int i=0; i<ballCollection.size(); i++) {
      Ball other = (Ball) ballCollection.get(i);
      float distance = loc.dist(other.loc);
      if (distance >0 && distance < d) {
        a = map(countC,0,10,10,255);
        stroke(255, a);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
        connection[i] = true;
      } 
      else {
        connection[i] = false;
      }
    }
    for (int i=0; i<ballCollection.size(); i++) {
      if (connection[i]) countC++;
    }
  }

  public void display() {
    noStroke();
    fill(255, 200);
    ellipse(loc.x, loc.y, sz, sz);
  }
}
  public void settings() {  size(1200,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "yy2d" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
