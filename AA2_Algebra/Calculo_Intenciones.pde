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

  //Se suman las posiciones de todos los avatares
  if (id != particulaArray.length)
  {
    for (int i = id+1; i < particulaArray.length; i++) /////////////////////////////////////////////////////////
    {
      float vector = sq(particulaArray[id].pos.x - particulaArray[i].pos.x)+sq(particulaArray[id].pos.y - particulaArray[i].pos.y)+sq(particulaArray[id].pos.z - particulaArray[i].pos.z);
      
      if (vector!=0)
      {
        float distance = sqrt(vector);
        if (distance < minimumGetAwayDistance)
        {
          if(distance < closestDistance)
          {
             closestDistance = distance;
             closestAvatar = i;
             socialDistancing = true;
          }
        }
      }
    }
  }
  // Comprovación con el Lider
  float vector = sq(particulaArray[id].pos.x - particulaArray[0].pos.x)+sq(particulaArray[id].pos.y - particulaArray[0].pos.y)+sq(particulaArray[id].pos.z - particulaArray[0].pos.z);
    if (vector!=0)
    {
      float distance = sqrt(vector);
      if (distance < minimumGetAwayDistance)
      {
        if(distance < closestDistance)
        {
           closestDistance = distance;
           closestAvatar = 0;
           socialDistancing = true;
        }
      }
    }
    if(socialDistancing) // Solo hacemos que no se toquen si es que hay alguno que este suficientemente cerca
    {
        calculatedVector = calculateUnitVector(particulaArray[closestAvatar].pos,particulaArray[id].pos);
    }

  //Si un pajaro esta muy cerca de otro, este devolvera un vector en direccion contraria, si no hay ninguno, simplemente devuelve 0

  return calculatedVector;
}


PVector calculateFlockCenter() // Promedio entre todos los avatares
{
  PVector calculatedPosition;
  calculatedPosition = new PVector(0.0, 0.0, 0.0);

  //Se suman las posiciones de todos los avatares
  for (int i = 0; i< particulaArray.length; i++) /////////////////////////////////////////////////////////
  {
    calculatedPosition.x += particulaArray[i].pos.x;
    calculatedPosition.y += particulaArray[i].pos.y;
    calculatedPosition.z += particulaArray[i].pos.z;
  }

  //Se dividen esa suma por el total de avatares que haya
  calculatedPosition.x /= 10;
  calculatedPosition.y /= 10;
  calculatedPosition.z /= 10;

  return calculatedPosition;
}
