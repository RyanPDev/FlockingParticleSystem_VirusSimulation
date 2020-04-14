void keyPressed() // Funcion propia de Processing que se ejecuta cada vez que se presiona una tecla
{
  if ((key == 'p' || key == 'P') && gamePhase != Phase.STARTING) // Activar o desactivar el PAUSE
  {
    if (!isPaused)
    {
      isPaused = true;
      auxiliarPhase = gamePhase;
      gamePhase = Phase.PAUSE;
    } else if (isPaused)
    {

      gamePhase = auxiliarPhase;
      isPaused = false;
    }
  }
  if ((key == 'h' || key == 'H') && gamePhase != Phase.STARTING) // Activar o desactivar el PAUSE
  {
    if (!showControls)
    {
      if(showRedArrow)
      {
         showRedArrow = false;  //Solo queremos enseñar la flecha roja la primera vez
      }
      showControls = true;
    } else if (showControls)
    {
      showControls = false;
    }
  }
  if ((key == 'r' || key == 'R') && gamePhase != Phase.STARTING) // Activar o desactivar el modo random
  {
    if (!randomMode)
    {
      randomMode = true;
    } else if (randomMode)
    {
      randomMode = false;
    }
  }
  if ((key == 'v' || key == 'V') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
  {
    if (!cameraFollowGoal)
    {
      cameraFollowGoal = true;
      cameraPhase = CamPhase.GOAL;
    } else if (cameraFollowGoal)
    {
      cameraFollowGoal = false;
      cameraPhase = CamPhase.CENTERWORLD;
    }
    updateCameraLookAt();
  }
  if ((key == '+') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
  {
    if (!enemyCreated)
    {
      enemyCreated = true;
      createEnemy();
    } 
  }
  if ((key == '-') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
  {
    if (!enemyErased)
    {
      enemyErased = true;
      eraseEnemy();
    } 
  }
}
void keyReleased() // Funcion propia de Processing que se ejecuta cada vez que se presiona una tecla
{
    if ((key == '+') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
    {
      if (enemyCreated)
      {
        enemyCreated = false;
      }
    }
    if ((key == '-') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
  {
    if (enemyErased)
    {
      enemyErased = false;
    } 
  }
}


void drawHUD() // Funcion que pone el mensaje
{

  cam.beginHUD();
  // now draw things that you want relative to the camera's position and orientation
  textSize(20);
  textAlign(LEFT);
  strokeWeight(1);
  fill(205,255,255, 150);
  rectMode(CORNERS);
  
  if (!showControls)
  {
    rect(18,0,375,25);
    
    fill(0,255);
    text("Press 'H' to show simulation controls", 20, 20);
    if(showRedArrow)
    {
      
      fill(255,0,0,255);
      text("<---", 380, 20);
      
      fill(0,255);
    }
  }
  else
  {
    rect(18,0,708,250);
    fill(0,255);
    text("Press 'P' to Pause/Unpause\nPress 'V' to focus on the goal or back to default\nPress 'R' for Random Mode\nRandom mode->(Every 3 seconds, every avatar will behave differently)\nDrag with Left Click to rotate camera\nSpin Mouse Wheel to Zoom\nPress Mouse Wheel and drag to move Camera\nPres 'H' to hide controls", (20), 20);
  }
  
  
  if (gamePhase == Phase.PAUSE)
  {
    textAlign(RIGHT);
    textSize(30); 
    text("Pause", (width - 20), 30);
  }
  if(randomMode)
  {
    textAlign(RIGHT);
    textSize(30); 
    text("Random Mode: ON", (width - 20), 60);
  }
  cam.endHUD(); // always!
}
