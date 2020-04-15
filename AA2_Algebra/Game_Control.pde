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
  //////////////////////////////////////////////////////////////////////////////
  if ((key == '+') && gamePhase != Phase.STARTING)
  {
    if(selectedObjectType == ObjectType.AVATAR)
    {
      if (!somethingCreated)
      {
        somethingCreated = true;
        createAvatar();
      } 
    }
    else if(selectedObjectType == ObjectType.ENEMY)
    {
      if (!somethingCreated)
      {
        somethingCreated = true;
        createEnemy();
      } 
    }
    else if(selectedObjectType == ObjectType.FOOD)
    {
      if (!somethingCreated)
      {
        somethingCreated = true;
        createFood();
      } 
    }
  }
  if ((key == '-') && gamePhase != Phase.STARTING)
  {
    if(selectedObjectType == ObjectType.AVATAR)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        eraseAvatar(0);
      } 
    }
    else if(selectedObjectType == ObjectType.ENEMY)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        eraseEnemy(0);
      } 
    }
    else if(selectedObjectType == ObjectType.FOOD)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        eraseFood(0);
      } 
    }   
  }
  if ((key == ' ') && gamePhase != Phase.STARTING)
    {
      if(!changedSelectedObject)
      {
       changedSelectedObject = true;
       if(selectedObjectType == ObjectType.AVATAR)
       {
         selectedObjectType = ObjectType.ENEMY;
       }
       else if(selectedObjectType == ObjectType.ENEMY)
       {
         selectedObjectType = ObjectType.FOOD;
       }
       else if(selectedObjectType == ObjectType.FOOD)
       {
         selectedObjectType = ObjectType.AVATAR;
       }
      }
    }
  
  
  
}
void keyReleased() // Funcion propia de Processing que se ejecuta cada vez que se presiona una tecla
{
    if ((key == '+') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
    {
      if (somethingCreated)
      {
        somethingCreated = false;
      }
    }
    if ((key == '-') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
  {
    if (somethingErased)
    {
      somethingErased = false;
    } 
  }
   if ((key == ' ') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
  {
    if (changedSelectedObject)
    {
      changedSelectedObject = false;
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
    text(showControlsText, 20, 20);
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
    rect(18,0,708,250);
    rect(width -600, height - 150 , width - 180, height - 50);
    rect(width -600, height - 150 , width - 180, height - 50);
    
    fill(0,255);
    
    text(simulationControlsText+cameraControlsText, (20), 20);
    textAlign(LEFT,CENTER);
    text(addingControlText, (width - 600), height - 100);
    
      
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
  
  textAlign(CENTER, CENTER);
  
  textSize(15); 
  if(selectedObjectType == ObjectType.AVATAR)
    {
      textSize(35);
      fill(0,0,255);
    }
  text("AVATAR", (width - 100), height - 150);
  textSize(15);
  fill(0);
  if(selectedObjectType == ObjectType.ENEMY)
    {
      textSize(35);
      fill(255,0,0);
    }
  text("ENEMY", (width - 100), height - 110);
  textSize(15);
  fill(0);
  if(selectedObjectType == ObjectType.FOOD)
    {
      textSize(35);
      fill(0,255,0);
    }
  text("FOOD", (width - 100), height - 70);
  textSize(15);
  fill(0);
  
  
  
  
  cam.endHUD(); // always!
}
