class TextGraphics
{  
  PGraphics pg;//buffer PG used to write the input char

  TextGraphics()
  {
    pg = createGraphics(width, height, P2D);
    process(new String("Nothing"));//"Ï�")//initialize with a String
    //process(words.get(1));
  }

  void process(String c)
  {
    pg.beginDraw();
    pg.translate(-width/2, -height/1.7);
    pg.background(0);
    pg.textSize(250);//500
    pg.fill(color(0, 255, 0));
    pg.textAlign(CENTER, CENTER);
    PFont font = createFont(fontName,200);
    pg.textFont(font);
    pg.text(c, width, height);
    pg.translate(width/2, height/1.7);
    pg.endDraw();

    pgpx = new int[width * height];
    pg.loadPixels();
    arrayCopy(pg.pixels, pgpx);
    pg.updatePixels();

    createParticles();
  }
}