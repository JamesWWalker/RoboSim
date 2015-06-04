
import java.util.*;
import java.nio.*;

Model testModel;

void setup() {
  size(800, 600, P3D);
  testModel = loadSTLModel("Base.STL");
}

void draw() {
  background(255);
  translate(400, 300);
  drawModel(testModel);
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
  return model;
}

public class Triangle {
  public PVector[] components = new PVector[4];
  // normal, v1, v2, v3
}

public class Model {
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
}
