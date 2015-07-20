void moveJoints() {
  
  for (Model model : armModel.segments) {
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        float trialAngle = model.currentRotations[n] + 0.02 * model.jointsMoving[n];
        trialAngle = clampAngle(trialAngle);
        if (model.anglePermitted(n, trialAngle))
          model.currentRotations[n] = trialAngle;
        else model.jointsMoving[n] = 0;
      }
    }
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
  public boolean[] rotations = new boolean[3]; // is rotating on this joint valid?
  public ArrayList<PVector>[] jointRanges = (ArrayList<PVector>[])new ArrayList[3];
  public float[] currentRotations = new float[3]; // current rotation value
  public float[] testRotations = new float[3]; // used while performing IK
  public float[] targetRotations = new float[3]; // we want to be rotated to this value
  public int[] rotationDirections = new int[3]; // control rotation direction so we
                                                // don't "take the long way around"
  public float[] rotationSpeeds = new float[3];
  public float[] jointsMoving = new float[3]; // for live control using the joint buttons
  
  public Model() {
    for (int n = 0; n < 3; n++) {
      rotations[n] = false;
      currentRotations[n] = 0;
      jointRanges[n] = new ArrayList<PVector>();
      rotationSpeeds[n] = 0.01;
    }
  }
  
  public boolean anglePermitted(int idx, float angle) {
    for (PVector range : jointRanges[idx]) {
      if (angle >= range.x && angle <= range.y) return true;
    }
    return false;
  }
}


final int ARM_TEST = 0, ARM_STANDARD = 1;


public class ArmModel {
  
  public ArrayList<Model> segments = new ArrayList<Model>();
  public int type;
  //public boolean calculatingArms = false, movingArms = false;
  public float motorSpeed;
  
  public ArmModel(int in) {
    type = in;
    if (type == ARM_TEST) {
      motorSpeed = 255.0 / 60.0; // speed in mm divided by the framerate
      Model base = loadSTLModel("Base.STL");
      base.rotations[1] = true;
      base.jointRanges[1].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      Model link1 = loadSTLModel("Link1.STL");
      link1.rotations[2] = true;
      link1.jointRanges[2].add(new PVector(0, 2.4));
      link1.jointRanges[2].add(new PVector(3.88, PI*2));
      Model link2 = loadSTLModel("Link2.STL");
      link2.rotations[2] = true;
      link2.jointRanges[2].add(new PVector(0, 2));
      link2.jointRanges[2].add(new PVector(4.28, PI*2));
      Model link3 = loadSTLModel("Link3.STL");
      link3.rotations[0] = true;
      link3.jointRanges[0].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      segments.add(base);
      segments.add(link1);
      segments.add(link2);
      segments.add(link3);
    } else if (type == ARM_STANDARD) {
      // TODO: FILL IN PROPER JOINT RESTRICTION VALUES.
      motorSpeed = 255.0 / 60.0; // speed in mm divided by the framerate
      Model base = loadSTLModel("ROBOT_MODEL_1_BASE.STL");
      base.rotations[1] = true;
      base.jointRanges[1].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      Model axis1 = loadSTLModel("ROBOT_MODEL_1_AXIS1.STL");
      axis1.rotations[2] = true;
      axis1.jointRanges[2].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      Model axis2 = loadSTLModel("ROBOT_MODEL_1_AXIS2.STL");
      axis2.rotations[2] = true;
      axis2.jointRanges[2].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      Model axis3 = loadSTLModel("ROBOT_MODEL_1_AXIS3.STL");
      axis3.rotations[0] = true;
      axis3.jointRanges[0].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      Model axis4 = loadSTLModel("ROBOT_MODEL_1_AXIS4.STL");
      axis4.rotations[2] = true;
      axis4.jointRanges[2].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      Model axis5 = loadSTLModel("ROBOT_MODEL_1_AXIS5.STL");
      axis5.rotations[0] = true;
      axis5.jointRanges[0].add(new PVector(Float.MIN_VALUE, Float.MAX_VALUE));
      Model axis6 = loadSTLModel("ROBOT_MODEL_1_AXIS6.STL");
      segments.add(base);
      segments.add(axis1);
      segments.add(axis2);
      segments.add(axis3);
      segments.add(axis4);
      segments.add(axis5);
      segments.add(axis6);
    }
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
    } else if (type == ARM_STANDARD) {
      stroke(0);
      fill(200, 200, 0);
      
      translate(600, 200, 0);

      rotateZ(PI);
      rotateY(PI/2);
      drawModel(segments.get(0));
      rotateY(-PI/2);
      rotateZ(-PI);
      
      fill(50);
    
      translate(-50, -166, -358); // -115, -213, -413
      rotateZ(PI);
      translate(150, 0, 150);
      rotateY(segments.get(0).currentRotations[1]);
      translate(-150, 0, -150);
      drawModel(segments.get(1));
      rotateZ(-PI);
    
      fill(200, 200, 0);
    
      translate(-115, -85, 180);
      rotateZ(PI);
      rotateY(PI/2);
      translate(0, 62, 62);
      rotateX(segments.get(1).currentRotations[2]);
      translate(0, -62, -62);
      drawModel(segments.get(2));
      rotateY(-PI/2);
      rotateZ(-PI);
    
      fill(50);
   
      translate(0, -500, -50);
      rotateZ(PI);
      rotateY(PI/2);
      translate(0, 75, 75);
      rotateX(segments.get(2).currentRotations[2]);
      translate(0, -75, -75);
      drawModel(segments.get(3));
      rotateY(PI/2);
      rotateZ(-PI);
    
      translate(745, -150, 150);
      rotateZ(PI/2);
      rotateY(PI/2);
      translate(70, 0, 70);
      rotateY(segments.get(3).currentRotations[0]);
      translate(-70, 0, -70);
      drawModel(segments.get(4));
      rotateY(-PI/2);
      rotateZ(-PI/2);
    
      fill(200, 200, 0);
    
      translate(-115, 130, -124);
      rotateZ(PI);
      rotateY(-PI/2);
      translate(0, 50, 50);
      rotateX(segments.get(4).currentRotations[2]);
      translate(0, -50, -50);
      drawModel(segments.get(5));
      rotateY(PI/2);
      rotateZ(-PI);
    
      fill(50);
    
      translate(150, -10, 95);
      rotateY(-PI/2);
      rotateZ(PI);
      translate(45, 45, 0);
      rotateZ(segments.get(5).currentRotations[0]);
      translate(-45, -45, 0);
      drawModel(segments.get(6));
            
      // next, the end effector
    }
  }// end draw arm model
  
  public boolean interpolateRotation() {
    boolean allDone = true;
    for (Model a : segments) {
      for (int r = 0; r < 3; r++) {
        if (a.rotations[r]) {
          if (abs(a.currentRotations[r] - a.targetRotations[r]) >
              a.rotationSpeeds[r])
          {
            allDone = false;
            a.currentRotations[r] += a.rotationSpeeds[r] * a.rotationDirections[r];
            a.currentRotations[r] = clampAngle(a.currentRotations[r]);
          }
        }
      } // end loop through rotation axes
    } // end loop through arm segments
    return allDone;
  } // end interpolate rotation
  
  public void instantRotation() {
    for (Model a : segments) {
      for (int r = 0; r < 3; r++) {
        a.currentRotations[r] = a.targetRotations[r];
      }
    }
  }
  
} // end ArmModel class

void printCurrentModelCoordinates(String msg) {
  print(msg + ": " );
  print(modelX(0, 0, 0) + " ");
  print(modelY(0, 0, 0) + " ");
  print(modelZ(0, 0, 0));
  println();
}
