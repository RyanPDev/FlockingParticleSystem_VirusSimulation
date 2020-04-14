//Zona de Clases
class Enemy {

  PVector pos, vel, rotation;
  int idNumber;
  // KL = Seguimiento de lider; 
  // KB = Acercamiento a la bandada; 
  // KM = acercamiento a la meta
  float mass, size, KM,KB,KA, minimumDistance; 
  color colorP;
  PVector randomMovementPosition;
  
  float speedLimit = 2;

  float randomConstantCurrentTime;
  float randomConstantTotalTime;

  Enemy(PVector p, PVector v, float m, float t, color c, int id)
  {
    pos = p;
    vel = v;
    mass = m;
    size = t;
    colorP = c;
    idNumber = id;
    rotation = new PVector(35.26, -45, 0);
    
    
    KM = 1;
    KB = 2;
    KA = 4;
    
   minimumDistance = size * 1.3;

    randomMovementPosition = new PVector(0, 0, 0);
    randomMovementPosition = calculateRandomPosition();
    
    randomConstantCurrentTime = 0;
    randomConstantTotalTime = 5000; // 5 segundos
  
  }
  // METODOS
  void move() //SOLVER (motor de inferencia numerica) Empleamos un EULER
  {
    // 1- Fuerza y Aceleracion
    PVector acel, getAwayVector, randomVector, particleVector;
    acel = new PVector(0.0, 0.0, 0.0);
    particleVector = new PVector(0.0, 0.0, 0.0);
    getAwayVector = new PVector(0.0, 0.0, 0.0);
    randomVector = new PVector(0.0, 0.0, 0.0);
    //Si soy lider voy a la meta
  
    
      
    if(randomMode)
      randomConstant(); // Randomiza las constantes de los bichos cada 3 segundos
    newRandomPosition();
    randomVector = calculateUnitVector(pos, randomMovementPosition);
    particleVector = calculateNearParticleVector();
     
    //getAwayVector = calculateNearParticleVector();
    // MEDIA PONDERADA

    acel.x += KM * randomVector.x + KB * particleVector.x + KA * getAwayVector.x;
    acel.y += KM * randomVector.y + KB * particleVector.y + KA * getAwayVector.y;
    acel.z += KM * randomVector.z + KB * particleVector.z + KA * getAwayVector.z;
    
    
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

  void randomConstant() //////////////////////////
  {
  /*if (millis() - randomConstantCurrentTime >= randomConstantTotalTime)
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
    }*/
  }

  void drawParticle()
  {

    pushMatrix(); // Salvo el estado

    translate(pos.x, pos.y, pos.z);

    
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
  
  void newRandomPosition()
  {
    float vector = sq(pos.x - randomMovementPosition.x)+sq(pos.y - randomMovementPosition.y)+sq(pos.z - randomMovementPosition.z);
     if(vector != 0)
     {
       float distance = sqrt(vector);
        if (distance < minimumDistance)
        {
          randomMovementPosition = calculateRandomPosition();
        }
     }
     else
     {
       randomMovementPosition = calculateRandomPosition();
     }
  }
  
  PVector calculateNearParticleVector()
{
  PVector calculatedVector;
  calculatedVector = new PVector(0.0, 0.0, 0.0);
  
  int closestAvatar = 0;
  float minimumGetAwayDistance = enemySize * 5;
  float closestDistance = minimumGetAwayDistance;
  boolean socialDistancing = false;

  //Se suman las posiciones de todos los avatares
  
  for (int i = 0; i < particulaArray.length; i++) /////////////////////////////////////////////////////////
  {
    float vector = sq(pos.x - particulaArray[i].pos.x)+sq(pos.y - particulaArray[i].pos.y)+sq(pos.z - particulaArray[i].pos.z);
    
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
  
  
  if(socialDistancing) // Solo hacemos que no se toquen si es que hay alguno que este suficientemente cerca
  {
      calculatedVector = calculateUnitVector(pos, particulaArray[closestAvatar].pos);
  }

  //Si un pajaro esta muy cerca de otro, este devolvera un vector en direccion contraria, si no hay ninguno, simplemente devuelve 0

  return calculatedVector;
}
}
