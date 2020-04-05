void pintar_la_meta()
{
   pushMatrix();
   translate(pos_meta.x, pos_meta.y, pos_meta.z);
   rotateX(radians(-35.26));
   rotateY(radians(-45));
   strokeWeight(1);
   noFill();
   stroke(255,0,255);
   box(30);
   popMatrix();
}

void pintarSuelo()
{
    //pushMatrix();
    int gridSize = 50;
    strokeWeight(1);
    pushMatrix();
  translate(width/2, height/2);
 // rotateX(radians(-35.26));
   //rotateY(radians(-45));
  for(int i = -width/2; i <width/2; i+=gridSize) {
    for(int j = -height/2; j < height/2; j+=gridSize) {
      int y = 200;
      line(i,          y, j,           i+gridSize, y, j          );
      line(i+gridSize, y, j,           i+gridSize, y, j+gridSize );
      line(i+gridSize, y, j+gridSize,  i,          y, j+gridSize );
      line(i,          y, j,           i,          y, j+gridSize );
    }
  }
  popMatrix();
}

/*void isometricViewOn()
{
    pushMatrix();
    translate(0,0,0);
    rotateX(radians(-35.26));
    rotateY(-45);
}

void isometricViewOff()
{
    popMatrix();
}*/
