class particula{
  //Atributos
  PVector pos, vel, acel;
  float masa, tamanyo;
  color color_p;  
  //Constructor
  particula(PVector p, PVector v, float m, float t, color c){
    pos = new PVector();
    vel = new PVector();
    acel = new PVector();
    pos = p;
    vel = v; 
    masa = m;
    tamanyo = t;
    color_p = c;
  }
  //Metodos
  void muevete(){ //El solver, un Euler
    //1- Aceleración
    acel.x = 0.0; //Solamente hay gravedad
    acel.y = 9.8 / masa; //Solamente hay gravedad
    
    //2- Velocidad
    vel.x = vel.x + acel.x * inc_t;
    vel.y = vel.y + acel.y * inc_t;
    
    //Posición
    pos.x = pos.x + vel.x * inc_t;
    pos.y = pos.y + vel.y * inc_t;
  }
  
  void pintate(){
    fill(color_p);
    ellipse(pos.x, pos.y, tamanyo, tamanyo);
  }
}
