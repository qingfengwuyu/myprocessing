
class TextGraphics
{  
  PGraphics pg;//buffer PG used to write the input char

  TextGraphics()
  {
    pg = createGraphics(width, height);
    process(new String("Nothing"),1);//"Ï�")//initialize with a String
    //process(words.get(1));
  }

  PGraphics process(String c,int TmpTextSize)
  {
  pg.beginDraw();
  pg.fill(0);
  pg.textSize(100);
  pg.textAlign(CENTER);
  PFont font = createFont(fontName,TmpTextSize);
  pg.textFont(font);
  pg.text(c, width/2, height/2);
  pg.endDraw();
  pg.loadPixels();
  return pg;
  }
}

void nextWord(String word,int TmpTextSize) {
  // Draw word in memory
  PGraphics pg = createGraphics(width, height);
  pg=tg.process(word,TmpTextSize);

  // Next color for all pixels to change to
  color newColor = color(random(0.0, 255.0), random(0.0, 255.0), random(0.0, 255.0));

  int particleCount = particles.size();
  int particleIndex = 0;

  // Collect coordinates as indexes into an array
  // This is so we can randomly pick them to get a more fluid motion
  ArrayList<Integer> coordsIndexes = new ArrayList<Integer>();
  for (int i = 0; i < (width*height)-1; i+= pixelSteps) {
    coordsIndexes.add(i);
  }

  for (int i = 0; i < coordsIndexes.size (); i++) {
    // Pick a random coordinate
    int randomIndex = (int)random(0, coordsIndexes.size());
    int coordIndex = coordsIndexes.get(randomIndex);
    coordsIndexes.remove(randomIndex);
    
    // Only continue if the pixel is not blank
    if (pg.pixels[coordIndex] != 0) {
      // Convert index to its coordinates
      int x = coordIndex % width;
      int y = coordIndex / width;

      Particle newParticle;

      if (particleIndex < particleCount) {
        // Use a particle that's already on the screen 
        newParticle = particles.get(particleIndex);
        newParticle.isKilled = false;
        particleIndex += 1;
      } else {
        // Create a new particle
        newParticle = new Particle();
        
        PVector randomPos = generateRandomPos(width/2, height/2, (width+height)/2);
        newParticle.pos.x = randomPos.x;
        newParticle.pos.y = randomPos.y;
        
        newParticle.maxSpeed = random(2.0, 5.0);
        newParticle.maxForce = newParticle.maxSpeed*0.025;
        newParticle.particleSize = random(3, 6);
        newParticle.colorBlendRate = random(0.0025, 0.03);
        
        particles.add(newParticle);
      }
      
      // Blend it from its current color
      newParticle.startColor = lerpColor(newParticle.startColor, newParticle.targetColor, newParticle.colorWeight);
      newParticle.targetColor = newColor;
      newParticle.colorWeight = 0;
      
      // Assign the particle's new target to seek
      newParticle.target.x = x;
      newParticle.target.y = y;
    }
  }

  // Kill off any left over particles
  if (particleIndex < particleCount) {
    for (int i = particleIndex; i < particleCount; i++) {
      Particle particle = particles.get(i);
      particle.kill();
    }
  }
}