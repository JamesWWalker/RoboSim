
// To-do list:
// -> Make motion instructions follow different coordinate systems
//
// -> The speed control for executing motion instructions is pretty rough.
//    Make it better.
// -> Add more sophisticated handling of failure possibility when calculating IK

ArrayList<PVector> intermediatePositions;
int motionFrameCounter = 0;
float DISTANCE_BETWEEN_POINTS = 5.0;
int interMotionIdx = -1;

final int CURCOORD_JOINT = 0, CURCOORD_WORLD = 1, CURCOORD_TOOL = 2, CURCOORD_USER = 3;
int curCoordFrame = CURCOORD_JOINT;
float liveSpeed = 0.1;


void createTestProgram() {
  Program program = new Program("Test Program");
  MotionInstruction instruction =
    new MotionInstruction(MTYPE_LINEAR, 0, true, 4000, 1.0);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 1, true, 4000, 0.75);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 2, true, 4000, 0.5);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 3, true, 1000, 0);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 4, true, 1000, 0);
  program.addInstruction(instruction);
  for (int n = 0; n < 15; n++) program.addInstruction(
    new MotionInstruction(MTYPE_JOINT, 1, true, 0.5, 0));
  pr[0] = new Point(575, 300, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  pr[1] = new Point(625, 225, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  pr[2] = new Point(675, 200, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  pr[3] = new Point(725, 225, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  pr[4] = new Point(775, 300, 50, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  pr[5] = new Point(-474, -218, 37, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  pr[6] = new Point(-659, -412, -454, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  programs.add(program);
  currentProgram = program;
  
  Program program2 = new Program("Test Program 2");
  MotionInstruction instruction2 =
    new MotionInstruction(MTYPE_LINEAR, 0, true, 1.0, 1.0);
  program2.addInstruction(instruction2);
  instruction = new MotionInstruction(MTYPE_LINEAR, 1, true, 1.0, 0.75);
  programs.add(program2);
  //currentProgram = program;
  
  Program program3 = new Program("Circular Test");
  MotionInstruction instruction3 =
    new MotionInstruction(MTYPE_LINEAR, 0, true, 1.0, 0);
  program3.addInstruction(instruction3);
  instruction3 = new MotionInstruction(MTYPE_CIRCULAR, 1, true, 1.0, 0);
  program3.addInstruction(instruction3);
  instruction3 = new MotionInstruction(MTYPE_LINEAR, 2, true, 1.0, 0);
  program3.addInstruction(instruction3);
  instruction3 = new MotionInstruction(MTYPE_LINEAR, 3, true, 0.25, 0);
  program3.addInstruction(instruction3);
  programs.add(program3);
  //currentProgram = program3;
  
  Program program4 = new Program("New Arm Test");
  MotionInstruction instruction4 =
    new MotionInstruction(MTYPE_LINEAR, 5, true, 1.0, 0);
  program4.addInstruction(instruction4);
  instruction4 = new MotionInstruction(MTYPE_LINEAR, 6, true, 1.0, 0);
  program4.addInstruction(instruction4);
  programs.add(program4);
  //currentProgram = program4;
  
  for (int n = 0; n < 22; n++) programs.add(new Program("Xtra" + Integer.toString(n)));
}



void showMainDisplayText() {
fill(0);
  textAlign(RIGHT, TOP);
  text("Coordinate Frame: " + (curCoordFrame == CURCOORD_JOINT ? "Joint" : "World"), width-20, 20);
  text("Speed: " + (Integer.toString((int)(Math.round(liveSpeed*100)))) + "%", width-20, 40);
  if (curCoordFrame == CURCOORD_JOINT) {
    float j[] = armModel.getJointRotations();
    text("Joints: J1: " + j[0] + " J2: " + j[1] + " J3: " + j[2] +
                " J4: " + j[3] + " J5: " + j[4] + " J6: " + j[5], width-20, 60);
  } else {
    pushMatrix();
    applyCamera();
    PVector cam = new PVector(modelX(0,0,0), modelY(0,0,0), modelZ(0,0,0));
    PVector eep = calculateEndEffectorPosition(armModel, false);
    popMatrix();
    PVector concor = convertNativeToWorld(eep);
    PVector wpr = armModel.getWpr();
    text("Coordinates: X: " + concor.x + " Y: " + concor.y + " Z: " + concor.z +
                     " W: " + wpr.x + " P: " + wpr.y + " R: " + wpr.z, width-20, 60);
  }
  text((shift == ON ? "Shift ON" : "Shift OFF"), width-20, 80);
/*  text("Coordinates: Native: " + eep.x + " Y: " + eep.y + " Z: " + eep.z, width-20, 40);
//  text("Camera base at: X: " + cam.x + " Y: " + cam.y + " Z: " + cam.z, width-20, 60);
  text("Coordinates: World: " + concor.x + " Y: " + concor.y + " Z: " + concor.z, width-20, 60);
  PVector conbak = convertWorldToNative(concor);
  text("Coordinates: Back: " + conbak.x + " Y: " + conbak.y + " Z: " + conbak.z, width-20, 80);
  text("Coordinates: Camera: " + cam.x + " Y: " + cam.y + " Z: " + cam.z, width-20, 100);
  text("Current speed: " + (Integer.toString((int)(Math.round(liveSpeed*100)))) + "%", width-20, 120); /* */
}



// converts from RoboSim-defined world coordinates into
// Processing's coordinate system.
// Assumes that the robot starts out facing toward the LEFT.
PVector convertWorldToNative(PVector in) {
  pushMatrix();
  applyCamera();
  float outx = modelX(0,0,0)-in.x;
  float outy = modelY(0,0,0)-in.z;
  float outz = -(modelZ(0,0,0)-in.y);
  popMatrix();
  return new PVector(outx, outy, outz);
}


PVector convertNativeToWorld(PVector in) {
  pushMatrix();
  applyCamera();
  float outx = modelX(0,0,0)-in.x;
  float outy = in.z+modelZ(0,0,0);
  float outz = modelY(0,0,0)-in.y;
  popMatrix();
  return new PVector(outx, outy, outz);
}



// convert from user-defined RoboSim coordinates into
// Processing's coordinate system.
PVector convertUserToNative(CoordinateFrame frame, PVector in) {
  pushMatrix();
  applyCamera();
  PVector tr = frame.getOrigin();
  // first, apply the user-defined coordinate frame by translating to the
  // origin and then rotating to the user-defined orientation (remember
  // that we need to rotate coording to RoboSim conventions).
  translate(-tr.x, -tr.z, tr.y);
  tr = frame.getRotation();
  rotateX(-tr.x);
  rotateY(-tr.z);
  rotateZ(tr.y);
  // now translate to the given point, which is now defined in terms of
  // the user-defined coordinates, then get the corresponding Processing coordinates.
  translate(-in.x, -in.z, in.y);
  PVector out = new PVector(modelX(0,0,0), modelY(0,0,0), modelZ(0,0,0));
  popMatrix();
  return out;
}



PVector calculateEndEffectorPosition(ArmModel model, boolean test) {
  pushMatrix();
  if (model.type == ARM_TEST) {
    if (!test) rotateY(model.segments.get(0).currentRotations[1]);
    else rotateY(model.segments.get(0).testRotations[1]);
    translate(0, -200, 0);
    translate(-25, -130, 0);
    if (!test) rotateZ(model.segments.get(1).currentRotations[2]);
    else rotateZ(model.segments.get(1).testRotations[2]);
    translate(-25, -130, 0);
    translate(0, -120, 0);
    if (!test) rotateZ(model.segments.get(2).currentRotations[2]);
    else rotateZ(model.segments.get(2).testRotations[2]);
    translate(0, -120, 0);
    rotateZ(PI);
    translate(0, 102, 0);
  } else if (model.type == ARM_STANDARD) {
    translate(600, 200, 0);
    translate(-50, -166, -358); // -115, -213, -413
    rotateZ(PI);
    translate(150, 0, 150);
    if (!test) rotateY(model.segments.get(0).currentRotations[1]);
    else rotateY(model.segments.get(0).testRotations[1]);
    translate(-150, 0, -150);
    rotateZ(-PI);    
    translate(-115, -85, 180);
    rotateZ(PI);
    rotateY(PI/2);
    translate(0, 62, 62);
    if (!test) rotateX(model.segments.get(1).currentRotations[2]);
    else rotateX(model.segments.get(1).testRotations[2]);
    translate(0, -62, -62);
    rotateY(-PI/2);
    rotateZ(-PI);   
    translate(0, -500, -50);
    rotateZ(PI);
    rotateY(PI/2);
    translate(0, 75, 75);
    if (!test) rotateX(model.segments.get(2).currentRotations[2]);
    else rotateX(model.segments.get(2).testRotations[2]);
    translate(0, -75, -75);
    rotateY(PI/2);
    rotateZ(-PI);
    translate(745, -150, 150);
    rotateZ(PI/2);
    rotateY(PI/2);
    translate(70, 0, 70);
    if (!test) rotateY(model.segments.get(3).currentRotations[0]);
    else rotateY(model.segments.get(3).testRotations[0]);
    translate(-70, 0, -70);
    rotateY(-PI/2);
    rotateZ(-PI/2);    
    translate(-115, 130, -124);
    rotateZ(PI);
    rotateY(-PI/2);
    translate(0, 50, 50);
    if (!test) rotateX(model.segments.get(4).currentRotations[2]);
    else rotateX(model.segments.get(4).testRotations[2]);
    translate(0, -50, -50);
    rotateY(PI/2);
    rotateZ(-PI);    
    translate(150, -10, 95);
    rotateY(-PI/2);
    rotateZ(PI);
    translate(45, 45, 0);
    if (!test) rotateZ(model.segments.get(5).currentRotations[0]);
    else rotateZ(model.segments.get(5).testRotations[0]);
  }
  PVector ret = new PVector(
    modelX(0, 0, 0),
    modelY(0, 0, 0),
    modelZ(0, 0, 0));
  popMatrix();
  return ret;
}

/* */

int calculateIK(ArmModel model, PVector eedp, int slices, float closeEnough) {
  
  float checkAngle = (2*PI)/(float)slices;
  
  // loop through each arm segment in turn
  for (int a = model.segments.size()-1; a >= 0; a--) {
    Model segment = model.segments.get(a);
    // loop through each permissible joint rotation of each segment
    for (int r = 0; r < 3; r++) {
      if (segment.rotations[r]) {
        segment.testRotations[r] = segment.currentRotations[r];
        pushMatrix();
        applyCamera();
        PVector eetp = calculateEndEffectorPosition(model, true);
        popMatrix();
        float closest = dist(eetp.x, eetp.y, eetp.z, eedp.x, eedp.y, eedp.z);
        float bestAngle = segment.testRotations[r];
        for (int n = 0; n < slices; n++) {
          segment.testRotations[r] += checkAngle;
          if (segment.anglePermitted(r, checkAngle)) {
            pushMatrix();
            applyCamera();
            eetp = calculateEndEffectorPosition(model, true);
            popMatrix();
            if (dist(eetp.x, eetp.y, eetp.z, eedp.x, eedp.y, eedp.z) < closest) {
              closest = dist(eetp.x, eetp.y, eetp.z, eedp.x, eedp.y, eedp.z);
              bestAngle = segment.testRotations[r];
            }
          }
        } // end loop through slices (try all the different angles)
        bestAngle = clampAngle(bestAngle);
        segment.testRotations[r] = segment.targetRotations[r] = bestAngle;
      }
    } // end loop through permissible joint rotations
  } // end loop through arm segments
  
  // figure out where the end of all the arms is and compare that
  // to where we want it to be
  pushMatrix();
  applyCamera();
  PVector eetp = calculateEndEffectorPosition(model, true);
  popMatrix();
  if (dist(eetp.x, eetp.y, eetp.z, eedp.x, eedp.y, eedp.z) < closeEnough) {
    // calculate whether it's faster to turn CW or CCW
    for (Model a : model.segments) {
      for (int r = 0; r < 3; r++) {
        if (a.rotations[r]) {
          float blueAngle = a.targetRotations[r] - a.currentRotations[r];
          blueAngle = clampAngle(blueAngle);
          if (blueAngle < PI) a.rotationDirections[r] = 1;
          else a.rotationDirections[r] = -1;
        }
      }
    }
    return EXEC_SUCCESS;
  } else return EXEC_PROCESSING;
} // end calculateIK



void calculateIntermediatePositions(PVector start, PVector end) {
  intermediatePositions.clear();
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
  interMotionIdx = 0;
} // end calculate intermediate positions



/*
Here's how this works:
  Assuming our current point is P1, and we're moving to P2 and then P3:
  1 Do linear interpolation between points P2 and P3 FIRST.
  2 Begin interpolation between P1 and P2.
  3 When you're (cont% / 2)% away from P2, begin interpolating not towards
    P2, but towards the points defined between P2 and P3 in step 1.
    The mu for this is from 0 to 0.5 instead of 0 to 1.0.
*/
void calculateContinuousPositions(PVector p1, PVector p2, PVector p3, float percentage) {
  percentage /= 2;
  percentage = 1 - percentage;
  percentage = constrain(percentage, 0, 1);
  intermediatePositions.clear();
  ArrayList<PVector> secondaryTargets = new ArrayList<PVector>();
  float mu = 0;
  int numberOfPoints = 0;
  if (dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) >
      dist(p2.x, p2.y, p2.z, p3.x, p3.y, p3.z))
  {
    numberOfPoints = (int)
      (dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z) / DISTANCE_BETWEEN_POINTS);
  } else {
    numberOfPoints = (int)
      (dist(p2.x, p2.y, p2.z, p3.x, p3.y, p3.z) / DISTANCE_BETWEEN_POINTS);
  }
  float increment = 1.0 / (float)numberOfPoints;
  for (int n = 0; n < numberOfPoints; n++) {
    mu += increment;
    secondaryTargets.add(new PVector(
      p2.x * (1 - mu) + (p3.x * mu),
      p2.y * (1 - mu) + (p3.y * mu),
      p2.z * (1 - mu) + (p3.z * mu)));
  }
  mu = 0;
  int transitionPoint = (int)((float)numberOfPoints * percentage);
  for (int n = 0; n < transitionPoint; n++) {
    mu += increment;
    intermediatePositions.add(new PVector(
      p1.x * (1 - mu) + (p2.x * mu),
      p1.y * (1 - mu) + (p2.y * mu),
      p1.z * (1 - mu) + (p2.z * mu)));
  }
  int secondaryIdx = 0; // accessor for secondary targets
  mu = 0;
  increment /= 2.0;
  PVector currentPoint = intermediatePositions.get(intermediatePositions.size()-1);
  for (int n = transitionPoint; n < numberOfPoints; n++) {
    mu += increment;
    intermediatePositions.add(new PVector(
      currentPoint.x * (1 - mu) + (secondaryTargets.get(secondaryIdx).x * mu),
      currentPoint.y * (1 - mu) + (secondaryTargets.get(secondaryIdx).y * mu),
      currentPoint.z * (1 - mu) + (secondaryTargets.get(secondaryIdx).z * mu)));
    currentPoint = intermediatePositions.get(intermediatePositions.size()-1);
    secondaryIdx++;
  }
  interMotionIdx = 0;
} // end calculate continuous positions



void beginNewContinuousMotion(ArmModel model, PVector start, PVector end,
                              PVector next, float percentage)
{
  calculateContinuousPositions(start, end, next, percentage);
  motionFrameCounter = 0;
  int result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 15);
  // TODO: FLAG: UPDATE THIS LATER TO ACCOUNT FOR FAILURE POSSIBILITY.
  while (result != EXEC_SUCCESS)
    result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 15);
}



void beginNewLinearMotion(ArmModel model, PVector start, PVector end) {
  calculateIntermediatePositions(start, end);
  motionFrameCounter = 0;
  int result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 15);
  // TODO: FLAG: UPDATE THIS LATER TO ACCOUNT FOR FAILURE POSSIBILITY.
  while (result != EXEC_SUCCESS)
    result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 15);
}



