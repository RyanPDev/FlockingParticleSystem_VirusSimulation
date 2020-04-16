import peasy.*;

//Zona de Variables y Objetos

//Delta tiempo
float inc_t;

//Posiciones de la meta y el avatar lider

ArrayList<particula> arrayAvatar = new ArrayList(); // Lista de coronavirus

boolean somethingCreated = false;
boolean somethingErased = false;
boolean changedSelectedObject = false;

PVector posGoal, posLeader;
float leaderInitialSpeed;
//xd

ArrayList<Enemy> arrayEnemies = new ArrayList(); // Lista de celulas inmunologicas


ArrayList<Food> arrayFood = new ArrayList(); // Lista de celulas vulnerables
boolean foodCreated = false;

enum ObjectType {
  AVATAR, ENEMY, FOOD
};
ObjectType selectedObjectType;
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
float foodSize;
float leaderSize; // Tamaño del lider

// Strings

String showControlsText = "Press 'H' to show simulation controls";
String simulationControlsText= "Press 'P' to Pause/Unpause\nPress 'C' to re-center de camera view\nPress 'R' for Random Mode\nRandom mode->(Every 5 seconds, every virus will behave differently)\n";
String addingControlText = "Press 'SPACE' to change the object selected\nPress '+' or '-' to add or delete something\ndepending on what you are selecting\nYou can also Press '0'(zero) to eliminate\neveryone of that type";
String cameraControlsText= "\nDrag with Left Click to rotate camera\nSpin Mouse Wheel to Zoom\nPress Mouse Wheel and drag to move Camera                       -Press 'H' to hide controls-";
//Zona de SetUp
void setup()
{
  gamePhase = Phase.STARTING;
  selectedObjectType = ObjectType.AVATAR;
  size(1000, 700, P3D);

  // Tamaño del mundo
  worldBoundaryX = 1000;
  worldBoundaryY = 1000;
  worldBoundaryZ = 1500;

  // Cámara
  cam = new PeasyCam(this, 50);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(2800);

  animationTimeInMillis = 1000;

  g3 = (PGraphics3D) g;
  cameraPhase = CamPhase.CENTERWORLD;
  showControls = false;
  updateCameraLookAt();

  lights();

  leaderSize = 38;
  nonLeaderMaxSize = 25.0;
  nonLeaderMinSize = 20.0;
  enemySize = 50;
  goalSize = 30;
  foodSize = 20;

  posGoal = new PVector(0, 0, 0);
  posGoal = calculateRandomPosition(); // Posicion random para la meta
  checkIfGoalOutOfBounds();
  posLeader = new PVector(0.0, 0.0, 0.0);
  inc_t = 0.4;
  updateCameraLookAt();

  isPaused = false;
  gamePhase = Phase.SIMULATION;

  //Temporizadores
  randomPositionTotalTime = 3000; // 3 segundos
  randomPositionCurrentTime = 0;
  cam.rotateX(radians(-35.26));  // rotate around the x-axis passing through the subject
  cam.rotateY(radians(-40));  // rotate around the y-axis passing through the subject
}

//Zona de Draw
void draw()
{
  background(255);
  pushMatrix();

  rotateX(radians(-35.26));
  rotateY(radians(-45));

  drawWorldBoundaries(); // Dibuja el cubo que representa los limites del mundo

  avatarInteraction();

  enemyInteraction();
  foodInteraction();

  drawGoal();
  collisionLeaderGoal();

  popMatrix();

  drawHUD();
}
