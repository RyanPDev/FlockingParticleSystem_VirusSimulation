//Mi primer motor de físicas
//Con dos particulas! estilo de fuegos artificiales con solo gravedad.

//Variables
float x1, y1, vx1, vy1, x2, y2, vx2, vy2;
float m1, m2, t1, t2;
float incremento_t;

//SETUP
void setup()
{
  size(800, 600);
  //Llamar al constructor de las particulas!
  //100 particulas
  for (int i = 0; i < numEnemies; i++){
    particulaArray[i] = new particula(new PVector(width/2.0, height/2.0), new PVector(random(-50.0, 50.0), random(-70.0, -10.0)), 1.0, random(5.0, 40.0), color(random(0, 255)));
  }
  
  //Inicializamos el incremento de tiempo
  inc_t = 0.04;
  
  /*
 //size(400, 300);
 fullScreen();
 //Inicializaciones
 //La particula sale en el centro y se mueve hacia arriba - izquierda.
 //La segunda partícula sale en el centro y se mueve hacia arriba - derecha.
 //Las massas van a ser las dos de 1kg.
 x1 = width/2.0; //Metros
 y1 = height/2.0;
 vx1 = -10.0; //Metros/segundo
 vy1 = -20.0;
 x2 = width/2.0;
 y2 = height/2.0;
 vx2 = 25.0;
 vy2 = -15.0;
 m1 = 1.0; //Kg
 m2 = 1.0;
 t1 = 30.0;
 t2 = 45.0;
 incremento_t = 0.04; //Segundos*/
}

//Draw
void draw()
{
 background(0);
 
 for (int i = 0; i < numEnemies; i++){
   //A mover
   particulaArray[i].muevete();
   //A pintar
   particulaArray[i].pintate();
 }
 
 /*
 //Primero se actualizan los valores de todo.
 //Bienvenido sea el SOLVER EULER
 //1 - Aceleración:
 //a = sumatorio F/m (Newton)
 float ax1, ay1, ax2, ay2;
 float fx, fy;
 fx = 0.0;
 fy = 9.8; //Fuera de la gravedad en la tierra = -9.8; En processing los ejes estan invertidos.
 ax1 = fx / m1;
 ay1 = fy / m1;
 ax2 = fx / m2;
 ay2 = fy / m2; 
 
 //2 - Velocidades:
 vx1 = vx1 + ax1 * incremento_t;
 vy1 = vy1 + ay1 * incremento_t;
 vx2 = vx2 + ax2 * incremento_t;
 vy2 = vy2 + ay2 * incremento_t;
 
 //3 - Posiciones:
 x1 = x1 + vx1 * incremento_t;
 y1 = y1 + vy1 * incremento_t;
 x2 = x2 + vx2 * incremento_t;
 y2 = y2 + vy2 * incremento_t;
 
 //Segundo se pintan las partículas.
 noFill();
 stroke(255, 0, 0);
 ellipse(x1, y1, t1, t1);
 stroke(0, 255, 0);
 ellipse(x2, y2, t2, t2);*/
}
