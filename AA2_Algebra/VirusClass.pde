//Zona de Clases
class particula {

  PVector pos, vel;
  int idNumber;
  // KL = Seguimiento de lider; 
  // KB = Acercamiento a la bandada; 
  // KM = acercamiento a la meta
  // KA = Para no chocar entre particulas iguales
  // KE = Escapar de las particulas enemigas
  // KR = Intención para el movimiento random (lider)
  // KF = Para dirigirse a las celulas vulnerables y infectarlas
  float mass, size, KL, KB, KM, KA, KR, KF, KE, rotation; 
  boolean isInDanger = false;
  boolean isCloseToLeader = false;
  color colorP;
  PVector randomMovementPosition;
  int leader; //1 si soy lider, 0 si no lo soy
  float nonLeaderSpeedLimit = 2.5;
  float speedLimit = nonLeaderSpeedLimit;
  float spikyLength;
  float leaderSpeedLimit = nonLeaderSpeedLimit * 1.5;
  float randomConstantCurrentTime;
  float randomConstantTotalTime;
  float rotationTimer;
  float rotationCurrentTime;

  particula(PVector p, PVector v, float m, float t, color c)
  {
    pos = p;
    vel = v;
    mass = m;
    size = t;
    colorP = c;
    rotation = 0;

    //la suma de las K's da 1 (el 100%)
    leader = 0; // No es lider al nacer 
    KL = random(0.3, 0.5);
    KM = random(0.2, 0.4);
    KB = 1-(KM+KL);
    KA = 2.0; // Constante que evita el choque (es muy alta pero es para priorizarla siempre ante las demas para evitar el choque)
    KF = 1.5; //Intencion de food
    KE = 0; // Intencion de escapar de enemigos
    spikyLength = size * 1.2; // Longitud de los "pinchitos" del coronavirus
    randomMovementPosition = new PVector(0, 0, 0);
    randomConstantCurrentTime = 0;
    randomConstantTotalTime = 5000; //5 segundos
    rotationTimer = 0.5;
    rotationCurrentTime = 0;
  }
  // METODOS
  void move() //SOLVER (motor de inferencia numerica) Empleamos un EULER
  {
    // 1- Fuerza y Aceleracion
    PVector acel, goalVector, leaderVector, flockVector, getAwayVector, randomVector, foodVector, enemyVector;
    acel = new PVector(0.0, 0.0, 0.0);
    goalVector = new PVector(0.0, 0.0, 0.0);
    leaderVector = new PVector(0.0, 0.0, 0.0);
    flockVector = new PVector(0.0, 0.0, 0.0);
    getAwayVector = new PVector(0.0, 0.0, 0.0);
    randomVector = new PVector(0.0, 0.0, 0.0);
    foodVector = new PVector(0.0, 0.0, 0.0);
    enemyVector = new PVector(0.0, 0.0, 0.0);


    if (leader==1)
    {
      randomMovementPosition = randomMovementDirection(randomMovementPosition);

      randomVector = calculateUnitVector(pos, randomMovementPosition);
      goalVector = calculateUnitVector(pos, posGoal);
      enemyVector = calculateNearEnemyVector();
      if (!isInDanger)
        foodVector = calculateNearFoodVector();
      acel.x += KM * goalVector.x + KR * randomVector.x + KF * foodVector.x + KE * enemyVector.x;
      acel.y += KM * goalVector.y + KR * randomVector.y + KF * foodVector.x + KE * enemyVector.y;
      acel.z += KM * goalVector.z + KR * randomVector.z + KF * foodVector.x + KE * enemyVector.z;
    } else //Sino voy a seguir al lider y a ir a la meta y no alejarme de la bandada
    {
      if (randomMode)
        randomConstant(); // Randomiza las constantes de los bichos cada 3 segundos

      goalVector = calculateUnitVector(pos, posGoal); //--> Pestaña IntentionCalculation

      leaderVector = calculateUnitVector(pos, posLeader); //--> Pestaña IntentionCalculation

      flockVector = calculateUnitVector(pos, calculateFlockCenter()); //--> Pestaña IntentionCalculation

      getAwayVector = calculateAvatarVector(idNumber); //--> Pestaña IntentionCalculation

      if (!isInDanger)
        foodVector = calculateNearFoodVector();

      enemyVector = calculateNearEnemyVector(); 
      // MEDIA PONDERADA

      acel.x += KM * goalVector.x + KL * leaderVector.x + KB * flockVector.x + KA * getAwayVector.x + KF * foodVector.x + KE * enemyVector.x;
      acel.y += KM * goalVector.y + KL * leaderVector.y + KB * flockVector.y + KA * getAwayVector.y + KF * foodVector.y + KE * enemyVector.y;
      acel.z += KM * goalVector.z + KL * leaderVector.z + KB * flockVector.z + KA * getAwayVector.z + KF * foodVector.z + KE * enemyVector.z;
    }
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

    //Salvar posicion lider
    if (leader == 1)
    {
      posLeader.x = pos.x;
      posLeader.y = pos.y; 
      posLeader.z = pos.z;
    }
  }

