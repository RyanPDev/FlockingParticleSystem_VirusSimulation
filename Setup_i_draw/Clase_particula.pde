class particula{
  //Atributos
  PVector pos, vel, acel;
  float masa, tamanyo;
  color color_p;  
  //Constructor
  particula(PVector p, PVector v, float m, float t, color c){
    pos = new PVector();
    acel = new PVector();
    vel = new PVector();
    vel = v;
    pos = p;
    masa = m;
    tamanyo = t;
    color_p = c;
  }
  //Metodos
  void muevete(){ //El solver, un Euler
    
    //1- Aceleración
    acel.x = 0.0; //Solamente hay gravedad
    acel.y = 0.0; //Solamente hay gravedad
    acel.z = 0.0;
    
    //2- Velocidad
    vel.x = vel.x + acel.x * inc_t;
    vel.y = vel.y + acel.y * inc_t;
    vel.z = vel.z + acel.z * inc_t;
    
    //3- Posición
    pos.x = pos.x + vel.x * inc_t;
    pos.y = pos.y + vel.y * inc_t;
    pos.z = pos.z + vel.z * inc_t;
  }
  
  void pintate(){
    fill(color_p);
    translate(pos.x, pos.y, pos.z);
    box(tamanyo);
  }
}