void beginNewCircularMotion(ArmModel model, PVector p1, PVector p2, PVector p3) {
  // Generate the circle circumference,
  // then turn it into an arc from the current point to the end point
  intermediatePositions = createArc(createCircleCircumference(p1, p2, p3, 180), p1, p2, p3);
  interMotionIdx = 0;
  motionFrameCounter = 0;
  int result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 15);
  // TODO: FLAG: UPDATE THIS LATER TO ACCOUNT FOR FAILURE POSSIBILITY.
  while (result != EXEC_SUCCESS)
    result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 15);
}



boolean executingInstruction = false;

void readyProgram() {
  currentInstruction = 0;
  executingInstruction = false;
}


boolean executeMotion(ArmModel model, float speedMult) {
  motionFrameCounter++;
  // speed is in pixels per frame, multiply that by the current speed setting
  // which is contained in the motion instruction
  float currentSpeed = model.motorSpeed * speedMult;
  if (currentSpeed * motionFrameCounter > DISTANCE_BETWEEN_POINTS) {
    model.instantRotation();
    interMotionIdx++;
    motionFrameCounter = 0;
    if (interMotionIdx >= intermediatePositions.size()) {
      interMotionIdx = -1;
      return true;
    }
    int result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 25);
    // TODO: FLAG: MIGHT NEED TO UPDATE THIS LATER TO ACCOUNT FOR FAILURE POSSIBILITY.
    while (result != EXEC_SUCCESS) {
      result = calculateIK(model, intermediatePositions.get(interMotionIdx), 720, 25);
    }
  }
  return false;
} // end execute linear motion


