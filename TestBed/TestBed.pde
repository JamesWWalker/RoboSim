
import java.util.*;

ArrayList<Arm> arms;

float eepx, eepy, eepz; // end effector current position
float edpx, edpy, edpz; // end effector desired position
boolean movingArms = false;

void setup() {
  size(800, 600, P3D);
  arms = new ArrayList<Arm>();
  arms.add(new Arm(100, PI/8.0, PI/4.0));
  arms.add(new Arm(100, PI/6.0, PI/6.0));
  arms.add(new Arm(100, PI/4.0, PI/8.0));
  calculateEndEffectorPosition();
}

void draw() {
  if (movingArms) {
    int result = calculateIK(360, 10);
    if (result == SUCCESS) movingArms = false;
  }
  
  background(255);
  noFill();
  
  pushMatrix();
  translate(400, 300, 0);
  // draw arms
  int curIdx = 0;
  for (Arm a : arms) {
    if (curIdx == armIdx) stroke(0, 0, 255);
    else stroke(0);
    float endX = a.length * sin(a.angleGround) * cos(a.angleAir);
    float endY = a.length * sin(a.angleGround) * sin(a.angleAir);
    float endZ = a.length * cos(a.angleGround);
    line(0, 0, 0, endX, endY, endZ);
    translate(endX, endY, endZ);
    rotateY(a.angleGround);
    rotateZ(a.angleAir);
    curIdx++;
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
}

int armIdx = -1;

void keyPressed() {
  if (keyCode == LEFT) edpx -= 5;
  else if (keyCode == RIGHT) edpx += 5;
  else if (keyCode == UP) edpy -= 5;
  else if (keyCode == DOWN) edpy += 5;
  else if (key == 'q') edpz += 5;
  else if (key == 'w') edpz -= 5;
  else if (key == ' ') movingArms = true; /* */
  
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

void calculateEndEffectorPosition() {
  
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

int PROCESSING = 0, FAILURE = 1, SUCCESS = 2;

int calculateIK(int slices, float closeEnough) {

  float checkAngle = (2*PI)/(float)slices;

  // loop through each arm segment in turn
  for (int a = 0; a < arms.size(); a++) {
    // figure out which ground angle of current arm segment causes
    // the arms' total endpoint to be closest to the EEDP
    calculateEndEffectorPosition();
    float closest = dist(eepx, eepy, eepz, edpx, edpy, edpz);
    float bestAngle = arms.get(a).angleGround;
    for (int n = 0; n < slices; n++) {
      arms.get(a).angleGround += checkAngle;
      calculateEndEffectorPosition();
      if (dist(eepx, eepy, eepz, edpx, edpy, edpz) < closest) {
        closest = dist(eepx, eepy, eepz, edpx, edpy, edpz);
        bestAngle = arms.get(a).angleGround;
      }
    }
    arms.get(a).angleGround = bestAngle;
    // repeat for air angles
    calculateEndEffectorPosition();
    closest = dist(eepx, eepy, eepz, edpx, edpy, edpz);
    bestAngle = arms.get(a).angleAir;
    for (int n = 0; n < slices; n++) {
      arms.get(a).angleAir += checkAngle;
      calculateEndEffectorPosition();
      if (dist(eepx, eepy, eepz, edpx, edpy, edpz) < closest) {
        closest = dist(eepx, eepy, eepz, edpx, edpy, edpz);
        bestAngle = arms.get(a).angleAir;
      }
    }
    arms.get(a).angleAir = bestAngle;
  } // end loop through arm segments
  
  // figure out where the end of all the arms is and
  // compare that to where we want it to be
  calculateEndEffectorPosition();
  if (dist(eepx, eepy, eepz, edpx, edpy, edpz) <= closeEnough)
    return SUCCESS;
  return PROCESSING; /* */
}

public class Arm {
  float length, angleGround, angleAir;
  
  public Arm(float l, float g, float a) {
    length = l;
    angleGround = g;
    angleAir = a;
  }
}
