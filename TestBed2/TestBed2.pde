
import java.util.*;
import java.nio.*;

ArmModel testModel;
float lastMouseX, lastMouseY;
float cameraTX = 0, cameraTY = 0, cameraTZ = 0;
float cameraRX = 0, cameraRY = 0, cameraRZ = 0;
boolean spacebarDown = false;

void setup() {
  size(800, 600, P3D);
  testModel = new ArmModel();
}

void draw() {
  lastMouseX = mouseX;
  lastMouseY = mouseY;
  background(255);
  stroke(100, 100, 255);
  pushMatrix();
  translate(400 + cameraTX, 700 + cameraTY, -500 + cameraTZ);
  rotateX(cameraRX);
  rotateY(cameraRY);
  testModel.draw();
  popMatrix();
}

void keyPressed() {
  if (key == ' ') spacebarDown = true;
}

void keyReleased() {
  if (key == ' ') spacebarDown = false;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e < 0) cameraTZ += 25;
  else if (e > 0) cameraTZ -= 25;
}

void mouseDragged() {
  if (!spacebarDown) {
    if (mouseX < lastMouseX) cameraRY -= 0.01;
    else if (mouseX > lastMouseX) cameraRY += 0.01;
    if (mouseY < lastMouseY) cameraRX -= 0.01;
    else if (mouseY > lastMouseY) cameraRX += 0.01;
  } else {
    if (mouseX < lastMouseX) cameraTY -= 25;
    else if (mouseX > lastMouseX) cameraTY += 25;
    if (mouseY < lastMouseY) cameraTX -= 25;
    else if (mouseY > lastMouseY) cameraTX += 25;
  }
}

void drawModel(Model model) {
  pushMatrix();
  for (Triangle t : model.triangles) {
    beginShape(TRIANGLES);
    normal(t.components[0].x, t.components[1].y, t.components[2].z);
    for (int n = 1; n < 4; n++)
      vertex(t.components[n].x, t.components[n].y, t.components[n].z);
    endShape();
  }
  popMatrix();
}

Model loadSTLModel(String filename) {
  byte[] data = loadBytes(filename);
  Model model = new Model();
  int n = 84; // skip header and number of triangles
  
  // debug
  /*float smallestX = Float.MAX_VALUE;
  float biggestX = Float.MIN_VALUE;
  float smallestY = Float.MAX_VALUE;
  float biggestY = Float.MIN_VALUE;
  float smallestZ = Float.MAX_VALUE;
  float biggestZ = Float.MIN_VALUE; /* */
  // end debug
  
  while (n < data.length) {
    Triangle t = new Triangle();
    for (int m = 0; m < 4; m++) {
      byte[] bytesX = new byte[4];
      bytesX[0] = data[n+3]; bytesX[1] = data[n+2];
      bytesX[2] = data[n+1]; bytesX[3] = data[n];
      n += 4;
      byte[] bytesY = new byte[4];
      bytesY[0] = data[n+3]; bytesY[1] = data[n+2];
      bytesY[2] = data[n+1]; bytesY[3] = data[n];
      n += 4;
      byte[] bytesZ = new byte[4];
      bytesZ[0] = data[n+3]; bytesZ[1] = data[n+2];
      bytesZ[2] = data[n+1]; bytesZ[3] = data[n];
      n += 4;
      t.components[m] = new PVector(
        ByteBuffer.wrap(bytesX).getFloat(),
        ByteBuffer.wrap(bytesY).getFloat(),
        ByteBuffer.wrap(bytesZ).getFloat()
      );
      // debug
      /*if (m > 0) {
        if (t.components[m].x > biggestX) biggestX = t.components[m].x;
        if (t.components[m].x < smallestX) smallestX = t.components[m].x;
        if (t.components[m].y > biggestY) biggestY = t.components[m].y;
        if (t.components[m].y < smallestY) smallestY = t.components[m].y;
        if (t.components[m].z > biggestZ) biggestZ = t.components[m].z;
        if (t.components[m].z < smallestZ) smallestZ = t.components[m].z;
      } /* */
      // end debug
    }
    n += 2; // skip meaningless "attribute byte count"
    model.triangles.add(t);
  }
  // DEBUG
  /*for (Triangle t : model.triangles) {
    println("Triangle: ");
    println("Normal: " + t.components[0].x + " " +
          t.components[0].y + " " + t.components[0].z);
    println("V1: " + t.components[1].x + " " +
          t.components[1].y + " " + t.components[1].z);
    println("V2: " + t.components[2].x + " " +
          t.components[2].y + " " + t.components[2].z);
    println("V3: " + t.components[3].x + " " +
          t.components[3].y + " " + t.components[3].z);
    println("-----");
  } /* */
  // END DEBUG
  // debug
  /*println("Size X: " + (biggestX - smallestX));
  println("Size Y: " + (biggestY - smallestY));
  println("Size Z: " + (biggestZ - smallestZ)); /* */
  // end debug
  return model;
}

public class Triangle {
  public PVector[] components = new PVector[4];
  // normal, v1, v2, v3
}

public class Model {
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
}

public class ArmModel {
  Model base;
  Model link1;
  Model link2;
  Model link3;
  
  public ArmModel() {
    base = loadSTLModel("Base.STL");
    link1 = loadSTLModel("Link1.STL");
    link2 = loadSTLModel("Link2.STL");
    link3 = loadSTLModel("Link3.STL");
  }
  
  public void draw() {
    drawModel(base);
    translate(0, -200, 0);
    rotateZ(PI);
    //rotateY(PI/2.0);
    drawModel(link1);
    rotateZ(-PI);
    translate(-50, -260, 0);
    rotateZ(PI);
    drawModel(link2);
    rotateZ(-PI);
    translate(0, -240, 0);
    rotateZ(PI);
    drawModel(link3);
  }
}
