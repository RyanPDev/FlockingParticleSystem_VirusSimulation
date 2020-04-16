void createAvatar(PVector position) // Funcion que crea avatares
{
  PVector avatarPosition = new PVector(0, 0, 0);
  avatarPosition = position;
  if (position.x == 0 && position.y == 0 && position.z == 0)
  {
    avatarPosition = new PVector (random(0, worldBoundaryX), random(0, worldBoundaryY), random(0, worldBoundaryZ));
  }

  arrayAvatar.add(new particula(
    avatarPosition, 
    new PVector (random(-10.0, 10.0), random(-10.0, 10.0), random(-10.0, 10.0)), 
    1.0, 
    random(nonLeaderMinSize, nonLeaderMaxSize), 
    color(0, random(100,255), 0))); 

  updateAllAvatarIds(); //Esta funcion es clave para las Id's
}

void avatarInteraction() // Funcion que controla el comportamiento del enemigo
{
  for (int i = arrayAvatar.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
  {
    particula avatar = arrayAvatar.get(i);
    if (gamePhase == Phase.SIMULATION)
    {
      avatar.move();
      avatar.collisionParticleFood(); // --> Pestaña Particula
    }
    avatar.drawParticle();
  }
}

void eraseAvatar(int num)
{
  if (arrayAvatar.size() != 0)
  {
    arrayAvatar.remove(num); 
    updateAllAvatarIds();
  }
}

void updateAllAvatarIds() // Asigno a todos los avatares, un identificador por orden, esto se hace cada vez que se añade uno o se quita uno
{
  if (arrayAvatar.size() != 0)
  {
    arrayAvatar.get(0).turnIntoLeader();
    for (int i = arrayAvatar.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
    {
      arrayAvatar.get(i).updateId(i);
    }
  }
}
