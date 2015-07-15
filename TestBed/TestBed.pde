
PVector center, a, b, c;
ArrayList<PVector> points;
PVector[] plane = new PVector[3];

void setup() {
  size(800, 600, P3D);
  a = new PVector(200, 200, 0);
  b = new PVector(300, 100, -50);
  c = new PVector(400, 200, -400);
  plane = createPlaneFrom3Points(a, b, c);
  center = circleCenter(vectorConvertTo(a, plane[0], plane[1], plane[2]),
                        vectorConvertTo(b, plane[0], plane[1], plane[2]),
                        vectorConvertTo(c, plane[0], plane[1], plane[2]));
  center = vectorConvertFrom(center, plane[0], plane[1], plane[2]);
  points = createCircleRadius(a, b, c, 360);
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
  pushMatrix();
  translate(b.x, b.y, b.z);
  sphere(10);
  popMatrix();
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
  stroke(0, 255, 0);
  for (PVector p : points) {
    pushMatrix();
    translate(p.x, p.y, p.z);
    sphere(5);
    popMatrix();
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
  PVector[] plane = createPlaneFrom3Points(a, b, c);
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
  // to compute our points along the circumference
  float angle = 0;
  float angleInc = (PI*2.0)/(float)numPoints;
  ArrayList<PVector> points = new ArrayList<PVector>();
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


// Find the circle center of 3 points in 2D
PVector circleCenter(PVector a, PVector b, PVector c) {
  float yDeltaA = b.y - a.y;
  float xDeltaA = b.x - a.x;
  float yDeltaB = c.y - b.y;
  float xDeltaB = c.x - b.x;
  PVector center = new PVector(0,0,0);
  //if (xDeltaA == 0 || xDeltaB == 0) return null; // error condition
  if (xDeltaA == 0) xDeltaA = 0.00001;
  if (xDeltaB == 0) xDeltaB = 0.00001;
  float aSlope = yDeltaA / xDeltaA;
  float bSlope = yDeltaB / xDeltaB;
  //if (bSlope-aSlope == 0 || aSlope == 0) return null; // error condition 2
  if (aSlope == 0) aSlope = 0.00001;
  float sub = bSlope-aSlope;
  if (sub == 0) sub = 0.00001;
  center.x = (aSlope*bSlope*(a.y-c.y) + bSlope*(a.x+b.x) -
              aSlope*(b.x+c.x)) / (2*sub);
  center.y = -1*(center.x - (a.x+b.x)/2)/aSlope + (a.y+b.y)/2;
  center.z = a.z; // will have the same Z as the others b/c we're assuming 2D
  return center;
}
