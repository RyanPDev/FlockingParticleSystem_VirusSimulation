void pintar_la_meta()
{
   pushMatrix();
   translate(pos_meta.x, pos_meta.y, pos_meta.z);
   rotateX(radians(-35.26));
   rotateY(radians(-45));
   strokeWeight(1);
   noFill();
   box(30);
   popMatrix();
}

void collisionCircleRectangle() {
  float newX = pos_lider.x;
  float newY = pos_lider.y;
  float newZ = pos_lider.z;
  
  if (pos_lider.x <= pos_meta.x) 
    newX = pos_meta.x;     
  else if (pos_lider.x >= pos_meta.x+30) 
    newX = pos_meta.x+30;
  if (pos_lider.y <= pos_meta.y) 
    newY = pos_meta.y;
  else if (pos_lider.y >= pos_meta.y+30) 
    newY = pos_meta.y+30;
  if (pos_lider.y <= pos_meta.y) 
    newY = pos_meta.z;
  else if (pos_lider.z >= pos_meta.z+30) 
    newZ = pos_meta.z+30;
  
  float distX = pos_lider.x-newX;
  float distY = pos_lider.y-newY;
  float distZ = pos_lider.z-newZ;
  float distance = sqrt(sq(distX) + sq(distY) + sq(distZ));
  
  if (distance <= 25)
  {
    pos_meta.x = random(width);
    pos_meta.y = random(height);
    pos_meta.z = random(-50,50);
  }
}

/*void isometricViewOn()
{
    pushMatrix();
    translate(0,0,0);
    rotateX(radians(-35.26));
    rotateY(-45);
}

void isometricViewOff()
{
    popMatrix();
}*/
