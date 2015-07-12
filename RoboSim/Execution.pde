
// To-do list:
// -> The speed control for executing motion instructions is pretty rough.
//    Make it better.
// -> Continuous motion seems to be working, but needs more thorough testing
// -> Make motion instructions follow different coordinate systems
// -> Add more sophisticated handling of failure possibility when calculating IK

void createTestProgram() {
  Program program = new Program("Test Program");
  MotionInstruction instruction =
    new MotionInstruction(MTYPE_LINEAR, 0, 1.0, TERM_CONT100);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 1, 1.0, TERM_CONT75);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 2, 1.0, TERM_CONT50);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 3, 0.25, TERM_CONT0);
  program.addInstruction(instruction);
  instruction = new MotionInstruction(MTYPE_LINEAR, 4, 0.25, TERM_FINE);
  program.addInstruction(instruction);
  registers[0] = new PVector(575, 300, 50);
  registers[1] = new PVector(625, 225, 50);
  registers[2] = new PVector(675, 200, 50);
  registers[3] = new PVector(725, 225, 50);
  registers[4] = new PVector(775, 300, 50);
  programs.add(program);
  currentProgram = program;
  
  Program program2 = new Program("Test Program 2");
  MotionInstruction instruction2 =
    new MotionInstruction(MTYPE_LINEAR, 0, 1.0, TERM_CONT100);
  program2.addInstruction(instruction2);
  instruction = new MotionInstruction(MTYPE_LINEAR, 1, 1.0, TERM_CONT75);
  programs.add(program2);
  //currentProgram = program;
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



public ArrayList<PVector> intermediatePositions;
int motionFrameCounter = 0;
float DISTANCE_BETWEEN_POINTS = 5.0;
int interMotionIdx = -1;



void calculateIntermediatePositions(PVector start, PVector end) {
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
  intermediatePositions = new ArrayList<PVector>();
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


float getContinuousPercentage(int term) {
  if (term == TERM_CONT50) return 0.5;
  else if (term == TERM_CONT75) return 0.75;
  else if (term == TERM_CONT100) return 1.0;
  return 0;
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
      PVector start = calculateEndEffectorPosition(testModel, false);
      popMatrix();
      if (instruction.getTerminationType() == TERM_FINE)
        beginNewLinearMotion(model, start, registers[instruction.getRegister()]);
      else {
        PVector nextPoint = null;
        for (int n = currentInstruction+1; n < program.getInstructions().size(); n++) {
          Instruction nextIns = program.getInstructions().get(n);
          if (nextIns instanceof MotionInstruction) {
            MotionInstruction castIns = (MotionInstruction)nextIns;
            nextPoint = registers[castIns.getRegister()];
          }
        }
        if (nextPoint == null) beginNewLinearMotion(
                               model, start, registers[instruction.getRegister()]);
        else {
          float percentage = getContinuousPercentage(instruction.getTerminationType());
          if (percentage <= 0) beginNewLinearMotion(
                               model, start, registers[instruction.getRegister()]);
          else beginNewContinuousMotion(model, start, registers[instruction.getRegister()],
                                        nextPoint, percentage);
        }
      }
      executingInstruction = true;
      
    } else { // continue executing current instruction
    
      executingInstruction = !(executeMotion(model, instruction.speed));
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
  while (angle > PI*2.0) angle -= (PI*2.0);
  while (angle < 0) angle += (PI*2.0);
  return angle;
}
