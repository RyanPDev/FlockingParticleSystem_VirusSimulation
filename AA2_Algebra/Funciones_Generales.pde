void pintar_la_meta() // pinta la meta
{
  pushMatrix();
  translate(posGoal.x + (goalSize / 2), posGoal.y + (goalSize / 2), posGoal.z + (goalSize / 2));
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
    cam.lookAt(posGoal.x, posGoal.y, posGoal.z, animationTimeInMillis);
  } else if (cameraPhase == CamPhase.CENTERWORLD)
  {
    cam.lookAt(worldBoundaryX/2, worldBoundaryY/2, worldBoundaryZ/2, animationTimeInMillis);
  }
}


void collisionCircleRectangle() {
  float newX = posLeader.x;
  float newY = posLeader.y;
  float newZ = posLeader.z;

  if (posLeader.x <= posGoal.x) 
    newX = posGoal.x;     
  else if (posLeader.x >= posGoal.x+goalSize) 
    newX = posGoal.x+goalSize;
  if (posLeader.y <= posGoal.y) 
    newY = posGoal.y;
  else if (posLeader.y >= posGoal.y+goalSize) 
    newY = posGoal.y+goalSize;
  if (posLeader.y <= posGoal.y) 
    newY = posGoal.z;
  else if (posLeader.z >= posGoal.z+goalSize) 
    newZ = posGoal.z+goalSize;

  float distX = posLeader.x-newX;
  float distY = posLeader.y-newY;
  float distZ = posLeader.z-newZ;
  float distance = sqrt(sq(distX) + sq(distY) + sq(distZ));

  if (distance <= leaderSize)
  {
    posGoal = randomPosition();
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
