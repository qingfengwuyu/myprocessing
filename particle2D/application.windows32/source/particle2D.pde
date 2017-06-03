//全局变量
ArrayList<Particle> particles = new ArrayList<Particle>();  
int pixelSteps = 3; // 控制粒子间的间隔
boolean drawAsPoints = false;
ArrayList<String> words = new ArrayList<String>();  //显示的string动态数组
int wordIndex = 0;
color bgColor = color(255, 100);
String fontName = "MicrosoftYaHeiLight-48";  //字体
PFont tipfont; //提示字体
int ImgIndex=0,ImgMax=5;
PImage TmpImg;
ArrayList<PImage> img = new ArrayList<PImage>();     //图像背景


void setup() {
  frameRate(4000);
  size(1000, 600);
  background(255);
  TmpImg=loadImage("mountain2.png");
  img.add(TmpImg);
  TmpImg=loadImage("mountain.png");
  img.add(TmpImg);
  TmpImg=loadImage("sun.png");
  img.add(TmpImg);
  words.add("《望天门山》李白");
  words.add("天门中断楚江开");
  words.add("碧水东流至此回");
  words.add("两岸青山相对出");
  words.add("孤帆一片日边来");
  words.add("岁月如歌");

  nextWord(words.get(wordIndex));
}


void draw() {
  // Background & motion blur
  fill(bgColor);
  image(img.get(ImgIndex),0,0,width,height);
  noStroke();
  rect(0, 0, width*2, height*2);

  for (int x = particles.size ()-1; x > -1; x--) {
    //模拟子产生
    Particle particle = particles.get(x);
    particle.move();
    particle.draw();

    // Remove any dead pixels out of bounds
    if (particle.isKilled) {
      if (particle.pos.x < 0 || particle.pos.x > width || particle.pos.y < 0 || particle.pos.y > height) {
        particles.remove(particle);
      }
    }
  }

  // 提示语句
  fill(255-red(bgColor));
  PFont font = createFont(fontName,15);
  textFont(font);
  String tipText = "左键切换下一句";
  tipText += "\n拖拽右键清除粒子";
  tipText += "\n按b切换背景";
  tipText +="\n按p键切换点圆";
  text(tipText, 10, height-80);
}


// 切换下一句
void mousePressed() {
  if (mouseButton == LEFT) {
    wordIndex += 1;
    if (wordIndex > words.size()-1) { 
      wordIndex = 0;
    }
    nextWord(words.get(wordIndex));
  }
}


// 清除右键触及的粒子
void mouseDragged() {
  if (mouseButton == RIGHT) {
    for (Particle particle : particles) {
      if (dist(particle.pos.x, particle.pos.y, mouseX, mouseY) < 50) {  //右键50像素点内的粒子将被清除
        particle.kill();
      }
    }
  }
}


// 按键
void keyPressed() {
  
  if(key!=CODED)
  {
    switch (key)
    {
      case 's':
        save("MyPic.bmp");
        break;
      case 'p':
        drawAsPoints = (! drawAsPoints);
          if (drawAsPoints) 
          {
              //background(0);
              bgColor = color(0, 40);
           } else 
              {
                 //background(255);
                 bgColor = color(255, 100);
               }
       case 'b':
           ImgIndex+=1;
           if(ImgIndex>=img.size())
             ImgIndex=0;
           break;
       default:
        break;
    }
      
  }
}