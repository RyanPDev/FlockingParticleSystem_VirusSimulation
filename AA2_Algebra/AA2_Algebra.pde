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

particula[] particulaArray = new particula[100];
//Delta tiempo
float inc_t;
//Posiciones de la meta y el avatar lider
PVector pos_meta, pos_lider;
float liderSize, liderInitialSpeed;


// DEBERIA SER UN PVector worldBoundary y no 3 floats, que soy imbecil y me da palo cambiar todo el codigo, de momento no lo cambies, ya encontrare el momento;
float worldBoundaryX;
float worldBoundaryY;
float worldBoundaryZ;

enum Phase {
  STARTING, SIMULATION, PAUSE
}; // Enumerador con los diferentes estados de la partida
Phase gamePhase; // La fase actual en la que se encuentra el juego
Phase auxiliarPhase; // Variable que guarda la fase en la que el jugador se encuentra cuando le da al pause

PeasyCam cam;
long animationTimeInMillis; // Tiempo que tarda la camara en alcanzar el objetivo a mirar
enum CamPhase {
  CENTERWORLD, GOAL, LEADER
}; // Enumerador con los diferentes estados de la camara
CamPhase cameraPhase; // La fase actual de la camara en la que se encuentra el juego
boolean cameraFollowGoal = false;
boolean isPaused = false; // Variable de control para controlar el flujo de codigo cuando el juego está pausado

boolean showControls;
float goalSize; // Tamaño del cubo que es la meta

//Timers

float randomPositionCurrentTime;
float randomPositionTotalTime;


float mosquitoSize;
float mosqueenSize;



//Zona de SetUp
void setup()
{
  gamePhase = Phase.STARTING; // DE MOMENTO NO TIENE USO COMO TAL, PERO PUEDE LLEGAR A TENERLO
  size(1000, 700, P3D);

  worldBoundaryX = 1000;
  worldBoundaryY = 1000;
  worldBoundaryZ = 1500;

  animationTimeInMillis = 1000;
  cam = new PeasyCam(this, 640);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(1800);

  cameraPhase = CamPhase.CENTERWORLD;
  updateCameraLookAt();
 
  //lights();
  // LLamo a los constructores de las particulas
  // Lider
 
  // Mosquitos
  
  mosquitoSize = random(10.0, 15.0);
  mosqueenSize = 18;
  
  particulaArray[0] = new particula(new PVector (0.0, 0.0, 0.0), new PVector (0.0, 0.0, 0.0), 1.0, mosqueenSize, color(255, 255, 0), 1, 0);
  for (int i = 1; i < particulaArray.length; i++)
  {
    //new PVector (10.0,height/2.0,-10.0) posicion que habia antes del random
    particulaArray[i] = new particula(
      new PVector (random(0, worldBoundaryX), random(0, worldBoundaryY), random(0, worldBoundaryZ)), 
      new PVector (random(-10.0, 10.0), random(-10.0, 10.0), random(-10.0, 10.0)), 
      1.0, 
      mosquitoSize, 
      color(0, random(255), 0), 
      0, i);
  }
  //Inicializar ciertos valores

  pos_meta = new PVector(0, 0, 0);
  pos_meta = randomPosition();
  pos_lider = new PVector(0.0, 0.0, 0.0);
  inc_t = 0.4;
  updateCameraLookAt();

  isPaused = false;
  gamePhase = Phase.SIMULATION;

  showControls = false;

  goalSize = 30;


  randomPositionTotalTime = 3000; // 3 segundos
  randomPositionCurrentTime = 0;
}
//Zona de Draw
void draw()
{


  background(255);
  drawWorldBoundaries(); // DIBUJA EL CUBO QUE REPRESENTA LOS LIMITES DEL MUNDO
  //pintarSuelo();
  // Render de la escena (Calcular posiciones primero para pintar despues)


  for (int i = 0; i < particulaArray.length; i++) /////////////////////////////////////////////////////////
  {
    // Calcular
    if (gamePhase == Phase.SIMULATION)
    {
      particulaArray[i].muevete();
    }
    // Dibujar
    particulaArray[i].pintate();
  }
  pintar_la_meta();
  collisionCircleRectangle();

  drawHUD();
}
