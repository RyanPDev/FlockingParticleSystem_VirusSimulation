void createEnemy() // Funcion que crea enemigos
{
  arrayEnemies.add(new Enemy(
    new PVector (random(0, worldBoundaryX), random(0, worldBoundaryY), random(0, worldBoundaryZ)), 
    new PVector (random(-10.0, 10.0), random(-10.0, 10.0), random(-10.0, 10.0)), 
    1.0, 
    enemySize, 
    color(random(100, 255), 0, 0)
    ));
  updateAllEnemiesIds();
}

void enemyInteraction() // Funcion que controla el comportamiento del enemigo
{
  for (int i = arrayEnemies.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
  {
    Enemy enemy = arrayEnemies.get(i);
    if (gamePhase == Phase.SIMULATION)
    {
      enemy.move(); // |--> Pestaña EnemyClass
    }
    enemy.drawParticle(); // |--> Pestaña EnemyClass
  }
}

void eraseEnemy(int num)
{
  if (arrayEnemies.size() != 0)
  {
    arrayEnemies.remove(num);
    updateAllEnemiesIds();
  }
}

void updateAllEnemiesIds() // Asigno a todos los avatares, un identificador por orden, esto se hace cada vez que se añade uno o se quita uno
{
  if (arrayEnemies.size() != 0)
  {
    for (int i = arrayEnemies.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
    {
      arrayEnemies.get(i).updateId(i);
    }
  }
}
