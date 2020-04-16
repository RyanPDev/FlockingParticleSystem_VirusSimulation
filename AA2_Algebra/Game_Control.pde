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
      if (showRedArrow)
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
    if (selectedObjectType == ObjectType.AVATAR)
    {
      if (!somethingCreated)
      {
        somethingCreated = true;
        createAvatar(new PVector(0, 0, 0));
      }
    } else if (selectedObjectType == ObjectType.ENEMY)
    {
      if (!somethingCreated)
      {
        somethingCreated = true;
        createEnemy();
      }
    } else if (selectedObjectType == ObjectType.FOOD)
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
    if (selectedObjectType == ObjectType.AVATAR)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        eraseAvatar(0);
      }
    } else if (selectedObjectType == ObjectType.ENEMY)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        eraseEnemy(0);
      }
    } else if (selectedObjectType == ObjectType.FOOD)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        eraseFood(0);
      }
    }
  }
  if ((key == '0') && gamePhase != Phase.STARTING)
  {
    if (selectedObjectType == ObjectType.AVATAR)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        arrayAvatar.clear();
      }
    } else if (selectedObjectType == ObjectType.ENEMY)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        arrayEnemies.clear();;
      }
    } else if (selectedObjectType == ObjectType.FOOD)
    {
      if (!somethingErased)
      {
        somethingErased = true;
        arrayFood.clear();
      }
    }
  }
 
  if ((key == ' ') && gamePhase != Phase.STARTING)
  {
    if (!changedSelectedObject)
    {
      changedSelectedObject = true;
      if (selectedObjectType == ObjectType.AVATAR)
      {
        selectedObjectType = ObjectType.ENEMY;
      } else if (selectedObjectType == ObjectType.ENEMY)
      {
        selectedObjectType = ObjectType.FOOD;
      } else if (selectedObjectType == ObjectType.FOOD)
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
  if ((key == '-' || key == '0' ) && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
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
