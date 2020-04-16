PVector calculateUnitVector(PVector pos1, PVector pos2)
{
  PVector calculatedVector;
  calculatedVector = new PVector(0, 0, 0);

  // Pos final (pos 2) menos pos inicial (pos1)
  calculatedVector.x = pos2.x - pos1.x;
  calculatedVector.y = pos2.y - pos1.y;
  calculatedVector.z = pos2.z - pos1.z;

  // Se calcula el modulo del vector
  // La raiz cuadrada de la suma de las componentes o coordenadas al cuadrado

  float vector = sq(calculatedVector.x)+sq(calculatedVector.y)+sq(calculatedVector.z);

  if (vector != 0) // Prevenimos que no se haga la raiz cuadrada de 0
  {
    float module = sqrt(vector);

    // Se divide cada componente o coordenada del vector por el modulo para
    // hacerlo unitario

    calculatedVector.x /= module;
    calculatedVector.y /= module;
    calculatedVector.z /= module;
  }

  return calculatedVector;
}

PVector randomMovementDirection(PVector currentRandomPosition)
{
  PVector calculatedPosition;
  calculatedPosition = currentRandomPosition;

  //TEMPORIZADOR
  //CADA 3 SEGUNDOS, una posicion random diferente
  if (millis() - randomPositionCurrentTime >= randomPositionTotalTime)
  {
    calculatedPosition = calculateRandomPosition();
    randomPositionCurrentTime = millis();
  }

  return calculatedPosition;
}

PVector calculateAvatarVector(int id)
{
  PVector calculatedVector;
  calculatedVector = new PVector(0.0, 0.0, 0.0);

  int closestAvatar = 0;
  float minimumGetAwayDistance = leaderSize * 3;
  float closestDistance = minimumGetAwayDistance;
  boolean socialDistancing = false;

  if (id < arrayAvatar.size())
  {
    particula avatar1 = arrayAvatar.get(id);

    for (int i = arrayAvatar.size(); i-- > id; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
    {
      particula avatar2 = arrayAvatar.get(i);
      float vector = sq(avatar1.pos.x - avatar2.pos.x)+sq(avatar1.pos.y - avatar2.pos.y)+sq(avatar1.pos.z - avatar2.pos.z);
      if (vector!=0)
      {
        float distance = sqrt(vector);
        if (distance < minimumGetAwayDistance)
        {
          if (distance < closestDistance)
          {
            closestDistance = distance;
            closestAvatar = i;
            socialDistancing = true;
            if(avatar1.isCloseToLeader)
            {
              avatar1.isCloseToLeader = false;
              avatar1.speedLimit = avatar1.nonLeaderSpeedLimit;
            }
          }
        }
      }
    }

    particula avatar2 = arrayAvatar.get(0);
    // Comprovación con el Lider
    float vector = sq(avatar1.pos.x - avatar2.pos.x)+sq(avatar1.pos.y - avatar2.pos.y)+sq(avatar1.pos.z - avatar2.pos.z);
    if (vector!=0)
    {
      float distance = sqrt(vector);
      if (distance < minimumGetAwayDistance)
      {
        if (distance < closestDistance)
        {
          closestDistance = distance;
          closestAvatar = 0;
          socialDistancing = true;
          
              avatar1.isCloseToLeader = true;
              avatar1.speedLimit = avatar1.leaderSpeedLimit;
          
        }
      }
    }
    if (socialDistancing) // Solo hacemos que no se toquen si es que hay alguno que este suficientemente cerca
    {
      avatar2 = arrayAvatar.get(closestAvatar);
      calculatedVector = calculateUnitVector(avatar2.pos, avatar1.pos);
    }
    else if(avatar1.isCloseToLeader)
    {
      avatar1.isCloseToLeader = false;
      avatar1.speedLimit = avatar1.nonLeaderSpeedLimit;
    }
  }
  //Si un pajaro esta muy cerca de otro, este devolvera un vector en direccion contraria, si no hay ninguno, simplemente devuelve 0

  return calculatedVector;
}

PVector calculateFlockCenter() // Promedio entre todos los avatares
{
  PVector calculatedPosition;
  calculatedPosition = new PVector(0.0, 0.0, 0.0);

  //Se suman las posiciones de todos los avatares

  for (int i = arrayAvatar.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
  {
    particula avatar = arrayAvatar.get(i);
    calculatedPosition.x += avatar.pos.x;
    calculatedPosition.y += avatar.pos.y;
    calculatedPosition.z += avatar.pos.z;
  }

  //Se dividen esa suma por el total de avatares que haya
  calculatedPosition.x /= arrayAvatar.size();
  calculatedPosition.y /= arrayAvatar.size();
  calculatedPosition.z /= arrayAvatar.size();

  return calculatedPosition;
}
