int x=60;      //x-axis
int y=420;      //y-axis
int bodyHeight=110; //the height of the body
int neckHeight=140;
int radius=45;
int ny=y-bodyHeight-neckHeight-radius;

size(170,480);
smooth();
strokeWeight(2);
background(204);
ellipseMode(RADIUS);

//neck
stroke(102);
line(x+2,y-bodyHeight,x+2,ny);
line(x+12,y-bodyHeight,x+12,ny);
line(x+22,y-bodyHeight,x+22,ny);
//air wire
line(x+12,ny,x-18,ny-43);
line(x+12,ny,x+42,ny-99);
line(x+12,ny,x+78,ny+155);
//body
noStroke();
fill(102);
ellipse(x,y-33,33,33);
fill(0);
rect(x-45,y-bodyHeight,90,bodyHeight-33);
fill(102);
rect(x-45,y-bodyHeight+17,90,6);
//head
fill(0);
ellipse(x+12,ny,radius,radius);
fill(255);
ellipse(x+24,ny-6,14,14);
fill(0);
ellipse(x+24,ny-6,3,3);
fill(153);
ellipse(x,ny-8,5,5);
ellipse(x+30,ny-26,3,3);