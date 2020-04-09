import peasy.*;

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
    PeasyCam cam;
    
    long animationTimeInMillis;
    
    // DEBERIA SER UN PVector worldBoundary y no 3 floats, que soy imbecil y me da palo cambiar todo el codigo;
    float worldBoundaryX;
    float worldBoundaryY;
    float worldBoundaryZ;
    
     enum Phase {STARTING, SIMULATION, PAUSE}; // Enumerador con los diferentes estados de la partida
     Phase gamePhase; // La fase actual en la que se encuentra el juego
     Phase auxiliarPhase; // Variable que guarda la fase en la que el jugador se encuentra cuando le da al pause
     
     
     enum CamPhase {CENTERWORLD, GOAL, LEADER}; // Enumerador con los diferentes estados de la partida
     CamPhase cameraPhase; // La fase actual en la que se encuentra el juego
     boolean cameraFollowGoal = false;
     boolean isPaused = false; // Variable de control para controlar el flujo de codigo cuando el juego está pausado
     
     
     float goalSize;

//Zona de SetUp
void setup()
{
   gamePhase = Phase.STARTING;
   size(1000,700,P3D);
   
   worldBoundaryX = 400;
   worldBoundaryY = 400;
   worldBoundaryZ = 500;
   
   animationTimeInMillis = 1000;
   cam = new PeasyCam(this, 640);
   cam.setMinimumDistance(50);
   cam.setMaximumDistance(800);
   
   cameraPhase = CamPhase.CENTERWORLD;
   updateCameraLookAt();
   background(255);
   //lights();
   // LLamo a los constructores de las particulas
   // Lider
   particulaArray[0] = new particula(new PVector (0.0,0.0,0.0),new PVector (0.0,0.0,0.0), 1.0, 20.0, color(255,255,0),1);
   // Avatares
   for (int i = 1; i < 10; i++)
   {
     //new PVector (10.0,height/2.0,-10.0) posicion que habia antes del random
     particulaArray[i] = new particula(
     new PVector (random(0,worldBoundaryX),random(0,worldBoundaryY),random(0,worldBoundaryZ)),
     new PVector (random(-10.0, 10.0),random(-10.0, 10.0),random(-10.0, 10.0)),
     1.0, 
     random(5.0,15.0), 
     color(0,random(255),0),
     0);
   }
   //Inicializar ciertos valores
   
   pos_meta = new PVector(0, 0, 0);
   randomMetaPosition();
   pos_lider = new PVector(0.0,0.0,0.0);
   inc_t = 0.5;
   updateCameraLookAt();
   
   isPaused = false;
   gamePhase = Phase.SIMULATION;
   
   goalSize = 30;
   
}
//Zona de Draw
void draw()
{
  
  
    background(255);
    drawWorldBoundaries();
    //pintarSuelo();
    // Render de la escena (Calcular posiciones primero para pintar despues)
    
    //isometricViewOn();
    for (int i = 0; i<10; i++) /////////////////////////////////////////////////////////
    {
        // Calcular
        if(gamePhase == Phase.SIMULATION)
        {
            particulaArray[i].muevete();
        }
        // Dibujar
        particulaArray[i].pintate();
    }
    pintar_la_meta();
    collisionCircleRectangle();
    //isometricViewOff();
  
  
  
}
