class Particle
{
  final float SPEED_MIN = .12, SPEED_MAX = .25, h = 80;
  PVector pos, origin, speed;
  int rank, col = color(random(128, 255), random(128, 205), 90, 120);
  float n, nz;//noise
  Boolean stuck = false;//against a wall

  Particle(int p_rank)
  {
    rank = p_rank;
    init();
  }

  void init()
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

  void update()
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