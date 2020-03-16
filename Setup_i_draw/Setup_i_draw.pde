//Mi primer motor de físicas
//Con dos particulas! estilo de fuegos artificiales con solo gravedad.

//Variables
float x1, y1, vx1, vy1, x2, y2, vx2, vy2;
float m1, m2, t1, t2;
float incremento_t;
boolean acercandote;

//ESTE COMENTARIO

//SETUP
void setup()
{
  size(1000,800,P3D);
  //Llamar al constructor de las particulas!
  //100 particulas
  for (int i = 0; i < numObjects; i++){
    particulaArray[i] = new particula(new PVector(500, height/2, 0), new PVector(random(-50, 50), random(-10, -50), random(-10, 10)), 1.0, random(5.0, 40.0), color(random(100, 255)));
  }
  //Inicializamos el incremento de tiempo
  inc_t = 0.04;
}

void draw(){
  background(0);
  moveObject();
}

/*void objectCollisionScreen() 
{
  if (player.x < playerDimension/2)
    player.x = playerDimension/2;

  if (player.x > (width - playerDimension/2))
    player.x = (width - playerDimension/2);

  if (player.y < playerDimension/2)
    player.y = playerDimension/2;

  if (player.y > (height - playerDimension/2))
    player.y = (height - playerDimension/2);
}*/

//Draw
void moveObject()
{ 
 for (int i = 0; i < numObjects; i++){
   //A mover
   particulaArray[i].muevete();
   //A pintar
   particulaArray[i].pintate();
 }
}
