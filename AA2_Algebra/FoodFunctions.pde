void createFood() // Funcion que crea enemigosomida
{
  arrayFood.add(new Food(
    new PVector (random(0, worldBoundaryX), random(0, worldBoundaryY), random(0, worldBoundaryZ)), 
    foodSize, 
    color(255, 192, 203), 
    arrayFood.size()
    ));
}

void foodInteraction() {
  for (int i = arrayFood.size(); i-- > 0; ) //Se usa un bucle invertido porque sino no se pueden quitar objetos de la array list (cosas de processing)
  {
    Food food = arrayFood.get(i);
    food.drawFood(); // |--> Pestaña FoodClass
  }
}

void eraseFood(int food)
{
  if (arrayFood.size() != 0)
    arrayFood.remove(food);
}
