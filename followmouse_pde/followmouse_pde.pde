//followmouse.pde
void setup()
{
  size(480,120);
  fill(0,102);
  smooth();
 // noStroke();
  stroke(0,102);
}

void draw()
{
  //background(204);      //the newest ellipse
  //ellipse(mouseX,mouseY,9,9);
  float weight=dist(mouseX,mouseY,pmouseX,pmouseY);
  strokeWeight(weight);
  line(mouseX,mouseY,pmouseX,pmouseY);
}