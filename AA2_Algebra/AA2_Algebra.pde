import peasy.*;

//Zona de Variables y Objetos

//Delta tiempo
float inc_t;

//Posiciones de la meta y el avatar lider
particula[] particulaArray = new particula[10];
PVector posGoal, posLeader;
float leaderInitialSpeed;


ArrayList<Enemy> arrayEnemies = new ArrayList(); // Lista de enemigos
boolean enemyCreated = false;
boolean enemyErased = false;

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
boolean randomMode = false; // Variable de control para controlar cuando el juego esta en modo random o no.
boolean showRedArrow = true;
//Cámara
PGraphics3D g3;
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
float nonLeaderMaxSize; // Tamaño máximo de los que no son lideres
float nonLeaderMinSize; // Tamaño máximo de los que no son lideres
float enemySize;
float leaderSize; // Tamaño del lider

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
  
  g3 = (PGraphics3D) g;
  cameraPhase = CamPhase.CENTERWORLD;
  showControls = false;
  updateCameraLookAt();
 
  //lights();
  
  leaderSize = 38;
  nonLeaderMaxSize = 25.0;
  nonLeaderMinSize = 20.0;
  enemySize = 50;
  goalSize = 30;
  
  // Lider
      particulaArray[0] = new particula(
      new PVector (0.0, 0.0, 0.0), // Posicion
      new PVector (0.0, 0.0, 0.0), // Velocidad Inicial
      1.0, // Massa
      leaderSize, // Tamaño 
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
      random(nonLeaderMinSize, nonLeaderMaxSize), 
      color(0, random(255), 0), 
      0, 
      i);
  }
  //Inicializar ciertos valores

  posGoal = new PVector(0, 0, 0);
  posGoal = calculateRandomPosition(); // Posicion random para la meta
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
  pushMatrix();
  rotateX(radians(-35.26));
  rotateY(radians(-45));
  
  drawWorldBoundaries(); // Dibuja el cubo que representa los limites del mundo
  
  for (int i = 0; i < particulaArray.length; i++) 
  {
    // Calcular
    if (gamePhase == Phase.SIMULATION)
    {
      particulaArray[i].move();
    }
    // Dibujar
    particulaArray[i].drawParticle();
  }
  
  enemyInteraction();
  
  drawGoal();
  collisionCircleRectangle();
  
  popMatrix();

  drawHUD();
}
