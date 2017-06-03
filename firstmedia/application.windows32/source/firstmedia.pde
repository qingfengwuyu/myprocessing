//全局变量
ArrayList<Particle> particles = new ArrayList<Particle>();
int pixelSteps = 6; // Amount of pixels to skip
boolean drawAsPoints = false;
ArrayList<String> words = new ArrayList<String>();
int wordIndex = 0;
color bgColor = color(255, 100);
String fontName = "MicrosoftYaHeiLight-48";
PFont tipfont;


void setup() {
  size(1000, 600);
  background(255);

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
  noStroke();
  rect(0, 0, width*2, height*2);

  for (int x = particles.size ()-1; x > -1; x--) {
    // Simulate and draw pixels
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

  // Display control tips
  fill(255-red(bgColor));
  PFont font = createFont(fontName,9);
  textFont(font);
  String tipText = "左键切换下一句";
  tipText += "\n拖拽右键清除粒子";
  tipText += "\n按任意键切换背景";
  text(tipText, 10, height-40);
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
      if (dist(particle.pos.x, particle.pos.y, mouseX, mouseY) < 50) {
        particle.kill();
      }
    }
  }
}


// 改变背景
void keyPressed() {
  drawAsPoints = (! drawAsPoints);
  if (drawAsPoints) {
    background(0);
    bgColor = color(0, 40);
  } else {
    background(255);
    bgColor = color(255, 100);
  }
}