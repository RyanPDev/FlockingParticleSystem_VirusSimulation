//Zona de Clases
class particula {

  PVector pos, vel, rotation;
  int idNumber;
  // KL = Seguimiento de lider; 
  // KB = Acercamiento a la bandada; 
  // KM = acercamiento a la meta
  float mass, size, KL, KB, KM, KA, KR, KF; 
  color colorP;
  PVector randomMovementPosition;
  int leader; // Yo lo pondria booleano (1 si soy lider, 0 si no lo soy)
  float speedLimit = 2.5;
  float leaderSpeedLimit = speedLimit * 1.5;
  float randomConstantCurrentTime;
  float randomConstantTotalTime;

  particula(PVector p, PVector v, float m, float t, color c)
  {
    pos = p;
    vel = v;
    mass = m;
    size = t;
    colorP = c;

    //idNumber = id;
    rotation = new PVector(35.26, -45, 0);
    //Estas 3 deberia de sumar 1 para que fuera fisicamente correcto (la suma de las K's da 1 (el 100%)
    leader = 0; // No es lider al nacer 
    KL = random(0.3, 0.5);
    KM = random(0.2, 0.4);
    KB = 1-(KM+KL);
    KA = 2.0; // Constante que evita el choque (es muy alta pero es para priorizarla siempre ante las demas para evitar el choque)
    KF = 1.0; //Intencion de food

    randomMovementPosition = new PVector(0, 0, 0);
    randomConstantCurrentTime = 0;
    randomConstantTotalTime = 5000; // 5 segundos
  }
  // METODOS
  void move() //SOLVER (motor de inferencia numerica) Empleamos un EULER
  {

    // 1- Fuerza y Aceleracion
    PVector acel, goalVector, leaderVector, flockVector, getAwayVector, randomVector, foodVector;
    acel = new PVector(0.0, 0.0, 0.0);
    goalVector = new PVector(0.0, 0.0, 0.0);
    leaderVector = new PVector(0.0, 0.0, 0.0);
    flockVector = new PVector(0.0, 0.0, 0.0);
    getAwayVector = new PVector(0.0, 0.0, 0.0);
    randomVector = new PVector(0.0, 0.0, 0.0);
    foodVector = new PVector(0.0, 0.0, 0.0);
    //Si soy lider voy a la meta


    if (leader==1)
    {

      randomMovementPosition = randomMovementDirection(randomMovementPosition);

      randomVector = calculateUnitVector(pos, randomMovementPosition);
      goalVector = calculateUnitVector(pos, posGoal);


      acel.x += KM * goalVector.x + KR * randomVector.x;
      acel.y += KM * goalVector.y + KR * randomVector.y;
      acel.z += KM * goalVector.z + KR * randomVector.z;
    } else // sino voy a seguir al lider y a ir a la meta y no alejarme de la bandada
    {


      if (randomMode)
        randomConstant(); // Randomiza las constantes de los bichos cada 3 segundos

      goalVector = calculateUnitVector(pos, posGoal);

      leaderVector = calculateUnitVector(pos, posLeader);

      flockVector = calculateUnitVector(pos, calculateFlockCenter()); //promedio de posiciones de avatares

      getAwayVector = calculateAvatarVector(idNumber);

      foodVector = calculateNearFoodVector();
      // MEDIA PONDERADA

      acel.x += KM * goalVector.x + KL * leaderVector.x + KB * flockVector.x + KA * getAwayVector.x + KF * foodVector.x;
      acel.y += KM * goalVector.y + KL * leaderVector.y + KB * flockVector.y + KA * getAwayVector.y + KF * foodVector.y;
      acel.z += KM * goalVector.z + KL * leaderVector.z + KB * flockVector.z + KA * getAwayVector.z + KF * foodVector.z;
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

    //println(pos_lider.x,pos_lider.y,pos_lider.z);


    // 3- Posicion

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

    //salvar posicion lider
    if (leader == 1)
    {
      posLeader.x = pos.x;
      posLeader.y = pos.y; 
      posLeader.z = pos.z;
    }
  }
  
  void drawRandomDirection() // pinta la meta
  {
    pushMatrix();
    translate(posGoal.x + (goalSize / 2), posGoal.y + (goalSize / 2), posGoal.z + (goalSize / 2));
    //rotateX(radians(-35.26));
    //rotateY(radians(-45));
    strokeWeight(8);
    stroke(255, 215, 0);
    noFill();
    box(goalSize);
    popMatrix();
  }

  void turnIntoLeader()
  {
    if (leader != 1)
    {
      leader = 1;
      size = leaderSize;
      colorP = color (255, 255, 0);
      speedLimit = leaderSpeedLimit;
      KR = 0.25;
      KM = 1- KR;
      posLeader.x = pos.x;
      posLeader.y = pos.y; 
      posLeader.z = pos.z;
    }
  }
  void updateId(int id)
  {
    idNumber = id;
  }
  void randomConstant()
  {
    if (millis() - randomConstantCurrentTime >= randomConstantTotalTime)
    {
      KL = random(0, 1); // Lider
      KM = random(0, 1-KL);  // Meta
      KB = 1-(KM+KL); // Bandada
      randomConstantCurrentTime = millis();
      if (idNumber >= 1)
      {
        println("id: "+idNumber+" KL: "+KL+" KM: "+KM+" KB: "+KB);

        //println("CAMBIO");
      }
    }
  }

  void collisionParticleFood()  
  {
    if (arrayFood.size() != 0)
    {
      for (int i = arrayFood.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
      {
        Food food = arrayFood.get(i);
        float vector = sq(food.pos.x - pos.x)+sq(food.pos.y - pos.y)+sq(food.pos.z - pos.z);
        if (vector!=0)
        {
          float distance = sqrt(vector);
          if (distance <= size + food.size)
          {
            eraseFood(i);
          }
        }
      }
    }
  }

  PVector calculateNearFoodVector()
  {
    PVector calculatedVector;
    calculatedVector = new PVector(0.0, 0.0, 0.0);

    int closestFood = 0;
    float closestDistance = size * 10;
    boolean socialDistancing = false;

    //Se suman las posiciones de todos los avatares

    for (int i = arrayFood.size(); i-- > 0; )
    {
      Food food = arrayFood.get(i);
      float vector = sq(food.pos.x - pos.x)+sq(food.pos.y - pos.y)+sq(food.pos.z - pos.z);

      if (vector!=0)
      {
        float distance = sqrt(vector);
        if (distance < closestDistance)
        {
          closestDistance = distance;
          closestFood = i;
          socialDistancing = true;
        }
      }
    }
    
    if (socialDistancing)
    {
      Food food = arrayFood.get(closestFood);
      calculatedVector = calculateUnitVector(pos, food.pos);
    }

    return calculatedVector;
  }

  void drawParticle()
  {

    pushMatrix(); // Salvo el estado

    translate(pos.x, pos.y, pos.z);

    //rotateX(radians(-35.26));
    //rotateY(radians(-45));

    // rotate(radians(rotation.x),radians(rotation.y),radians(rotation.z),0);
    /// FUNCION QUE ROTE EL MONIGOTE

    //fill(color_p);
    noFill();
    stroke(colorP);
    strokeWeight(1);

    sphere(size);
    /*
    strokeWeight(5);
     //Eje X
     stroke(255, 0, 0);
     line(0, 0, 0, 100, 0, 0);
     
     //Eje Y
     stroke(0, 255, 0);
     line(0, 0, 0, 0, -100, 0);
     
     //Eje Z
     stroke(0, 0, 255);
     line(0, 0, 0, 0, 0, 100);
     */
    popMatrix();
  }
}