PVector vectorConvertTo(PVector point, PVector xAxis,
                        PVector yAxis, PVector zAxis)
{
  PMatrix3D matrix = new PMatrix3D(xAxis.x, xAxis.y, xAxis.z, 0,
                                   yAxis.x, yAxis.y, yAxis.z, 0,
                                   zAxis.x, zAxis.y, zAxis.z, 0,
                                   0,       0,       0,       1);
  PVector result = new PVector();
  matrix.mult(point, result);
  return result;
}


PVector vectorConvertFrom(PVector point, PVector xAxis,
                          PVector yAxis, PVector zAxis)
{
  PMatrix3D matrix = new PMatrix3D(xAxis.x, yAxis.x, zAxis.x, 0,
                                   xAxis.y, yAxis.y, zAxis.y, 0,
                                   xAxis.z, yAxis.z, zAxis.z, 0,
                                   0,       0,       0,       1);
  PVector result = new PVector();
  matrix.mult(point, result);
  return result;
}


PVector[] createPlaneFrom3Points(PVector a, PVector b, PVector c) {  
  PVector n1 = new PVector(a.x-b.x, a.y-b.y, a.z-b.z);
  n1.normalize();
  PVector n2 = new PVector(a.x-c.x, a.y-c.y, a.z-c.z);
  n2.normalize();
  PVector x = n1.get();
  PVector z = n1.cross(n2);
  PVector y = x.cross(z);
  y.normalize();
  z.normalize();
  PVector[] coordinateSystem = new PVector[3];
  coordinateSystem[0] = x;
  coordinateSystem[1] = y;
  coordinateSystem[2] = z;
  return coordinateSystem;
}


