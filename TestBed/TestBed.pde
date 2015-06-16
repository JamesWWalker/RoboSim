
import java.util.*;

ArrayList<Arm> arms;

float eepx, eepy, eepz; // end effector current position
float edpx, edpy, edpz; // end effector desired position
float etpx, etpy, etpz; // end effector position based on working joint rotations
boolean calculatingArms = false, movingArms = false;

void setup() {
  size(800, 600, P3D);
  arms = new ArrayList<Arm>();
  arms.add(new Arm(100, PI/8.0, PI/4.0));
  arms.add(new Arm(100, PI/6.0, PI/6.0));
  arms.add(new Arm(100, PI/4.0, PI/8.0));
  calculateCurrentEndEffectorPosition();
}

void draw() {
  if (calculatingArms) {
    if (!movingArms) {
      int result = calculateIK(360, 10);
      if (result == SUCCESS) movingArms = true;
    } else {
      boolean allDone = interpolateArms();
      calculateCurrentEndEffectorPosition();
      if (allDone) {
        movingArms = false;
        calculatingArms = false;
      }
    }
  }
  
  background(255);
  noFill();
  
  // draw arms
  pushMatrix();
  translate(400, 300, 0);
  for (Arm a : arms) {
    stroke(0);
    float endX = a.length * sin(a.angleGround) * cos(a.angleAir);
    float endY = a.length * sin(a.angleGround) * sin(a.angleAir);
    float endZ = a.length * cos(a.angleGround);
    line(0, 0, 0, endX, endY, endZ);
    translate(endX, endY, endZ);
    rotateY(a.angleGround);
    rotateZ(a.angleAir);
  }
  popMatrix();
  // draw "target" arms
  pushMatrix();
  translate(400, 300, 0);
  for (Arm a : arms) {
    stroke(0, 0, 255);
    float endX = a.length * sin(a.angleGroundTarget) * cos(a.angleAirTarget);
    float endY = a.length * sin(a.angleGroundTarget) * sin(a.angleAirTarget);
    float endZ = a.length * cos(a.angleGroundTarget);
    line(0, 0, 0, endX, endY, endZ);
    translate(endX, endY, endZ);
    rotateY(a.angleGroundTarget);
    rotateZ(a.angleAirTarget);
  }
  popMatrix();
  // draw end effector position
  stroke(0);
  pushMatrix();
  translate(400, 300);
  translate(eepx, eepy, eepz);
  sphere(15);
  popMatrix(); /**/
  // draw desired end effector position
  pushMatrix();
  stroke(255, 0, 0);
  translate(400, 300, 0);
  translate(edpx, edpy, edpz);
  sphere(15);
  popMatrix();
  // draw "working" end effector position
  pushMatrix();
  stroke(0, 0, 255);
  translate(400, 300, 0);
  translate(etpx, etpy, etpz);
  sphere(15);
  popMatrix();
}

int armIdx = -1;

void keyPressed() {
  if (keyCode == LEFT) edpx -= 5;
  else if (keyCode == RIGHT) edpx += 5;
  else if (keyCode == UP) edpy -= 5;
  else if (keyCode == DOWN) edpy += 5;
  else if (key == 'q') edpz += 5;
  else if (key == 'w') edpz -= 5;
  else if (key == ' ') calculatingArms = true; /* */
  
/*  if (keyCode == LEFT) armIdx--;
  else if (keyCode == RIGHT) armIdx++;
  else if (keyCode == UP) arms.get(armIdx).angleGround -= 0.05;
  else if (keyCode == DOWN) arms.get(armIdx).angleGround += 0.05;
  else if (key == 'q') arms.get(armIdx).angleAir -= 0.05;
  else if (key == 'w') arms.get(armIdx).angleAir += 0.05;
  
  if (armIdx < 0) armIdx = arms.size() - 1;
  else if (armIdx >= arms.size()) armIdx = 0;
  
  calculateEndEffectorPosition(); /* */
}

void calculateCurrentEndEffectorPosition() {
  pushMatrix();
  for (Arm a : arms) {
    float endX = a.length * sin(a.angleGround) * cos(a.angleAir);
    float endY = a.length * sin(a.angleGround) * sin(a.angleAir);
    float endZ = a.length * cos(a.angleGround);
    translate(endX, endY, endZ);
    rotateY(a.angleGround);
    rotateZ(a.angleAir);
    eepx = modelX(0, 0, 0);
    eepy = modelY(0, 0, 0);
    eepz = modelZ(0, 0, 0);
  }
  popMatrix();
}