  void drawRandomDirection() //Dibuja la meta en una posicion aleatorio
  {
    pushMatrix();
    translate(posGoal.x + (goalSize / 2), posGoal.y + (goalSize / 2), posGoal.z + (goalSize / 2));
    strokeWeight(8);
    stroke(255, 215, 0);
    noFill();
    box(goalSize);
    popMatrix();
  }

  void turnIntoLeader() //Convierte en lider a la particula
  {
    if (leader != 1)
    {
      leader = 1;
      size = leaderSize;
      colorP = color (255, 255, 0);
      speedLimit = leaderSpeedLimit;
      KR = 0.25;
      KM = 1- KR;
      spikyLength = size * 1.2;
      posLeader.x = pos.x;
      posLeader.y = pos.y; 
      posLeader.z = pos.z;
    }
  }
  
  void updateId(int id) //Actualiza el identificador de cada particula
  {
    idNumber = id;
  }
  
  void randomConstant() //Randomiza cada 5 segundos las intenciones de las particulas
  {
    if (millis() - randomConstantCurrentTime >= randomConstantTotalTime)
    {
      KL = random(0, 1); // Lider
      KM = random(0, 1-KL);  // Meta
      KB = 1-(KM+KL); // Bandada
      randomConstantCurrentTime = millis();
    }
  }

