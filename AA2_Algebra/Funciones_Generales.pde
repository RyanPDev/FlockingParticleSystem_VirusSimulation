void drawGoal() // pinta la meta
{
  pushMatrix();
  translate(posGoal.x + (goalSize / 2), posGoal.y + (goalSize / 2), posGoal.z + (goalSize / 2));
  //rotateX(radians(-35.26));
  //rotateY(radians(-45));
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
  //rotateX(radians(-35.26));
 // rotateY(radians(-45));
  stroke(0, 0, 255);
  strokeWeight(5);
  noFill();


  box(worldBoundaryX, worldBoundaryY, worldBoundaryZ);  
  popMatrix();
}


void updateCameraLookAt() // ACtualiza el modo de seguimiento de la camara
{
  pushMatrix();
  
  if (cameraPhase == CamPhase.GOAL)
  {
    translate(posGoal.x, posGoal.y, posGoal.z);
    applyMatrix(g3.camera);
    cam.lookAt(0, 0, 0, animationTimeInMillis);
    //cam.lookAt(posGoal.x, posGoal.y, posGoal.z, animationTimeInMillis);
  } else if (cameraPhase == CamPhase.CENTERWORLD)
  {
    translate(worldBoundaryX/2, worldBoundaryY/2, worldBoundaryZ/2);
    applyMatrix(g3.camera);
    cam.lookAt(0, 0, 0, animationTimeInMillis);
    //cam.lookAt(worldBoundaryX/2, worldBoundaryY/2, worldBoundaryZ/2, animationTimeInMillis);
  }
  popMatrix();
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
    
  if (posLeader.z <= posGoal.z) 
    newZ = posGoal.z;
    
  else if (posLeader.z >= posGoal.z+goalSize) 
    newZ = posGoal.z+goalSize;

  float distX = posLeader.x-newX;
  float distY = posLeader.y-newY;
  float distZ = posLeader.z-newZ;
  float distance = sqrt(sq(distX) + sq(distY) + sq(distZ));

  if (distance <= leaderSize)
  {
    posGoal = calculateRandomPosition();
    
    float borderDistance = goalSize *3;
    
    if(posGoal.x > worldBoundaryX - borderDistance)
    {
       posGoal.x = worldBoundaryX - borderDistance; 
    }
    else if(posGoal.x < 0 + borderDistance)
    {
       posGoal.x = 0 + borderDistance;
    }
    if(posGoal.y > worldBoundaryY - borderDistance)
    {
       posGoal.y = worldBoundaryY - borderDistance; 
    }
    else if(posGoal.y < 0 + borderDistance)
    {
       posGoal.y = 0 + borderDistance;
    }
    if(posGoal.z > worldBoundaryZ - borderDistance)
    {
       posGoal.z = worldBoundaryZ - borderDistance; 
    }
    else if(posGoal.z < 0 + borderDistance)
    {
       posGoal.z = 0 + borderDistance;
    }
    
    if (cameraFollowGoal) // Si la camara deberia seguir a la meta
    {
      updateCameraLookAt();
    }
  }
}


PVector calculateRandomPosition() // Mueve la meta a una posicion random dentro del cubo
{
  PVector calculatedPosition;
  calculatedPosition = new PVector(0, 0, 0);
  calculatedPosition.x = random(0, worldBoundaryX);
  calculatedPosition.y = random(0, worldBoundaryY);
  calculatedPosition.z = random(0, worldBoundaryZ); 

  return calculatedPosition;
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
