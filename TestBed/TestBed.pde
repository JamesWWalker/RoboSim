
import java.util.*;

PVector center, a, b, c;
ArrayList<PVector> points;
PVector[] plane = new PVector[3];

void setup() {
  size(800, 600, P3D);
  a = new PVector(200, 200, 0);
  b = new PVector(300, 100, -50);
  c = new PVector(400, 200, -400);
  plane = createPlaneFrom3Points(a, b, c);
  PVector acon = vectorConvertTo(a, plane[0], plane[1], plane[2]);
  PVector bcon = vectorConvertTo(b, plane[0], plane[1], plane[2]);
  PVector ccon = vectorConvertTo(c, plane[0], plane[1], plane[2]);
  center = circleCenter(acon, bcon, ccon);
  center = vectorConvertFrom(center, plane[0], plane[1], plane[2]);
  points = createCircleRadius(a, b, c, 255);
  points = createArc(points, a, b, c);
}


void draw() {
  background(255);
  strokeWeight(5);
  
  // native coordinates
  stroke(255, 0, 0);
  line(0, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, 0, 0, 100, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 100);
  
  // transformed coordinates
  pushMatrix();
  translate(width/2, height/2);
  stroke(255, 0, 0);
  line(0, 0, 0, 100*plane[0].x, 100*plane[0].y, 100*plane[0].z);
  stroke(0, 255, 0);
  line(0, 0, 0, 100*plane[1].x, 100*plane[1].y, 100*plane[1].z);
  stroke(0, 0, 255);
  line(0, 0, 0, 100*plane[2].x, 100*plane[2].y, 100*plane[2].z);
  popMatrix();
  
  // 3 points + center
  stroke(255, 0, 0);
  pushMatrix();
  translate(a.x, a.y, a.z);
  sphere(10);
  popMatrix();
  stroke(195, 60, 60);
  pushMatrix();
  translate(b.x, b.y, b.z);
  sphere(10);
  popMatrix();
  stroke(135, 120, 120);
  pushMatrix();
  translate(c.x, c.y, c.z);
  sphere(10);
  popMatrix();
  stroke(0, 0, 255);
  pushMatrix();
  translate(center.x, center.y, center.z);
  sphere(10);
  popMatrix();
  
  // circle circumference
  int alpha = 255;
  for (PVector p : points) {
    stroke(0, 255, 0, alpha);
    pushMatrix();
    translate(p.x, p.y, p.z);
    sphere(5);
    popMatrix();
    alpha--;
  }
  
}

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
ArrayList<PVector> createCircleRadius(PVector a,
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
  float angleInc = (PI*2.0)/(float)numPoints;
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
      println("Had to reverse it");
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
      if (!seenC) newPoints.add(pt);
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



float clampAngle(float angle) {
  while (angle > PI*2.0) angle -= (PI*2.0);
  while (angle < 0) angle += (PI*2.0);
  return angle;
}
