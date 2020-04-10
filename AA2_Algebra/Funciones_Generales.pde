void pintar_la_meta() // pinta la meta
{
  pushMatrix();
  translate(pos_meta.x + (goalSize / 2), pos_meta.y + (goalSize / 2), pos_meta.z + (goalSize / 2));
  rotateX(radians(-35.26));
  rotateY(radians(-45));
  strokeWeight(8);
  stroke(255, 215, 0);
  fill(255, 0, 0);
  box(goalSize);
  popMatrix();
}

void drawWorldBoundaries() //Dibuja el cubo de los limites
{
  pushMatrix();
  translate(0, 0, 0);
  stroke(0, 255, 255);
  sphere(20);
  translate(worldBoundaryX/2, worldBoundaryY/2, worldBoundaryZ/2);
  rotateX(radians(-35.26));
  rotateY(radians(-45));
  stroke(0, 0, 255);
  strokeWeight(5);
  noFill();


  box(worldBoundaryX*1.5, worldBoundaryY*1.5, worldBoundaryZ*1.5);  
  popMatrix();
}


void updateCameraLookAt() // ACtualiza el modo de seguimiento de la camara
{
  if (cameraPhase == CamPhase.GOAL)
  {
    cam.lookAt(pos_meta.x, pos_meta.y, pos_meta.z, animationTimeInMillis);
  } else if (cameraPhase == CamPhase.CENTERWORLD)
  {
    cam.lookAt(worldBoundaryX/2, worldBoundaryY/2, worldBoundaryZ/2, animationTimeInMillis);
  }
}


void collisionCircleRectangle() {
  float newX = pos_lider.x;
  float newY = pos_lider.y;
  float newZ = pos_lider.z;

  if (pos_lider.x <= pos_meta.x) 
    newX = pos_meta.x;     
  else if (pos_lider.x >= pos_meta.x+goalSize) 
    newX = pos_meta.x+goalSize;
  if (pos_lider.y <= pos_meta.y) 
    newY = pos_meta.y;
  else if (pos_lider.y >= pos_meta.y+goalSize) 
    newY = pos_meta.y+goalSize;
  if (pos_lider.y <= pos_meta.y) 
    newY = pos_meta.z;
  else if (pos_lider.z >= pos_meta.z+goalSize) 
    newZ = pos_meta.z+goalSize;

  float distX = pos_lider.x-newX;
  float distY = pos_lider.y-newY;
  float distZ = pos_lider.z-newZ;
  float distance = sqrt(sq(distX) + sq(distY) + sq(distZ));

  if (distance <= liderSize)
  {
    pos_meta = randomPosition();
    if (cameraFollowGoal) // Si la camara deberia seguir a la meta
    {
      updateCameraLookAt();
    }
  }
}





PVector randomPosition() // Mueve la meta a una posicion random dentro del cubo
{
  PVector posicion_calculada;
  posicion_calculada = new PVector(0, 0, 0);
  posicion_calculada.x = random(0, worldBoundaryX);
  posicion_calculada.y = random(0, worldBoundaryY);
  posicion_calculada.z = random(0, worldBoundaryZ); 

  return posicion_calculada;
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
