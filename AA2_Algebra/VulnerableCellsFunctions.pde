void createVulnerableCell() // Funcion que crea enemigosomida
{
  arrayVulnerableCell.add(new Food(
    new PVector (random(0, worldBoundaryX), random(0, worldBoundaryY), random(0, worldBoundaryZ)), 
    foodSize, 
    color(255, 192, 203), 
    arrayVulnerableCell.size()
    ));
}

void vulnerableCellsInteraction() //Funcion que controla el comportamiento de las celulas vulnerables
{
  for (int i = arrayVulnerableCell.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
  {
    Food food = arrayVulnerableCell.get(i);
    food.drawVulnerableCell(); // |--> Pestaña VulnerableCellsClass
  }
}

void eraseVulnerableCell(int food)
{
  if (arrayVulnerableCell.size() != 0)
    arrayVulnerableCell.remove(food);
}
