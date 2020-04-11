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

//Delta tiempo
float inc_t;

//Posiciones de la meta y el avatar lider
particula[] particulaArray = new particula[10];
PVector posGoal, posLeader;
float leaderSize, leaderInitialSpeed;

//Tamaño del mundo
float worldBoundaryX;
float worldBoundaryY;
float worldBoundaryZ;

//Fases de la simulación
enum Phase {
  STARTING, SIMULATION, PAUSE
}; // Enumerador con los diferentes estados de la partida
Phase gamePhase; // La fase actual en la que se encuentra el juego
Phase auxiliarPhase; // Variable que guarda la fase en la que el jugador se encuentra cuando le da al pause
boolean isPaused = false; // Variable de control para controlar el flujo de codigo cuando el juego está pausado

//Cámara
PeasyCam cam;
enum CamPhase {
  CENTERWORLD, GOAL, LEADER
}; // Enumerador con los diferentes estados de la camara
CamPhase cameraPhase; // La fase actual de la camara en la que se encuentra el juego
boolean cameraFollowGoal = false; // Variable de control para señalar que la camara está siguiendo a la meta
long animationTimeInMillis; // Tiempo que tarda la camara en alcanzar el objetivo a mirar
boolean showControls;

//Timers
float randomPositionCurrentTime;
float randomPositionTotalTime;

//Tamaños
float goalSize; // Tamaño del cubo que es la meta
float mosquitoSize; // Tamaño de los que no son lideres
float mosqueenSize; // Tamaño del lider

//Zona de SetUp
void setup()
{
  gamePhase = Phase.STARTING;
  
  size(1000, 700, P3D);
  
  // Tamaño del mundo
  worldBoundaryX = 1000;
  worldBoundaryY = 1000;
  worldBoundaryZ = 1500;

  // Cámara
  cam = new PeasyCam(this, 2800);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2800);
  
  animationTimeInMillis = 1000;
  
  cameraPhase = CamPhase.CENTERWORLD;
  showControls = false;
  updateCameraLookAt();
 
  //lights();
  
  mosquitoSize = random(10.0, 15.0);
  mosqueenSize = 18;
  goalSize = 30;
  
  // Lider
  particulaArray[0] = new particula(
  new PVector (0.0, 0.0, 0.0), // Posicion
  new PVector (0.0, 0.0, 0.0), // Velocidad Inicial
  1.0, // Massa
  mosqueenSize, // Tamaño 
  color(255, 255, 0), // Color
  1, // Es lider (1 si, 0 no)
  0); // Id
  
  // Bandada
  for (int i = 1; i < particulaArray.length; i++)
  {
    //new PVector (10.0,height/2.0,-10.0) posicion que habia antes del random
    particulaArray[i] = new particula(
      new PVector (random(0, worldBoundaryX), random(0, worldBoundaryY), random(0, worldBoundaryZ)), 
      new PVector (random(-10.0, 10.0), random(-10.0, 10.0), random(-10.0, 10.0)), 
      1.0, 
      mosquitoSize, 
      color(0, random(255), 0), 
      0, 
      i);
  }
  //Inicializar ciertos valores

  posGoal = new PVector(0, 0, 0);
  posGoal = randomPosition(); // Posicion random para la meta
  posLeader = new PVector(0.0, 0.0, 0.0);
  inc_t = 0.4;
  updateCameraLookAt();

  isPaused = false;
  gamePhase = Phase.SIMULATION;
  
  //Temporizadores
  randomPositionTotalTime = 3000; // 3 segundos
  randomPositionCurrentTime = 0;
}

//Zona de Draw
void draw()
{
  background(255);
  drawWorldBoundaries(); // Dibuja el cubo que representa los limites del mundo
  
  for (int i = 0; i < particulaArray.length; i++) 
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