// Create points around the circumference of a circle calculated
// from three arbitrary 3D points
// TODO: Add error check in case the 3 supplied points are colinear.
ArrayList<PVector> createCircleCircumference(PVector a,
                                      PVector b,
                                      PVector c,
                                      int numPoints)
{  
  // First, we need to compute the value of some variables that we'll
  // use in a parametric equation to get our answer.
  // First up is computing the circle center. This is much easier to
  // do in 2D, so first we'll convert our three input points into a 2D
  // plane, compute the circle center in those coordinates, then convert
  // back to our native 3D frame.
  PVector[] plane = new PVector[3];
  plane = createPlaneFrom3Points(a, b, c);
  PVector center = circleCenter(vectorConvertTo(a, plane[0], plane[1], plane[2]),
                                vectorConvertTo(b, plane[0], plane[1], plane[2]),
                                vectorConvertTo(c, plane[0], plane[1], plane[2]));
  center = vectorConvertFrom(center, plane[0], plane[1], plane[2]);
  // Now get the radius (easy)
  float r = dist(center.x, center.y, center.z, a.x, a.y, a.z);
  // Get u (a unit vector from the center to some point on the circumference)
  PVector u = new PVector(center.x-a.x, center.y-a.y, center.z-a.z);
  u.normalize();
  // get n (a normal of the plane created by the 3 input points)
  PVector tmp1 = new PVector(a.x-b.x, a.y-b.y, a.z-b.z);
  PVector tmp2 = new PVector(a.x-c.x, a.y-c.y, a.z-c.z);
  PVector n = tmp1.cross(tmp2);
  n.normalize();
  
  // Now plug all that into the parametric equation
  //   P = r*cos(t)*u + r*sin(t)*nxu+center [x is cross product]
  // to compute our points along the circumference.
  // We actually only want to create an arc from A to C, not the full
  // circle, so detect when we're close to those points to decide
  // when to start and stop adding points.
  float angle = 0;
  float angleInc = (TWO_PI)/(float)numPoints;
  ArrayList<PVector> points = new ArrayList<PVector>();
  boolean start = false, grace = false;
  for (int iter = 0; iter < numPoints; iter++) {
    PVector inter1 = PVector.mult(u, r * cos(angle));
    PVector inter2 =  n.cross(u);
    inter2 = PVector.mult(inter2, r * sin(angle));
    inter1.add(inter2);
    inter1.add(center);
    points.add(inter1);
    angle += angleInc;
  }
  return points;
}


