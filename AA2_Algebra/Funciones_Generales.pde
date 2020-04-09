void pintar_la_meta() // pinta la meta
{
   pushMatrix();
   translate(pos_meta.x + (goalSize / 2), pos_meta.y + (goalSize / 2), pos_meta.z + (goalSize / 2));
   rotateX(radians(-35.26));
   rotateY(radians(-45));
   strokeWeight(8);
   stroke(255,215,0);
   noFill();
   box(goalSize);
   popMatrix();
}

void drawWorldBoundaries() //Dibuja el cubo de los limites
{
   pushMatrix();
   translate(0,0,0);
   stroke(0,255,255);
   sphere(20);
   translate(worldBoundaryX/2,worldBoundaryY/2,worldBoundaryZ/2);
   rotateX(radians(-35.26));
   rotateY(radians(-45));
   stroke(0,0,255);
   strokeWeight(5);
   noFill();
   
   
   box(worldBoundaryX,worldBoundaryY,worldBoundaryZ);  
   popMatrix();
  
}


void updateCameraLookAt() // ACtualiza el modo de seguimiento de la camara
{
  if(cameraPhase == CamPhase.GOAL)
  {
    cam.lookAt(pos_meta.x,pos_meta.y, pos_meta.z, animationTimeInMillis);
  }
  else if(cameraPhase == CamPhase.CENTERWORLD)
  {
    cam.lookAt(worldBoundaryX/2,worldBoundaryY/2,worldBoundaryZ/2, animationTimeInMillis);
  }
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
    randomMetaPosition();
    if(cameraFollowGoal) // Si la camara deberia seguir a la meta
    {
        updateCameraLookAt();
    }
  }
  
}

void randomMetaPosition() // Mueve la meta a una posicion random dentro del cubo
{
 pos_meta.x = random(0,worldBoundaryX);
 pos_meta.y = random(0,worldBoundaryY);
 pos_meta.z = random(0,worldBoundaryZ); 
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
