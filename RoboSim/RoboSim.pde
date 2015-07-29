import controlP5.*;

import java.util.*;
import java.nio.*;

ArmModel armModel;
float lastMouseX, lastMouseY;
float cameraTX = 0, cameraTY = 0, cameraTZ = 0;
float cameraRX = 0, cameraRY = 0, cameraRZ = 0;
boolean spacebarDown = false;

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
int currentInstruction;
int EXEC_PROCESSING = 0, EXEC_FAILURE = 1, EXEC_SUCCESS = 2;

/*******************************/

public void setup() {
  size(1200, 800, P3D);
  cp5 = new ControlP5(this);
  gui();
  for (int n = 0; n < pr.length; n++) pr[n] = new Point();
  armModel = new ArmModel(ARM_STANDARD);
  // TESTING CODE
  createTestProgram();
  // END TESTING CODE
}

boolean doneMoving = false; // TESTING CODE

public void draw() {
  
  //lights();
  directionalLight(255, 255, 255, 1, 1, 0);
  ambientLight(150, 150, 150);

  background(127);
  //gui();
  // TESTING CODE
  /*if (frameCount == 20) {
    readyProgram();
  } else if (frameCount > 20) {
    if (!doneMoving) {
      doneMoving = executeProgram(currentProgram, armModel);
    }
  } /* */
  // END TESTING CODE

  armModel.moveJoints(); // respond to manual movement from J button presses

  cursor(cursorMode);
  hint(ENABLE_DEPTH_TEST);
  background(255);
  noStroke();
  noFill();
  pushMatrix();
  
  applyCamera();

  pushMatrix();
  armModel.draw();
  popMatrix();

  popMatrix();
  
  noLights();
  
  // TESTING CODE: DRAW INTERMEDIATE POINTS
  noStroke();
  pushMatrix();
  if (intermediatePositions != null) {
    for (PVector v : intermediatePositions) {
      pushMatrix();
      translate(v.x, v.y, v.z);
      sphere(10);
      popMatrix();
    }
  }
  popMatrix(); /* */
  // TESTING CODE: DRAW END EFFECTOR POSITION
  /*pushMatrix();
  PVector eep = calculateEndEffectorPosition(armModel, false);
  applyCamera();
  noFill();
  stroke(255, 0, 0);
  translate(eep.x, eep.y, eep.z);
  println(eep.x + ", " + eep.y + ", " + eep.z);
  sphere(50);
  popMatrix(); /* */
  // END TESTING CODE

  hint(DISABLE_DEPTH_TEST);
  
  //println(frameRate + " fps");
}

void applyCamera() {
  translate(width/1.5,height/1.5);
  translate(panX, panY); // for pan button
  scale(myscale);
  rotateX(myRotX); // for rotate button
  rotateY(myRotY); // for rotate button
}