// createArc helper method
int cycleNumber(int number) {
  number++;
  if (number >= 4) number = 1;
  return number;
}

ArrayList<PVector> createArc(ArrayList<PVector> points, PVector a, PVector b, PVector c) {
  float CHKDIST = 15.0;
  while (true) {
    int seenA = 0, seenB = 0, seenC = 0, currentSee = 1;
    for (int n = 0; n < points.size(); n++) {
      PVector pt = points.get(n);
      if (dist(pt.x, pt.y, pt.z, a.x, a.y, a.z) <= CHKDIST) seenA = currentSee++;
      if (dist(pt.x, pt.y, pt.z, b.x, b.y, b.z) <= CHKDIST) seenB = currentSee++;
      if (dist(pt.x, pt.y, pt.z, c.x, c.y, c.z) <= CHKDIST) seenC = currentSee++;
    }
    while (seenA != 1) {
      seenA = cycleNumber(seenA);
      seenB = cycleNumber(seenB);
      seenC = cycleNumber(seenC);
    }
    // detect reverse case: if b > c then we're going the wrong way, so reverse
    if (seenB > seenC) {
      Collections.reverse(points);
      continue;
    }
    break;
  } // end while loop
  
  // now we're going in the right direction, so remove unnecessary points
  ArrayList<PVector> newPoints = new ArrayList<PVector>();
  boolean seenA = false, seenC = false;
  for (PVector pt : points) {
    if (seenA && !seenC) newPoints.add(pt);
    if (dist(pt.x, pt.y, pt.z, a.x, a.y, a.z) <= CHKDIST) seenA = true;
    if (seenA && dist(pt.x, pt.y, pt.z, c.x, c.y, c.z) <= CHKDIST) {
      seenC = true;
      break;
    }
  }
  // might have to go through a second time
  if (seenA && !seenC) {
    for (PVector pt : points) {
      newPoints.add(pt);
      if (dist(pt.x, pt.y, pt.z, c.x, c.y, c.z) <= CHKDIST) break;
    }
  }
  if (newPoints.size() > 0) newPoints.remove(0);
  newPoints.add(c);
  return newPoints;
} // end createArc


