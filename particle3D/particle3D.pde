TextGraphics tg;
PVector root = new PVector(random(1234), random(1234), random(1234)), //noise root
nSpeed = new PVector(random(-.02, .02), random(-.02, .02), random(-.02, .02));//noise speed;
ArrayList<Particle> particles = new ArrayList<Particle>();
int nbParticle = 20000;
int[] pgpx;//PGraphics' pixels array
float zoom = 100;//noise zoom level
Boolean noiseOn = true, hitMode = true;
String fontName = "MicrosoftYaHeiLight-48";  //字体
color currentcolor=color(random(0,255),random(0,255),random(0,255));
ArrayList<String> words=new ArrayList<String>();
Boolean show3D=false;
int Index=0;
Boolean ShowImage=true;  //是否显示图片背景
PImage img;    //图像背景
int TextSize=100;


void setup()
{
  size(960, 640, P3D);
  words.add("Nothing");
  words.add("Is");
  words.add("Impossible");
  words.add("一切皆可能");
  tg = new TextGraphics();
  img=loadImage("mountain2.png");
  strokeWeight(2);
}

void draw()
{ 
  background(35);
  if(ShowImage==true)
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
  root.add(nSpeed);//更新噪音
  
  // 提示语句
  fill(0);
  PFont font = createFont(fontName,10);
  textFont(font);
  String tipText = "鼠标左键：切换特效语句";
  tipText +="\n鼠标滚轮：控制字体大小";
  tipText += "\n          N:  切换噪音";
  tipText += "\n          3:  切换3D";
  tipText +="\n          S: 保存图片";
  text(tipText, -480,200,0);
}

void createParticles()
{
  particles = new ArrayList<Particle>();
  //random particle disposition 
  while (particles.size () < nbParticle)
  {
    Particle p = new Particle(particles.size ());
    particles.add(p);
  }
}


//鼠标滚轮控制大小
void mouseWheel(MouseEvent event)
{
  float easing = 0.1;
  float e = -event.getCount();
  float TargertSize=TextSize+10*e;
  TextSize+=(TargertSize-TextSize)*easing;
  tg.process(words.get(Index));
}

//鼠标左键控制
void mousePressed()
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
  nSpeed = new PVector(random(-.02, .02), random(-.02, .02));//reset noise speed
}

void keyPressed()
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
    case 'n'://噪声切换
      noiseOn = !noiseOn;
      break;
    case 'h'://切换模式
      hitMode = !hitMode;
      if (!hitMode)
        for (Particle p : particles)
        {
          p.speed.mult(-1);
        }
      break;
    case '3'://是否装换为显示3D模式
      show3D=!show3D;
      break;
    case 's'://保存图片
      save("MyPic.jpg");
      break;
    default:
      break;
    }
  }
}