  void collisionParticleFood() //Detecta la colision entre la particula y cada celula vulnerable
  {
    if (arrayVulnerableCell.size() != 0)
    {
      for (int i = arrayVulnerableCell.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
      {
        Food food = arrayVulnerableCell.get(i);
        float vector = sq(food.pos.x - pos.x)+sq(food.pos.y - pos.y)+sq(food.pos.z - pos.z);
        if (vector!=0)
        {
          float distance = sqrt(vector);
          if (distance <= size + food.size)
          {
            createAvatar(food.pos); // --> Pestaña VirusFunctions
            eraseVulnerableCell(i);
          }
        }
      }
    }
  }
  
  void collisionParticleEnemy() //Detecta la colision entre la particula y las celulas immunologicas
  {
    if (arrayEnemies.size() != 0)
    {
      for (int i = arrayEnemies.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
      {
        Enemy enemy = arrayEnemies.get(i);
        float vector = sq(enemy.pos.x - pos.x)+sq(enemy.pos.y - pos.y)+sq(enemy.pos.z - pos.z);
        if (vector!=0)
        {
          float distance = sqrt(vector);
          if (distance <= size + enemy.size)
          {
            eraseAvatar(idNumber); //--> Pestaña VirusFunctions
          }
        }
      }
    }
  }

  PVector calculateNearEnemyVector() //Detecta si hay una celula immunologica dentro de su rango y devuelve su vector unitario
  {
    PVector calculatedVector;
    calculatedVector = new PVector(0.0, 0.0, 0.0);

    int closestEnemy = 0;
    float enemyTrackingRange = enemySize * 4;
    float alarmingRange = enemySize + (size*2);
    float closestDistance = enemyTrackingRange;
    boolean socialDistancing = false;

    //Se suman las posiciones de todos los avatares
    if (arrayEnemies.size() != 0)
    {
      for (int i = arrayEnemies.size(); i-- > 0; )
      {
        Enemy enemy = arrayEnemies.get(i);
        float vector = sq(enemy.pos.x - pos.x)+sq(enemy.pos.y - pos.y)+sq(enemy.pos.z - pos.z);

        if (vector!=0)
        {
          float distance = sqrt(vector);
          if (distance < enemyTrackingRange)
          {
            if (!isInDanger)
              KE = 0.5;
            if (distance < closestDistance)
            {
              closestDistance = distance;
              closestEnemy = i;
              socialDistancing = true;
            }
          }
          if (distance < alarmingRange && !isInDanger)
          {
            isInDanger = true;
            KE = 3;
          }
        }
      }

      if (socialDistancing)
      {
        Enemy enemy = arrayEnemies.get(closestEnemy);
        calculatedVector = calculateUnitVector(enemy.pos, pos); //--> Pestaña IntentionCalculation
      } else if (isInDanger)
      {
        isInDanger = false;
        KE = 0;
      }
    }

    return calculatedVector;
  }

  PVector calculateNearFoodVector() //Detecta si hay una celula vulnerable dentro de su rango y devuelve su vector unitario
  {
    PVector calculatedVector;
    calculatedVector = new PVector(0.0, 0.0, 0.0);

    int closestFood = 0;
    float foodTrackingRange = size * 10;
    float closestDistance = foodTrackingRange;
    boolean socialDistancing = false;

    //Se suman las posiciones de todos los avatares
    if (arrayVulnerableCell.size() != 0)
    {
      for (int i = arrayVulnerableCell.size(); i-- > 0; )
      {
        Food food = arrayVulnerableCell.get(i);
        float vector = sq(food.pos.x - pos.x)+sq(food.pos.y - pos.y)+sq(food.pos.z - pos.z);

        if (vector!=0)
        {
          float distance = sqrt(vector);
          if (distance < foodTrackingRange)
          {
            if (distance < closestDistance)
            {
              closestDistance = distance;
              closestFood = i;
              socialDistancing = true;
            }
          }
        }
      }

      if (socialDistancing)
      {
        Food food = arrayVulnerableCell.get(closestFood);
        calculatedVector = calculateUnitVector(pos, food.pos); //--> Pestaña IntentionCalculation
      }
    }

    return calculatedVector;
  }

  void changeRotation() //Cada 0.5s actualiza la rotacion de la particula de virus
  {
    if (millis() - rotationCurrentTime >= rotationTimer)
    {
      rotationCurrentTime = millis();
      rotation ++;
      if (rotation >= 360)
      {

        rotation = 0;
      }
    }
  }

  void drawParticle() //Dibuja la particula
  {
    pushMatrix(); // Salvo el estado

    translate(pos.x, pos.y, pos.z);
    changeRotation();
    //rotateX(radians(rotation));
    rotateY(radians(rotation));
    //fill(color_p);
    fill(colorP);
    stroke(colorP);
    strokeWeight(1);

    sphere(size);
    strokeWeight(6);
    //Eje X
    stroke(colorP +100);
    drawLines();

    pushMatrix();
    rotateX(radians(90));
    drawLines();
    rotateX(radians(90));
    drawLines();
    rotateX(radians(90));
    drawLines();
    popMatrix();

    pushMatrix();
    rotateY(radians(90));
    drawLines();
    rotateY(radians(90));
    drawLines();
    rotateY(radians(90));
    drawLines();
    popMatrix();

    pushMatrix();
    rotateZ(radians(90));
    drawLines();
    rotateZ(radians(90));
    drawLines();
    rotateZ(radians(90));
    drawLines();
    popMatrix();

    popMatrix();
  }
  void drawLines() //Dibuja las linias que salen de la particula de virus para que se parezca mas al coronavirus
  {
    line(0, 0, 0, spikyLength, 0, 0);
    line(0, 0, 0, 0, -spikyLength, 0);
    line(0, 0, 0, spikyLength, spikyLength, 0);
    line(0, 0, 0, spikyLength, spikyLength, spikyLength);
    line(0, 0, 0, 0, spikyLength, 0);
    line(0, 0, 0, 0, spikyLength, spikyLength);
    line(0, 0, 0, 0, 0, spikyLength);
  }
}
