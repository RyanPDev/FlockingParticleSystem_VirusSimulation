//import peasy.*;

// Un generador de intenciones
// Una simulacion automatica de avatares
// Hueristicas de moviminetos
// Una especie de cerebro
// 10 Avatares, 1 es el lider
// Reaprovechamos el codigo de sistemas de particulas
// Con Clases y Objetos
// 1 avatar = particula "pero" se mueve en base a otras leyes

//Zona de Variables y Objetos

    particula[] particulaArray = new particula[10];
    //Delta tiempo
    float inc_t;
    //Posiciones de la meta y el avatar lider
    PVector pos_meta, pos_lider;
    //PeasyCam cam;

//Zona de SetUp
void setup()
{
   size(640,380,P3D);
   /*
   cam = new PeasyCam(this, 640);
   cam.setMinimumDistance(50);
   cam.setMaximumDistance(500);
   */
   background(255);
   //lights();
   // LLamo a los constructores de las particulas
   // Lider
   particulaArray[0] = new particula(new PVector (0.0,0.0,0.0),new PVector (0.0,0.0,0.0), 1.0, 20.0, color(255,255,0),1);
   // Avatares
   for (int i = 1; i < 10; i++)
   {
     particulaArray[i] = new particula(new PVector (10.0,height/2.0,-10.0),
     new PVector (random(-10.0, 10.0),random(-10.0, 10.0),random(-10.0, 10.0)),
     1.0, 
     random(10.0,40.0), 
     color(0,random(255),0),
     0);
   }
   //Inicializar ciertos valores
   
   pos_meta = new PVector(width/2, height/2, 0);
   pos_lider = new PVector(0.0,0.0,0.0);
   inc_t = 0.5;
}
//Zona de Draw
void draw()
{
  
  //pos_meta = new PVector(mouseX, mouseY, -50.0); // ESTO HACE QUE LA META SEA TU MOUSE (mas o menos)
  
  // Fondo negro
  background(255);
  //pintarSuelo();
  // Render de la escena (Calcular posiciones primero para pintar despues)
  
  //isometricViewOn();
  
  for (int i = 0; i<10; i++) /////////////////////////////////////////////////////////
  {
      // Calcular
      particulaArray[i].muevete();
      // Dibujar
      particulaArray[i].pintate();
  }
  pintar_la_meta();
  collisionCircleRectangle();
  //isometricViewOff();
}
