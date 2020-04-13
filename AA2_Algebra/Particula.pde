//Zona de Clases
class particula {

  PVector pos, vel, rotation;
  int idNumber;
  // KL = Seguimiento de lider; 
  // KB = Acercamiento a la bandada; 
  // KM = acercamiento a la meta
  float mass, size, KL, KB, KM, KA, KR; 
  color colorP;
  PVector randomMovementPosition;
  int leader; // Yo lo pondria booleano (1 si soy lider, 0 si no lo soy)
  float speedLimit = 2.5;

  float randomConstantCurrentTime;
  float randomConstantTotalTime;

  particula(PVector p, PVector v, float m, float t, color c, int l, int id)
  {
    pos = p;
    vel = v;
    mass = m;
    size = t;
    colorP = c;
    leader = l;
    idNumber = id;
    rotation = new PVector(35.26, -45, 0);
    //Estas 3 deberia de sumar 1 para que fuera fisicamente correcto (la suma de las K's da 1 (el 100%)
    KL = random(0, 1); // Lider
    KM = random(0, 1-KL);  // Meta
    KB = 1-(KM+KL); // Bandada

    KA = 2.0; // Constante que evita el choque (es muy alta pero es para priorizarla siempre ante las demas para evitar el choque)

    randomMovementPosition = new PVector(0, 0, 0);
    randomConstantCurrentTime = 0;
    randomConstantTotalTime = 5000; // 5 segundos
    if (leader == 1)
    {
      speedLimit = speedLimit*2;
      KR = 0.35;
      KM = 1- KR;
      //leaderSize = t;
    }
  }
  // METODOS
  void move() //SOLVER (motor de inferencia numerica) Empleamos un EULER
  {
    // 1- Fuerza y Aceleracion
    PVector acel, goalVector, leaderVector, flockVector, getAwayVector, randomVector;
    acel = new PVector(0.0, 0.0, 0.0);
    goalVector = new PVector(0.0, 0.0, 0.0);
    leaderVector = new PVector(0.0, 0.0, 0.0);
    flockVector = new PVector(0.0, 0.0, 0.0);
    getAwayVector = new PVector(0.0, 0.0, 0.0);
    randomVector = new PVector(0.0, 0.0, 0.0);
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
      
      
      if(randomMode)
        randomConstant(); // Randomiza las constantes de los bichos cada 3 segundos

      goalVector = calculateUnitVector(pos, posGoal);

      leaderVector = calculateUnitVector(pos, posLeader);

      flockVector = calculateUnitVector(pos, calculateFlockCenter()); //promedio de posiciones de avatares

      getAwayVector = calculateAvatarVector(idNumber);
      // MEDIA PONDERADA

      acel.x += KM * goalVector.x + KL * leaderVector.x + KB * flockVector.x + KA * getAwayVector.x;
      acel.y += KM * goalVector.y + KL * leaderVector.y + KB * flockVector.y + KA * getAwayVector.y;
      acel.z += KM * goalVector.z + KL * leaderVector.z + KB * flockVector.z + KA * getAwayVector.z;
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
    
    if(pos.x > worldBoundaryX - size)
    {
       pos.x = worldBoundaryX - size; 
    }
    else if(pos.x < 0 + size)
    {
       pos.x = 0 + size;
    }
    if(pos.y > worldBoundaryY - size)
    {
       pos.y = worldBoundaryY - size; 
    }
    else if(pos.y < 0 + size)
    {
       pos.y = 0 + size;
    }
    if(pos.z > worldBoundaryZ - size)
    {
       pos.z = worldBoundaryZ - size; 
    }
    else if(pos.z < 0 + size)
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

  void randomConstant()
  {
    if (millis() - randomConstantCurrentTime >= randomConstantTotalTime)
    {
      KL = random(0, 1); // Lider
      KM = random(0, 1-KL);  // Meta
      KB = 1-(KM+KL); // Bandada
      randomConstantCurrentTime = millis();
      if (idNumber == 1)
      {
        //println(KL);
       // println(KM);
        //println(KB);
        println("CAMBIO");
      }
    }
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
