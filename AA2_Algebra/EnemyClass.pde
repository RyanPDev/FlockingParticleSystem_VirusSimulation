//Zona de Clases
class Enemy {

  PVector pos, vel, rotation;
  int idNumber;
  float mass, size, KM, KV, KA, minimumDistance; 
  color colorP;
  PVector randomMovementPosition;

  float speedLimit = 2;

  float randomConstantCurrentTime;
  float randomConstantTotalTime;

  Enemy(PVector p, PVector v, float m, float t, color c)
  {
    pos = p;
    vel = v;
    mass = m;
    size = t;
    colorP = c;
    rotation = new PVector(35.26, -45, 0);

    KM = 0.125;
    KV = 0.25;
    KA = 0.5;

    minimumDistance = size * 1.3;

    randomMovementPosition = new PVector(0, 0, 0);
    randomMovementPosition = calculateRandomPosition();

    randomConstantCurrentTime = 0;
    randomConstantTotalTime = 5000; // 5 segundos
  }
  // METODOS
  void move() //Mueve a los enemigos usando el solver de Euler
  {
    // 1- Fuerza y Aceleracion
    PVector acel, getAwayVector, randomVector, particleVector;
    acel = new PVector(0.0, 0.0, 0.0);
    particleVector = new PVector(0.0, 0.0, 0.0);
    getAwayVector = new PVector(0.0, 0.0, 0.0);
    randomVector = new PVector(0.0, 0.0, 0.0);

    newRandomPosition();
    randomVector = calculateUnitVector(pos, randomMovementPosition);
    particleVector = calculateNearParticleVector();
    getAwayVector = calculateEnemyVector();

    // MEDIA PONDERADA

    acel.x += KM * randomVector.x + KV * particleVector.x + KA * getAwayVector.x;
    acel.y += KM * randomVector.y + KV * particleVector.y + KA * getAwayVector.y;
    acel.z += KM * randomVector.z + KV * particleVector.z + KA * getAwayVector.z;

    // NEWTON Suma Fuerzas = masa x Aceleracion
    acel.x /= mass;
    acel.y /= mass;
    acel.z /= mass;

    // 2- Velocidad
    vel.x = vel.x + acel.x * inc_t;
    vel.y = vel.y + acel.y * inc_t;
    vel.z = vel.z + acel.z * inc_t;

    if (vel.x > speedLimit)
    {
      vel.x = speedLimit;
    } else if (vel.x < -speedLimit)
    {
      vel.x = -speedLimit;
    }
    if (vel.y > speedLimit)
    {
      vel.y = speedLimit;
    } else if (vel.y < -speedLimit)
    {
      vel.y = -speedLimit;
    }
    if (vel.z > speedLimit)
    {
      vel.z = speedLimit;
    } else if (vel.z < -speedLimit)
    {
      vel.z = -speedLimit;
    }
    
    // 3- Posicion; Se limita su posición dentro del mundo delimitado por el cubo
    pos.x = pos.x + vel.x * inc_t;
    pos.y = pos.y + vel.y * inc_t;
    pos.z = pos.z + vel.z * inc_t;

    if (pos.x > worldBoundaryX - size)
    {
      pos.x = worldBoundaryX - size;
    } else if (pos.x < 0 + size)
    {
      pos.x = 0 + size;
    }
    if (pos.y > worldBoundaryY - size)
    {
      pos.y = worldBoundaryY - size;
    } else if (pos.y < 0 + size)
    {
      pos.y = 0 + size;
    }
    if (pos.z > worldBoundaryZ - size)
    {
      pos.z = worldBoundaryZ - size;
    } else if (pos.z < 0 + size)
    {
      pos.z = 0 + size;
    }
  }

  void drawParticle() //Dibuja la particula
  {
    pushMatrix(); // Salvo el estado

    translate(pos.x, pos.y, pos.z);

    noFill();
    stroke(colorP);
    strokeWeight(1);

    sphere(size);
 
    popMatrix();
  }

  PVector calculateEnemyVector() //Calcula el vector hacia la particula de su tipo mas cercana si se encuentra dentro de un rango maximo especificado
  {
    PVector calculatedVector;
    calculatedVector = new PVector(0.0, 0.0, 0.0);

    int closestEnemy = 0;
    float minimumGetAwayDistance = enemySize * 2.5;
    float closestDistance = minimumGetAwayDistance;
    boolean socialDistancing = false;

    if (idNumber < arrayEnemies.size())
    {
      for (int i = arrayEnemies.size(); i-- > idNumber; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
      {
        Enemy enemy2 = arrayEnemies.get(i);
        float vector = sq(pos.x - enemy2.pos.x)+sq(pos.y - enemy2.pos.y)+sq(pos.z - enemy2.pos.z);
        if (vector!=0)
        {
          float distance = sqrt(vector);
          if (distance < minimumGetAwayDistance)
          {
            if (distance < closestDistance)
            {
              closestDistance = distance;
              closestEnemy = i;
              socialDistancing = true;
            }
          }
        }
      }
      
      if (socialDistancing) // Solo hacemos que no se toquen si es que hay alguno que este suficientemente cerca
      {
        Enemy enemy2 = arrayEnemies.get(closestEnemy);
        calculatedVector = calculateUnitVector(enemy2.pos, pos);
      }
      //Si una particula esta muy cerca de otra, esta devolvera un vector en direccion contraria, si no hay ninguna, devuelve 0
    }
    return calculatedVector;
  }

  void updateId(int id) //Actualiza el identificador de cada particula
  {
    idNumber = id;
  }

  void newRandomPosition() //Calcula una posicion aleatoria en la que se dirigir la particula. Si llega, le otorga otra.
  {
    float vector = sq(pos.x - randomMovementPosition.x)+sq(pos.y - randomMovementPosition.y)+sq(pos.z - randomMovementPosition.z);
    
    if (vector != 0)
    {
      float distance = sqrt(vector);
      if (distance < minimumDistance)
      {
        randomMovementPosition = calculateRandomPosition();
      }
    } else
    {
      randomMovementPosition = calculateRandomPosition();
    }
  }

  PVector calculateNearParticleVector() //Detecta si hay una particula de virus dentro de su rango y devuelve su vector unitario
  {
    PVector calculatedVector;
    calculatedVector = new PVector(0.0, 0.0, 0.0);

    int closestAvatar = 0;
    float minimumGetAwayDistance = enemySize * 5;
    float closestDistance = minimumGetAwayDistance;
    boolean socialDistancing = false;

    //Se suman las posiciones de todos los avatares
    for (int i = arrayAvatar.size(); i-- > 0; )
    {
      particula avatar = arrayAvatar.get(i);
      float vector = sq(pos.x - avatar.pos.x)+sq(pos.y - avatar.pos.y)+sq(pos.z - avatar.pos.z);

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
          }
        }
      }
    } 
    
    if (socialDistancing) // Solo hacemos que no se toquen si es que hay alguno que este suficientemente cerca
    {
      particula avatar = arrayAvatar.get(closestAvatar);
      calculatedVector = calculateUnitVector(pos, avatar.pos);
    }

    //Si un pajaro esta muy cerca de otro, este devolvera un vector en direccion contraria, si no hay ninguno, simplemente devuelve 0
    return calculatedVector;
  }
}
