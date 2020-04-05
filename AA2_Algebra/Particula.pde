//Zona de Clases
class particula {
 
  PVector pos,vel,rotation;
  // KL = Seguimiento de lider; 
  // KB = Acercamiento a la bandada; 
  // KM = acercamiento a la meta
  float masa, tamanyo, KL,KB,KM; 
  color color_p;
  int lider; // Yo lo pondria booleano (1 si soy lider, 0 si no lo soy)
  float limiteDeVelocidad = 5;
  
  particula(PVector p, PVector v, float m, float t, color c, int l)
  {
      pos = p;
      vel = v;
      masa = m;
      tamanyo = t;
      color_p = c;
      lider = l;
      rotation= new PVector(35.26,-45,0);
      //Estas 3 deberia de sumar 1 para que fuera fisicamente correcto (la suma de las K's da 1 (el 100%)
      KL = random(0,1); // Lider
      KB = random(KL,1); // Bandada
      KM = 1-KB;  // Meta
      
      if(lider == 1)
      {
        KM = 1;
        
      }
  }
  // METODOS
  void muevete() //SOLVER (motor de inferencia numerica) Empleamos un EULER
  {
    // 1- Fuerza y Aceleracion
    PVector acel, vector_meta, vector_lider, vector_bandada;
    acel = new PVector(0.0,0.0,0.0);
    vector_meta = new PVector(0.0,0.0,0.0);
    vector_lider = new PVector(0.0,0.0,0.0);
    vector_bandada = new PVector(0.0,0.0,0.0);
    
    //Si soy lider voy a la meta
    if(lider==1)
    {
      
      vector_meta = calcula_vector_unitario(pos, pos_meta);
      acel.x += KM * vector_meta.x;
      acel.y += KM * vector_meta.y;
      acel.z += KM * vector_meta.z;
      
      
      
    }
    else // sino voy a seguir al lider y a ir a la meta y no alejarme de la bandada
    {
      
      vector_meta = calcula_vector_unitario(pos, pos_meta);
      
      vector_lider = calcula_vector_unitario(pos, pos_lider);
      
      vector_bandada = calcula_vector_unitario(pos, dime_centro_bandada()); //promedio de posiciones de avatares
      
      // MEDIA PONDERADA
      
      acel.x += KM * vector_meta.x + KL * vector_lider.x + KB * vector_bandada.x;
      acel.y += KM * vector_meta.y + KL * vector_lider.y + KB * vector_bandada.y;
      acel.z += KM * vector_meta.z + KL * vector_lider.z + KB * vector_bandada.z;
      
    }
    // NEWTON Suma Fuerzas = masa x Aceleracion
    acel.x /= masa;
    acel.y /= masa;
    acel.z /= masa;
    
    // 2- Velocidad
    
    vel.x = vel.x + acel.x * inc_t;
    vel.y = vel.y + acel.y * inc_t;
    vel.z = vel.z + acel.z * inc_t;
    
    if(vel.x > limiteDeVelocidad)
    {
       vel.x = limiteDeVelocidad; 
    }
    else if(vel.x < -limiteDeVelocidad)
    {
       vel.x = -limiteDeVelocidad; 
    }
    if(vel.y > limiteDeVelocidad)
    {
       vel.y = limiteDeVelocidad; 
    }
    else if(vel.y < -limiteDeVelocidad)
    {
       vel.y = -limiteDeVelocidad; 
    }
    if(vel.z > limiteDeVelocidad)
    {
       vel.z = limiteDeVelocidad; 
    }
    else if(vel.z < -limiteDeVelocidad)
    {
       vel.z = -limiteDeVelocidad; 
    }
    
    println(vel.x,vel.y,vel.z);
    
    
    // 3- Posicion
    
    pos.x = pos.x + vel.x * inc_t;
    pos.y = pos.y + vel.y * inc_t;
    pos.z = pos.z + vel.z * inc_t;
    
    //salvar posicion lider
    if(lider == 1)
    {
       pos_lider.x = pos.x;
       pos_lider.y = pos.y; 
       pos_lider.z = pos.z; 
    }
    
  }
  
  
  
  
  void pintate()
  {
    
    pushMatrix(); // Salvo el estado
    
    translate(pos.x, pos.y, pos.z);
    
    rotateX(radians(-35.26));
    rotateY(radians(-45));
    
   // rotate(radians(rotation.x),radians(rotation.y),radians(rotation.z),0);
    /// FUNCION QUE ROTE EL MONIGOTE
    
    //fill(color_p);
    stroke(color_p);
    strokeWeight(1);
    
    sphere(30);
    
    strokeWeight(5);
   //Eje X
   stroke(255,0,0);
   line(0,0,0,100,0,0);
   
   //Eje Y
   stroke(0,255,0);
   line(0,0,0,0,-100,0);
   
    //Eje Z
   stroke(0,0,255);
   line(0,0,0,0,0,100);
    
    popMatrix();
  }
}
