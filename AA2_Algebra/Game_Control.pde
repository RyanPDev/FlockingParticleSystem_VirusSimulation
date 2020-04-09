void keyPressed() // Funcion propia de Processing que se ejecuta cada vez que se presiona una tecla
{
  if((key == 'p' || key == 'P') && gamePhase != Phase.STARTING) // Activar o desactivar el PAUSE
      {
          if(!isPaused)
          {
              isPaused = true;
              auxiliarPhase = gamePhase;
              gamePhase = Phase.PAUSE; 
          }
          else if(isPaused)
          {
           
            gamePhase = auxiliarPhase;
            isPaused = false;
          }
      }
      if((key == 'v' || key == 'V') && gamePhase != Phase.STARTING) // Hacer que la camara siga o deje de seguir a la meta
      {
          if(!cameraFollowGoal)
          {
              cameraFollowGoal = true;
              cameraPhase = CamPhase.GOAL;
              
          }
          else if(cameraFollowGoal)
          {
            cameraFollowGoal = false;
            cameraPhase = CamPhase.CENTERWORLD;
            
          }
          updateCameraLookAt();
      }
}



void pauseGame() // Funcion que pausa el juego LA USAREMOS LUEGO PARA METER UN TEXTO DE PAUSA EN ALGUN LUGAR USANDO UN HUD -NO BORRES ESTO-
{
      /*textSize(50);
      textAlign(CENTER);
      fill(255);
      text("PAUSE", (width / 2), height / 2);*/
      
}
