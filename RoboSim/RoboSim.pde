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

ArrayList<Program> tasks = new ArrayList<Program>();

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

public void setup() {
  size(1200, 800, P3D);
  cp5 = new ControlP5(this);
  gui();
  for (int n = 0; n < registers.length; n++) registers[n] = new PVector();
  for (int n = 0; n < 6; n++) jointsMoving[n] = 0;
  testModel = new ArmModel(ARM_TEST);
}

public void draw() {
  
  // TESTING CODE
  /*PVector testDest = new PVector();
  if (frameCount == 20) {
    pushMatrix();
    applyCamera();
    PVector start = calculateEndEffectorPosition(testModel, false);
    popMatrix();
    testModel.calculateIntermediatePositions(start, new PVector(575, 300, 50));
    testModel.calculatingArms = true;
  }
  // execute arm movement
  if (testModel.calculatingArms) {
    if (!testModel.movingArms) {
      int result = calculateIK(testModel,
                               testModel.intermediatePositions.get(
                                 testModel.interIdx),
                               720, 15);
      if (result == EXEC_SUCCESS) testModel.movingArms = true;
    } else {
      boolean allDone = testModel.interpolateRotation();
      if (allDone) {
        testModel.movingArms = false;
        testModel.calculatingArms = false;
        if (testModel.interIdx >= 0) {
          testModel.interIdx++;
          if (testModel.interIdx >= testModel.intermediatePositions.size())
            testModel.interIdx = -1;
        }
      }
    }
  } else if (testModel.interIdx >= 0) {
    testDest.x = testModel.intermediatePositions.get(testModel.interIdx).x;
    testDest.y = testModel.intermediatePositions.get(testModel.interIdx).y;
    testDest.z = testModel.intermediatePositions.get(testModel.interIdx).z;
    testModel.calculatingArms = true;
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
  /*stroke(255, 0, 0);
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

