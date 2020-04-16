void updateCameraLookAt() // ACtualiza el modo de seguimiento de la camara
{
  /* if (cameraPhase == CamPhase.GOAL)
   {
   // cam.lookAt(0, 0, 0, animationTimeInMillis);
   cam.pan(posGoal.x, posGoal.y);
   //cam.lookAt(posGoal.x, posGoal.y, posGoal.z, animationTimeInMillis);
   } else */
  if (cameraPhase == CamPhase.CENTERWORLD)
  {
    cam.lookAt(-249.9062, 834.14703, 377.45096, 2600, animationTimeInMillis);
  }
}


void collisionLeaderGoal() {  
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

    checkIfGoalOutOfBounds();

    if (cameraFollowGoal) // Si la camara deberia seguir a la meta
    {
      updateCameraLookAt();
    }
  }
}
void checkIfGoalOutOfBounds()
{
  float borderDistance = goalSize *3;

  if (posGoal.x > worldBoundaryX - borderDistance)
  {
    posGoal.x = worldBoundaryX - borderDistance;
  } else if (posGoal.x < 0 + borderDistance)
  {
    posGoal.x = 0 + borderDistance;
  }
  if (posGoal.y > worldBoundaryY - borderDistance)
  {
    posGoal.y = worldBoundaryY - borderDistance;
  } else if (posGoal.y < 0 + borderDistance)
  {
    posGoal.y = 0 + borderDistance;
  }
  if (posGoal.z > worldBoundaryZ - borderDistance)
  {
    posGoal.z = worldBoundaryZ - borderDistance;
  } else if (posGoal.z < 0 + borderDistance)
  {
    posGoal.z = 0 + borderDistance;
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
