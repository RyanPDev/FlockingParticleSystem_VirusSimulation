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
      showControls = true;
    } else if (showControls)
    {
      showControls = false;
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
}



void drawHUD() // Funcion que pone el mensaje
{

  cam.beginHUD();
  // now draw things that you want relative to the camera's position and orientation
  textSize(20);
  textAlign(LEFT);
  fill(0);
  if (!showControls)
    text("Press 'H' to show camera controls", 20, 20);
  else
    text("Press 'P' to Pause/Unpause\nPress 'V' to focus on the goal or back to default\nDrag with Left Click to rotate camera\nSpin Mouse Wheel to Zoom\nPress Mouse Wheel and drag to move Camera\nPres 'H' to hide controls", (20), 20);


  if (gamePhase == Phase.PAUSE)
  {
    textAlign(CENTER);
    textSize(50); 
    text("PAUSE", (width / 2), height / 8);
  }

  cam.endHUD(); // always!
}