void calculateTargetEndEffectorPosition() {
  pushMatrix();
  for (Arm a : arms) {
    float endX = a.length * sin(a.angleGroundTarget) * cos(a.angleAirTarget);
    float endY = a.length * sin(a.angleGroundTarget) * sin(a.angleAirTarget);
    float endZ = a.length * cos(a.angleGroundTarget);
    translate(endX, endY, endZ);
    rotateY(a.angleGroundTarget);
    rotateZ(a.angleAirTarget);
    etpx = modelX(0, 0, 0);
    etpy = modelY(0, 0, 0);
    etpz = modelZ(0, 0, 0);
  }
  popMatrix();
}


int PROCESSING = 0, FAILURE = 1, SUCCESS = 2;

int calculateIK(int slices, float closeEnough) {

  float checkAngle = (2*PI)/(float)slices;
  
  // loop through each arm segment in turn
  for (int a = 0; a < arms.size(); a++) {
    // figure out which ground angle of current arm segment causes
    // the arms' total endpoint to be closest to the EEDP
    calculateTargetEndEffectorPosition();
    float closest = dist(etpx, etpy, etpz, edpx, edpy, edpz);
    float bestAngle = arms.get(a).angleGroundTarget;
    for (int n = 0; n < slices; n++) {
      arms.get(a).angleGroundTarget += checkAngle;
      calculateTargetEndEffectorPosition();
      if (dist(etpx, etpy, etpz, edpx, edpy, edpz) < closest) {
        closest = dist(etpx, etpy, etpz, edpx, edpy, edpz);
        bestAngle = arms.get(a).angleGroundTarget;
      }
    }
    bestAngle = clampAngle(bestAngle);
    arms.get(a).angleGroundTarget = bestAngle;
    // repeat for air angles
    calculateTargetEndEffectorPosition();
    closest = dist(etpx, etpy, etpz, edpx, edpy, edpz);
    bestAngle = arms.get(a).angleAirTarget;
    for (int n = 0; n < slices; n++) {
      arms.get(a).angleAirTarget += checkAngle;
      calculateTargetEndEffectorPosition();
      if (dist(etpx, etpy, etpz, edpx, edpy, edpz) < closest) {
        closest = dist(etpx, etpy, etpz, edpx, edpy, edpz);
        bestAngle = arms.get(a).angleAirTarget;
      }
    }
    bestAngle = clampAngle(bestAngle);
    arms.get(a).angleAirTarget = bestAngle;
  } // end loop through arm segments
  
  // figure out where the end of all the arms is and
  // compare that to where we want it to be
  calculateTargetEndEffectorPosition();
  if (dist(etpx, etpy, etpz, edpx, edpy, edpz) <= closeEnough) {
    // calculate whether it's faster to turn CW or CCW
    for (Arm a : arms) {
      // ground
      float blueAngle = a.angleGroundTarget - a.angleGround;
      blueAngle = clampAngle(blueAngle);
      if (blueAngle < PI) a.angleGroundDirection = 1;
      else a.angleGroundDirection = -1;
      // air
      blueAngle = a.angleAirTarget - a.angleAir;
      blueAngle = clampAngle(blueAngle);
      if (blueAngle < PI) a.angleAirDirection = 1;
      else a.angleAirDirection = -1;
    }
    return SUCCESS;
  } return PROCESSING; /* */
}

float ARM_ROTATION_SPEED = 0.01;

boolean interpolateArms() {
  // DEBUG
  println("GROUND: " + arms.get(0).angleGround + " / " + arms.get(0).angleGroundTarget);
  println("AIR: " + arms.get(0).angleAir + " / " + arms.get(0).angleAirTarget);
   // END DEBUG
  boolean allDone = true;
  for (int a = 0; a < arms.size(); a++) {
    if (abs(arms.get(a).angleGround - arms.get(a).angleGroundTarget) > 0.02) {
      allDone = false;
      arms.get(a).angleGround += ARM_ROTATION_SPEED * arms.get(a).angleGroundDirection;
      arms.get(a).angleGround = clampAngle(arms.get(a).angleGround);
    }
    if (abs(arms.get(a).angleAir - arms.get(a).angleAirTarget) > 0.02) {
      allDone = false;
      arms.get(a).angleAir += ARM_ROTATION_SPEED * arms.get(a).angleAirDirection;
      arms.get(a).angleAir = clampAngle(arms.get(a).angleAir);
    }
  }
  return allDone;
}


float clampAngle(float angle) {
  while (angle > PI*2.0) angle -= (PI*2.0);
  while (angle < 0) angle += (PI*2.0);
  return angle;
}


public class Arm {
  public float length, angleGround, angleAir, angleGroundTarget, angleAirTarget;
  int angleGroundDirection, angleAirDirection;
  
  public Arm(float l, float g, float a) {
    length = l;
    angleGround = angleGroundTarget = g;
    angleAir = angleAirTarget = a;
  }
}
