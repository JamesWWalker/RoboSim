
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


float clampAngle(float angle) {
  while (angle > PI*2.0) angle -= (PI*2.0);
  while (angle < 0) angle += (PI*2.0);
  return angle;
}
