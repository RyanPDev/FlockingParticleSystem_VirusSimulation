void createAvatar() // Funcion que crea avatares
{
    arrayAvatar.add(new particula(
    new PVector (random(0, worldBoundaryX), random(0, worldBoundaryY), random(0, worldBoundaryZ)), 
    new PVector (random(-10.0, 10.0), random(-10.0, 10.0), random(-10.0, 10.0)), 
    1.0, 
    random(nonLeaderMinSize, nonLeaderMaxSize), 
    color(0, random(255), 0))); 
    
    updateAllAvatarIds();
   
}

void avatarInteraction() // Funcion que controla el comportamiento del enemigo
{
  for (int i = arrayAvatar.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
  {
    particula avatar = arrayAvatar.get(i);
    if (gamePhase == Phase.SIMULATION)
    {
      avatar.move();
    }
    avatar.drawParticle(); 
  }
}

void eraseAvatar(int num)
{
  if(arrayAvatar.size() != 0)
  {
    arrayAvatar.remove(num); 
    updateAllAvatarIds();
  }
  
}

void updateAllAvatarIds()
{
  if(arrayAvatar.size() != 0)
  {
    arrayAvatar.get(0).turnIntoLeader();
    for (int i = arrayAvatar.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
    {
      arrayAvatar.get(i).updateId(i);
    }
  }
}