// Find the circle center of 3 points in 2D
PVector circleCenter(PVector a, PVector b, PVector c) {
  float h = calculateH(a.x, a.y, b.x, b.y, c.x, c.y);
  float k = calculateK(a.x, a.y, b.x, b.y, c.x, c.y);
  return new PVector(h, k, a.z);
}

// TODO: Add error check for colinear case (denominator is zero)
float calculateH(float x1, float y1, float x2, float y2, float x3, float y3) {
    float numerator = (x2*x2+y2*y2)*y3 - (x3*x3+y3*y3)*y2 - 
                      ((x1*x1+y1*y1)*y3 - (x3*x3+y3*y3)*y1) +
                      (x1*x1+y1*y1)*y2 - (x2*x2+y2*y2)*y1;
    float denominator = (x2*y3-x3*y2) -
                        (x1*y3-x3*y1) +
                        (x1*y2-x2*y1);
    denominator *= 2;
    return numerator / denominator;
}
float calculateK(float x1, float y1, float x2, float y2, float x3, float y3) {
    float numerator = x2*(x3*x3+y3*y3) - x3*(x2*x2+y2*y2) -
                      (x1*(x3*x3+y3*y3) - x3*(x1*x1+y1*y1)) +
                      x1*(x2*x2+y2*y2) - x2*(x1*x1+y1*y1);
    float denominator = (x2*y3-x3*y2) -
                        (x1*y3-x3*y1) +
                        (x1*y2-x2*y1);
    denominator *= 2;
    return numerator / denominator;
}



