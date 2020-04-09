PVector calcula_vector_unitario(PVector pos1, PVector pos2)
{
  PVector vector_calculado;
  vector_calculado = new PVector();
  
  // Pos final (pos 2) menos pos inicial (pos1)
  vector_calculado.x = pos2.x - pos1.x;
  vector_calculado.y = pos2.y - pos1.y;
  vector_calculado.z = pos2.z - pos1.z;
  
  // Se calcula el modulo del vector
  // La raiz cuadrada de la suma de las componentes o coordenadas al cuadrado
  float modulo = sqrt(sq(vector_calculado.x)+sq(vector_calculado.y)+sq(vector_calculado.z));
  
  // Se divide cada componente o coordenada del vector por el modulo para
  // hacerlo unitario
  
  vector_calculado.x /= modulo;
  vector_calculado.y /= modulo;
  vector_calculado.z /= modulo;
  
  
  return vector_calculado;
}


PVector calculateAvatarVector(int id)
{
    PVector vector_calculado;
    vector_calculado = new PVector(0.0,0.0,0.0);
  
    //Se suman las posiciones de todos los avatares
    if(id != particulaArray.length)
    {
      for (int i = id+1; i < particulaArray.length; i++) /////////////////////////////////////////////////////////
      {
          float vector = particulaArray[id].pos.x - particulaArray[i].pos.x;
          
          if(vector!=0)
          {
            if (sqrt(sq(vector)) < 30)
            {
                  vector_calculado.x += particulaArray[id].pos.x - particulaArray[i].pos.x;
                  vector_calculado.y += particulaArray[id].pos.y - particulaArray[i].pos.y;
                  vector_calculado.z += particulaArray[id].pos.z - particulaArray[i].pos.z;
                  float modulo = sqrt(sq(vector_calculado.x)+sq(vector_calculado.y)+sq(vector_calculado.z));
  
                  // Se divide cada componente o coordenada del vector por el modulo para
                  // hacerlo unitario
                  
                  vector_calculado.x /= modulo;
                  vector_calculado.y /= modulo;
                  vector_calculado.z /= modulo;
            }
          }
      }
    }
  
  //Se dividen esa suma por el total de avatares que haya
    
     
  return vector_calculado;
}


PVector dime_centro_bandada() // Promedio entre todos los avatares
{
  PVector vector_calculado;
  vector_calculado = new PVector(0.0,0.0,0.0);
  
  //Se suman las posiciones de todos los avatares
  for (int i = 0; i<10; i++) /////////////////////////////////////////////////////////
  {
      vector_calculado.x += particulaArray[i].pos.x;
      vector_calculado.y += particulaArray[i].pos.y;
      vector_calculado.z += particulaArray[i].pos.z;
  }
  
  //Se dividen esa suma por el total de avatares que haya
      vector_calculado.x /= 10;
      vector_calculado.y /= 10;
      vector_calculado.z /= 10;
     
  return vector_calculado;
}
