void moveJoints() {
  testModel.segments.get(0).currentRotations[1] += 0.02 * jointsMoving[0];
  
  testModel.segments.get(1).currentRotations[2] += 0.02 * jointsMoving[1];
  /*if (testModel.segments.get(1).currentRotations[2] > testModel.segments.get(1).rotationMaxConstraints[2]) {
    jointsMoving[1] = 0;
    testModel.segments.get(1).currentRotations[2] = testModel.segments.get(1).rotationMaxConstraints[2];
  } else if (testModel.segments.get(1).currentRotations[2] < testModel.segments.get(1).rotationMinConstraints[2]) {
    jointsMoving[1] = 0;
    testModel.segments.get(1).currentRotations[2] = testModel.segments.get(1).rotationMinConstraints[2];
  }*/
  
  testModel.segments.get(2).currentRotations[2] += 0.02 * jointsMoving[2];
  /*if (testModel.segments.get(2).currentRotations[2] > testModel.segments.get(2).rotationMaxConstraints[2]) {
    jointsMoving[2] = 0;
    testModel.segments.get(2).currentRotations[2] = testModel.segments.get(2).rotationMaxConstraints[2];
  } else if (testModel.segments.get(2).currentRotations[2] < testModel.segments.get(2).rotationMinConstraints[2]) {
    jointsMoving[2] = 0;
    testModel.segments.get(2).currentRotations[2] = testModel.segments.get(2).rotationMinConstraints[2];
  }*/
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

Model loadSTLModel(String filename, int len) {
  byte[] data = loadBytes(filename);
  Model model = new Model(len);
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
  public boolean[] rotations = new boolean[3]; // is rotating on this joint valid?
  public float[] rotationMinConstraints = new float[3];
  public float[] rotationMaxConstraints = new float[3];
  public float[] currentRotations = new float[3]; // current rotation value
  public float[] testRotations = new float[3]; // used while performing IK
  public float[] targetRotations = new float[3]; // we want to be rotated this way
  public int[] rotationDirections = new int[3]; // control rotation direction so we
                                                // don't "take the long way around"
  public int length;
  
  public Model(int in) {
    for (int n = 0; n < 3; n++) {
      rotations[n] = false;
      rotationMinConstraints[n] = Float.MIN_VALUE;
      rotationMaxConstraints[n] = Float.MAX_VALUE;
      currentRotations[n] = 0;
    }
    length = in;
  }
}


final int ARM_TEST = 0;


public class ArmModel {
  
  ArrayList<Model> segments = new ArrayList<Model>();
  int type;
  
  public ArmModel(int in) {
    type = in;
    if (type == ARM_TEST) {
      Model base = loadSTLModel("Base.STL", 140);
      base.rotations[1] = true;
      Model link1 = loadSTLModel("Link1.STL", 137);
      link1.rotations[2] = true;
      link1.rotationMinConstraints[2] = 0;
      link1.rotationMaxConstraints[2] = 4.8;
      Model link2 = loadSTLModel("Link2.STL", 173);
      link2.rotations[2] = true;
      link2.rotationMinConstraints[2] = 0;
      link2.rotationMaxConstraints[2] = 4;
      Model link3 = loadSTLModel("Link3.STL", 140);
      link3.rotations[0] = true;
      // end effector rotates around X and Y axes
      // doesn't seem to be included in model files yet
      segments.add(base);
      segments.add(link1);
      segments.add(link2);
      segments.add(link3);
    } // end if type == ARM_TEST
  } // end ArmModel constructor
  
  public void draw() {
    if (type == ARM_TEST) {
      rotateY(segments.get(0).currentRotations[1]);
      drawModel(segments.get(0));
      translate(0, -200, 0);
      rotateZ(PI);
      //rotateY(PI/2.0);
      drawModel(segments.get(1));
      rotateZ(-PI);
      translate(-25, -130, 0);
      rotateZ(segments.get(1).currentRotations[2]);
      translate(-25, -130, 0);
      rotateZ(PI);
      drawModel(segments.get(2));
      rotateZ(-PI);
      translate(0, -120, 0);
      rotateZ(segments.get(2).currentRotations[2]);
      translate(0, -120, 0);
      rotateZ(PI);
      drawModel(segments.get(3));
    }
  }// end draw arm model
  
} // end ArmModel class

void printCurrentModelCoordinates(String msg) {
  print(msg + ": " );
  print(modelX(0, 0, 0) + " ");
  print(modelY(0, 0, 0) + " ");
  print(modelZ(0, 0, 0));
  println();
}
