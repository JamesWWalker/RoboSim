void moveJoints() {

  float trialAngle = testModel.segments.get(0).currentRotations[1] + 0.02 * jointsMoving[0];
  trialAngle = clampAngle(trialAngle);
  if (testModel.segments.get(0).anglePermitted(1, trialAngle))
    testModel.segments.get(0).currentRotations[1] = trialAngle;
  
  trialAngle = testModel.segments.get(1).currentRotations[2] + 0.02 * jointsMoving[1];
  trialAngle = clampAngle(trialAngle);
  if (testModel.segments.get(1).anglePermitted(2, trialAngle))
    testModel.segments.get(1).currentRotations[2] = trialAngle;
    
  trialAngle = testModel.segments.get(2).currentRotations[2] + 0.02 * jointsMoving[2];
  trialAngle = clampAngle(trialAngle);
  if (testModel.segments.get(2).anglePermitted(2, trialAngle))
    testModel.segments.get(2).currentRotations[2] = trialAngle;
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


final int ARM_TEST = 0;


public class ArmModel {
  
  public ArrayList<Model> segments = new ArrayList<Model>();
  public int type;
  //public boolean calculatingArms = false, movingArms = false;
  public ArrayList<PVector> intermediatePositions;
  public int interIdx = -1;
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
  
  int motionFrameCounter = 0;
  float DISTANCE_BETWEEN_POINTS = 5.0;
  
  public void beginNewLinearMotion(PVector start, PVector end) {
    calculateIntermediatePositions(start, end);
    motionFrameCounter = 0;
    int result = calculateIK(this, intermediatePositions.get(interIdx), 720, 15);
    // TODO: FLAG: MIGHT NEED TO UPDATE THIS LATER TO ACCOUNT FOR FAILURE POSSIBILITY.
    while (result != EXEC_SUCCESS)
      result = calculateIK(this, intermediatePositions.get(interIdx), 720, 15);
  }
  
  public boolean executeLinearMotion(float speedMult) {
    println("execute linear motion start");
    motionFrameCounter++;
    // speed is in pixels per frame, multiply that by the current speed setting
    // which is contained in the motion instruction
    float currentSpeed = motorSpeed * speedMult;
    if (currentSpeed * motionFrameCounter > DISTANCE_BETWEEN_POINTS) {
      println("did i get here?");
      instantRotation();
      interIdx++;
      motionFrameCounter = 0;
      if (interIdx >= intermediatePositions.size()) {
        interIdx = -1;
        println("returning that i'm done");
        return true;
      }
      println("before IK");
      int result = calculateIK(this, intermediatePositions.get(interIdx), 720, 25);
      println("after IK: " + result);
      // TODO: FLAG: MIGHT NEED TO UPDATE THIS LATER TO ACCOUNT FOR FAILURE POSSIBILITY.
      while (result != EXEC_SUCCESS) {
        println("stuck in here");
        result = calculateIK(this, intermediatePositions.get(interIdx), 720, 25);
      }
    }
    println("execute linear motion end");
    return false;
  } // end execute linear motion
  
  public void calculateIntermediatePositions(PVector start, PVector end) {
    intermediatePositions = new ArrayList<PVector>();
    float mu = 0;
    int numberOfPoints = (int)
      (dist(start.x, start.y, start.z, end.x, end.y, end.z) / DISTANCE_BETWEEN_POINTS);
    float increment = 1.0 / (float)numberOfPoints;
    for (int n = 0; n < numberOfPoints; n++) {
      mu += increment;
      intermediatePositions.add(new PVector(
        start.x * (1 - mu) + (end.x * mu),
        start.y * (1 - mu) + (end.y * mu),
        start.z * (1 - mu) + (end.z * mu)));
    }
    interIdx = 0;
  } // end calculate intermediate positions
  
} // end ArmModel class

void printCurrentModelCoordinates(String msg) {
  print(msg + ": " );
  print(modelX(0, 0, 0) + " ");
  print(modelY(0, 0, 0) + " ");
  print(modelZ(0, 0, 0));
  println();
}