// return true when done
boolean executeProgram(Program program, ArmModel model) {
  if (program == null || currentInstruction >= program.getInstructions().size())
    return true;
  Instruction ins =  program.getInstructions().get(currentInstruction);
  if (ins instanceof MotionInstruction) {
    MotionInstruction instruction = (MotionInstruction)ins;
    if (!executingInstruction) { // start executing new instruction
    
      pushMatrix();
      applyCamera();
      PVector start = calculateEndEffectorPosition(armModel, false);
      popMatrix();
      if (instruction.getMotionType() == MTYPE_LINEAR ||
          instruction.getMotionType() == MTYPE_JOINT)
      {
        if (instruction.getTermination() == 0) {
          beginNewLinearMotion(model, start, instruction.getVector(program).c);
        } else {
          Point nextPoint = null;
          for (int n = currentInstruction+1; n < program.getInstructions().size(); n++) {
            Instruction nextIns = program.getInstructions().get(n);
            if (nextIns instanceof MotionInstruction) {
              MotionInstruction castIns = (MotionInstruction)nextIns;
              nextPoint = castIns.getVector(program);
            }
          }
          if (nextPoint == null) {
            beginNewLinearMotion(model, start, instruction.getVector(program).c);
          } else beginNewContinuousMotion(model, start, instruction.getVector(program).c,
                                          nextPoint.c, instruction.getTermination());
        } // end if termination type is continuous
      } else if (instruction.getMotionType() == MTYPE_CIRCULAR) {
        // If it is a circular instruction, the current instruction holds the intermediate point.
        // There must be another instruction after this that holds the end point.
        // If this isn't the case, the instruction is invalid, so return immediately.
        Point nextPoint = null;
        if (program.getInstructions().size() >= currentInstruction + 2) {
          Instruction nextIns = program.getInstructions().get(currentInstruction+1);
          if (!(nextIns instanceof MotionInstruction)) return true;
          else {
            MotionInstruction castIns = (MotionInstruction)nextIns;
            nextPoint = castIns.getVector(program);
          }
        } else return true; // invalid instruction
        beginNewCircularMotion(model, start, instruction.getVector(program).c, nextPoint.c);
        
      } // end if motion type is circular
      executingInstruction = true;
      
    } else { // continue executing current instruction
    
      executingInstruction = !(executeMotion(model, instruction.getSpeedForExec(model)));
      if (!executingInstruction) {
        currentInstruction++;
        if (currentInstruction >= program.getInstructions().size()) return true;
      }
      //
    }
    //
  } // end of if instruction==motion instruction
  //
  return false;
} // end executeProgram



float clampAngle(float angle) {
  while (angle > TWO_PI) angle -= (TWO_PI);
  while (angle < 0) angle += (TWO_PI);
  return angle;
}
