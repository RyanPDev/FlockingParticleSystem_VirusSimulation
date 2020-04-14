class Food {
  PVector pos;
  float size;
  color colorF;
  int idNumber;

  Food(PVector p, float t, color c, int id) {
    pos = p;
    size = t;
    colorF = c;
    idNumber = id;
  }


  void drawFood()
  {
    pushMatrix(); // Salvo el estado

    translate(pos.x, pos.y, pos.z);

    noFill();
    stroke(colorF);
    strokeWeight(1);

    sphere(size);

    popMatrix();
  }
}
