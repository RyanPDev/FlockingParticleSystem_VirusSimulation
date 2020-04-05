//Proyeccion Isometrica
//Hay que rotar en X 35,26 grados y en Y 45
//Este es un ejemplo de codigo ESTATICO (no hay SETUP ni tampoco DRAW)
// en Processing = se ejecuta solo 1 vez
/*
size(640,380,P3D);
background(255);
lights();

pushMatrix(); // Salvo el estado
 translate(width/2, height/2, 0);
 //Implemento la proyeccion Isometrica
 rotateX(radians(-35.26));
 rotateY(-45);
 
 //Todo lo que pinte a partir de ahora
 //Saldrá multiplicado por las matrices
 //OSEA... por la MODEL-VIEW!!!! = Pila o stack de la grafica
 stroke(0);
 strokeWeight(1);
 box(100);
 
 
 strokeWeight(5);
 //Eje X
 stroke(255,0,0);
 line(0,0,0,100,0,0);
 
 //Eje Y
 stroke(0,255,0);
 line(0,0,0,0,-100,0);
 
  //Eje Z
 stroke(0,0,255);
 line(0,0,0,0,0,100);
 
 popMatrix(); 
 
 //Todo lo que hagamos a partir de ahora
 //Ya no sera afectado por las multiplicaciones de la matriz*/
