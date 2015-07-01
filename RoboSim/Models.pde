void moveJoints() {
  testModel.base.currentRotations[1] += 0.02 * jointsMoving[0];
  
  testModel.link1.currentRotations[2] += 0.02 * jointsMoving[1];
  if (testModel.link1.currentRotations[2] > testModel.link1.rotationMaxConstraints[2]) {
    jointsMoving[1] = 0;
    testModel.link1.currentRotations[2] = testModel.link1.rotationMaxConstraints[2];
  } else if (testModel.link1.currentRotations[2] < testModel.link1.rotationMinConstraints[2]) {
    jointsMoving[1] = 0;
    testModel.link1.currentRotations[2] = testModel.link1.rotationMinConstraints[2];
  }
  
  testModel.link2.currentRotations[2] += 0.02 * jointsMoving[2];
  if (testModel.link2.currentRotations[2] > testModel.link2.rotationMaxConstraints[2]) {
    jointsMoving[2] = 0;
    testModel.link2.currentRotations[2] = testModel.link2.rotationMaxConstraints[2];
  } else if (testModel.link2.currentRotations[2] < testModel.link2.rotationMinConstraints[2]) {
    jointsMoving[2] = 0;
    testModel.link2.currentRotations[2] = testModel.link2.rotationMinConstraints[2];
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
  return model;
}

public class Triangle {
  public PVector[] components = new PVector[4];
  // normal, v1, v2, v3
}

public class Model {
  public ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  public boolean[] rotations = new boolean[3];
  public float[] rotationMinConstraints = new float[3];
  public float[] rotationMaxConstraints = new float[3];
  public float[] currentRotations = new float[3];
  
  public Model() {
    for (int n = 0; n < 3; n++) {
      rotations[n] = false;
      rotationMinConstraints[n] = Float.MIN_VALUE;
      rotationMaxConstraints[n] = Float.MAX_VALUE;
      currentRotations[n] = 0;
    }
  }
}

public class ArmModel {
  Model base;
  Model link1;
  Model link2;
  Model link3;
  
  public ArmModel() {
    base = loadSTLModel("Base.STL");
    base.rotations[1] = true;
    link1 = loadSTLModel("Link1.STL");
    link1.rotations[2] = true;
    link1.rotationMinConstraints[2] = -2.4;
    link1.rotationMaxConstraints[2] = 2.4;
    link2 = loadSTLModel("Link2.STL");
    link2.rotations[2] = true;
    link2.rotationMinConstraints[2] = -2;
    link2.rotationMaxConstraints[2] = 2;
    link3 = loadSTLModel("Link3.STL");
    link3.rotations[0] = true;
    // end effector rotates around X and Y axes
    // doesn't seem to be included in model files yet
  }
  
  public void draw() {
    rotateY(base.currentRotations[1]);
    drawModel(base);
    translate(0, -200, 0);
    rotateZ(PI);
    //rotateY(PI/2.0);
    drawModel(link1);
    rotateZ(-PI);
    translate(-25, -130, 0);
    rotateZ(link1.currentRotations[2]);
    translate(-25, -130, 0);
    rotateZ(PI);
    drawModel(link2);
    rotateZ(-PI);
    translate(0, -120, 0);
    rotateZ(link2.currentRotations[2]);
    translate(0, -120, 0);
    rotateZ(PI);
    drawModel(link3);
  }
} // end ArmModel class

void printCurrentModelCoordinates(String msg) {
  print(msg + ": " );
  print(modelX(0, 0, 0) + " ");
  print(modelY(0, 0, 0) + " ");
  print(modelZ(0, 0, 0));
  println();
}
