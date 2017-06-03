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

public class particle3D extends PApplet {

TextGraphics tg;
PVector root = new PVector(random(1234), random(1234), random(1234)), //noise root
nSpeed = new PVector(random(-.02f, .02f), random(-.02f, .02f), random(-.02f, .02f));//noise speed;
ArrayList<Particle> particles = new ArrayList<Particle>();
int nbParticle = 20000;
int[] pgpx;//PGraphics' pixels array
float zoom = 100;//noise zoom level
Boolean noiseOn = true, hitMode = true;
String fontName = "MicrosoftYaHeiLight-48";  //\u5b57\u4f53
int currentcolor=color(random(0,255),random(0,255),random(0,255));
ArrayList<String> words=new ArrayList<String>();
Boolean show3D=false;
int Index=0;
PImage img;    //\u56fe\u50cf\u80cc\u666f


public void setup()
{
  
  words.add("Nothing");
  words.add("Is");
  words.add("Impossible");
  words.add("\u4e00\u5207\u7686\u53ef\u80fd");
  tg = new TextGraphics();
  img=loadImage("mountain.png");
  strokeWeight(2);
}

public void draw()
{ 
  background(35);
  image(img,0,0,width,height);
  lights();
  translate(width/2, height/2);
  if(show3D==true)
  {
    rotateY(map(mouseX, 0, width, -PI, PI));
    rotateX(map(mouseY, 0, height, PI, -PI));
  }


  for (int i = 0; i < nbParticle; i++)
  {
    Particle p = particles.get(i);
    p.update();
  }
  root.add(nSpeed);//\u66f4\u65b0\u566a\u97f3
  // \u63d0\u793a\u8bed\u53e5
  PFont font = createFont(fontName,9);
  textFont(font);
  String tipText = "n   :\u5207\u6362\u566a\u97f3";
  tipText += "\n3    :\u5207\u63623D";
  tipText += "\n\u9f20\u6807\u5de6\u952e:\u6362\u4e0b\u4e00\u53e5";
  text(tipText,10, height-40); 
}

public void createParticles()
{
  particles = new ArrayList<Particle>();
  //random particle disposition 
  while (particles.size () < nbParticle)
  {
    Particle p = new Particle(particles.size ());
    particles.add(p);
  }
}

public void mousePressed()
{
  if(mouseButton==LEFT)
  {
    Index+=1;
    if(Index>words.size()-1)
      Index=0;
    currentcolor=color(random(0,255),random(0,255),random(0,255));
    tg.process(words.get(Index));
  }
  root = new PVector(random(1234), random(1234));//reset noise root
  nSpeed = new PVector(random(-.02f, .02f), random(-.02f, .02f));//reset noise speed
}

public void keyPressed()
{
  if (key == CODED && (keyCode == LEFT || keyCode == RIGHT))
  {
    zoom += (keyCode == LEFT ? 1 : -1) * 80;//modify Perlin zoom
    zoom = constrain(zoom, 30, 400);
  } 
  else if (key != CODED)
  {
    switch(key)
    {
    case 'n'://\u566a\u58f0\u5207\u6362
      noiseOn = !noiseOn;
      break;
    case 'h'://\u5207\u6362\u6a21\u5f0f
      hitMode = !hitMode;
      if (!hitMode)
        for (Particle p : particles)
        {
          p.speed.mult(-1);
        }
      break;
    case '3'://\u662f\u5426\u88c5\u6362\u4e3a\u663e\u793a3D\u6a21\u5f0f
      show3D=!show3D;
      break;
    case 's'://\u4fdd\u5b58\u56fe\u7247
      save("MyPic.jpg");
      break;
    default:
      break;
    }
  }
}
class Particle
{
  final float SPEED_MIN = .12f, SPEED_MAX = .25f, h = 40;
  PVector pos, origin, speed;
  int rank, col = color(random(128, 255), random(128, 205), 90, 120);
  float n, nz;//noise
  Boolean stuck = false;//against a wall

  Particle(int p_rank)
  {
    rank = p_rank;
    init();
  }

  public void init()
  {
    stuck = false;
    float theta = random(TWO_PI);
    speed = new PVector(cos(theta), sin(theta), -cos(theta));
    speed.mult(random(SPEED_MIN, SPEED_MAX) * (random(1)<0?1:-1));
    Boolean done = false;
    while (!done)
    {
      pos = new PVector(random(width), random(height));
      if (green(pgpx[(int)pos.y * width + (int)pos.x]) > 100)
      {
        pos.z = random(-h/2, h/2);
        origin = pos.get();
        done = true;
      }
    }
  }

  public void update()
  {
    if (noiseOn && !stuck)
    {
      n = noise(root.x + pos.x/zoom, root.y + pos.y/zoom, root.z + pos.z/zoom)*2*TWO_PI;
      nz = noise(root.x/10 + pos.x/zoom, root.y + pos.y/zoom, root.z + pos.z/zoom)*2*TWO_PI;
      speed.set(cos(n), sin(n), -cos(nz));
      speed.mult(SPEED_MAX);
    }

    if (!(stuck && hitMode))
      pos.add(speed);

    if (green(pgpx[(int)pos.y * width + (int)pos.x]) < 100)//particle outside the letter
    {
      stuck = hitMode;
      pos.sub(speed);
      if (!hitMode)
      {
        if (noiseOn)
        { 
          pos = origin.get();
        } else
        {      
          speed.x *= -1;
          speed.y *= -1;
        }
      }
    }
    if (pos.z > h/2 || pos.z < -h/2)
    {
      stuck = hitMode;
      pos.z = constrain(pos.z, -h/2, h/2);
      if (!hitMode)
      {
        if (noiseOn)
        {
          pos = origin.get();
        } else
        {
          speed.z *= -1;
        }
      }
    }
    
    //stroke(map(pos.z, -h/2, h/2, 128, 255), map(pos.z, -h/2, h/2, 128, 205), 90, 120);
    stroke(currentcolor);
    point(pos.x-width/2, pos.y-height/2, pos.z);
  }
}
class TextGraphics
{  
  PGraphics pg;//buffer PG used to write the input char

  TextGraphics()
  {
    pg = createGraphics(width, height, P2D);
    process(new String("Nothing"));//"\u00cf\ufffd")//initialize with a String
    //process(words.get(1));
  }

  public void process(String c)
  {
    pg.beginDraw();
    pg.translate(-width/2, -height/1.7f);
    pg.background(0);
    pg.textSize(250);//500
    pg.fill(color(0, 255, 0));
    pg.textAlign(CENTER, CENTER);
    PFont font = createFont(fontName,200);
    pg.textFont(font);
    pg.text(c, width, height);
    pg.translate(width/2, height/1.7f);
    pg.endDraw();

    pgpx = new int[width * height];
    pg.loadPixels();
    arrayCopy(pg.pixels, pgpx);
    pg.updatePixels();

    createParticles();
  }
}
  public void settings() {  size(960, 640, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "particle3D" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
