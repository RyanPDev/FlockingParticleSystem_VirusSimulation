void drawGoal() // pinta la meta
{
  pushMatrix();
  translate(posGoal.x + (goalSize / 2), posGoal.y + (goalSize / 2), posGoal.z + (goalSize / 2));
  //rotateX(radians(-35.26));
  //rotateY(radians(-45));
  strokeWeight(2);
  stroke(255, 215, 0);
  fill(255, 0, 0);
  box(goalSize);
  popMatrix();
}

void drawWorldBoundaries() //Dibuja el cubo de los limites
{
  pushMatrix();
  translate(0, 0, 0);
  //stroke(0, 255, 255);
  //sphere(20);
  translate(worldBoundaryX/2, worldBoundaryY/2, worldBoundaryZ/2);
  //rotateX(radians(-35.26));
  // rotateY(radians(-45));
  stroke(0, 0, 255);
  strokeWeight(5);
  noFill();


  box(worldBoundaryX, worldBoundaryY, worldBoundaryZ);  
  popMatrix();
}
void drawHUD() // Funcion que pone el mensaje
{

  cam.beginHUD();
  // now draw things that you want relative to the camera's position and orientation
  textSize(20);
  textAlign(LEFT);
  strokeWeight(1);
  fill(205, 255, 255, 150);
  rectMode(CORNERS);

  if (!showControls)
  {
    rect(18, 0, 375, 25);

    fill(0, 255);
    text(showControlsText, 20, 20);
    if (showRedArrow)
    {

      fill(255, 0, 0, 255);
      text("<---", 380, 20);

      fill(0, 255);
    }
  } else
  {
    rect(18, 0, 858, 250);
    rect(18, 0, 858, 250);
    rect(width -605, height - 185, width - 180, height - 15);
    rect(width -605, height - 185, width - 180, height - 15); // 2 veces porque queda mejor

    fill(0, 255);

    text(simulationControlsText+cameraControlsText, (20), 20);
    textAlign(LEFT, CENTER);
    text(addingControlText, (width - 600), height - 100);
  }


  if (gamePhase == Phase.PAUSE)
  {
    textAlign(RIGHT);
    textSize(30); 
    text("Pause", (width - 20), 30);
  }
  if (randomMode)
  {
    textAlign(RIGHT);
    textSize(30); 
    text("Random Mode: ON", (width - 20), 60);
  }

  textAlign(CENTER, CENTER);

  textSize(15); 
  if (selectedObjectType == ObjectType.AVATAR)
  {
    textSize(22);
    fill(0, 255, 0);
  }
  text("Corona Virus", (width - 100), height - 150);
  textSize(15);
  fill(0);
  if (selectedObjectType == ObjectType.ENEMY)
  {
    textSize(22);
    fill(255, 0, 0);
  }
  text("Immune Cells", (width - 100), height - 110);
  textSize(15);
  fill(0);
  if (selectedObjectType == ObjectType.FOOD)
  {
    textSize(22);
    fill(255, 192, 203 );
  }
  text("Vulnerable\nCells", (width - 100), height - 60);
  textSize(15);
  fill(0);




  cam.endHUD(); // always!
}
