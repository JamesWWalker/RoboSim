import controlP5.*;

import java.util.*;
import java.nio.*;

ArmModel testModel;
float lastMouseX, lastMouseY;
float cameraTX = 0, cameraTY = 0, cameraTZ = 0;
float cameraRX = 0, cameraRY = 0, cameraRZ = 0;
boolean spacebarDown = false;
float[] jointsMoving = new float[6];

ControlP5 cp5;
Textarea myTextarea;
Accordion accordion;

ArrayList<Program> programs = new ArrayList<Program>();

/* global variables for toolbar */

// for pan button
int cursorMode = ARROW;
int clickPan = 0;
float panX = 1.0; 
float panY = 1.0;
boolean doPan = false;

// for rotate button
int clickRotate = 0;
float myRotX = 0.0;
float myRotY = 0.0;
boolean doRotate = false;

float myscale = 0.5;
/*******************************/

/* other global variables      */

// for Execution
Program currentProgram;
int EXEC_PROCESSING = 0, EXEC_FAILURE = 1, EXEC_SUCCESS = 2;
// for GUI
final int FRAME_JOINT = 0, 
          FRAME_JGFRM = 1, 
          FRAME_WORLD = 2, 
          FRAME_TOOL = 3, 
          FRAME_USER = 4;
int frame = FRAME_JOINT;
String displayFrame = "JOINT";

final int OFF = 0, ON = 1;
int shift = OFF; 

int active_program = -1; // which program is active? Default: no program is active
//for Programming
final int MTYPE_JOINT = 0, MTYPE_LINEAR = 1, MTYPE_CIRCULAR = 2;
final int TERM_FINE = 0, TERM_CONT = 1;
final float SPEED_FINE = 0.0025;
final float SPEED_VFINE = 0.001;
PVector[] registers = new PVector[999];

/*******************************/

public void setup() {
  size(1200, 800, P3D);
  cp5 = new ControlP5(this);
  gui();
  for (int n = 0; n < registers.length; n++) registers[n] = new PVector();
  for (int n = 0; n < 6; n++) jointsMoving[n] = 0;
  testModel = new ArmModel(ARM_TEST);
}

boolean doneMoving = false; // TESTING CODE

public void draw() {
  
  // TESTING CODE
  /*PVector testDest = new PVector();
  if (frameCount == 20) {
    pushMatrix();
    applyCamera();
    PVector start = calculateEndEffectorPosition(testModel, false);
    popMatrix();
    //testModel.calculateIntermediatePositions(start, new PVector(575, 300, 50));
    testModel.beginNewLinearMotion(start, new PVector(575, 300, 50));
    //testModel.calculatingArms = true;
  } else if (frameCount > 20) {
    // execute arm movement
    if (!doneMoving) doneMoving = testModel.executeLinearMotion(1.0);
  } /* */
  // END TESTING CODE
  
  moveJoints(); // respond to manual movement from J button presses
  
  cursor(cursorMode);
  hint(ENABLE_DEPTH_TEST);
  background(255);
  stroke(100, 100, 255);
  noFill();
  pushMatrix();
  
  applyCamera();
  
  pushMatrix();
  testModel.draw();
  popMatrix();
  
  //PVector eep = calculateEndEffectorPosition(testModel, false);
  popMatrix();
  
  // TESTING CODE: DRAW INTERMEDIATE POINTS
  stroke(255, 0, 0);
  pushMatrix();
  if (testModel.intermediatePositions != null) {
    for (PVector v : testModel.intermediatePositions) {
      pushMatrix();
      translate(v.x, v.y, v.z);
      sphere(10);
      popMatrix();
    }
  }
  popMatrix(); /* */
  // END TESTING CODE
  
  hint(DISABLE_DEPTH_TEST);
}

void applyCamera() {
  translate(width/1.5,height/1.5);
  translate(panX, panY); // for pan button
  scale(myscale);
  rotateX(myRotX); // for rotate button
  rotateY(myRotY); // for rotate button
}

