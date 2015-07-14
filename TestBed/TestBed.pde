
import java.util.*;

PVector a, b, c, circleCenter;
ArrayList<PVector> circle = new ArrayList<PVector>();

void setup() {
  size(800, 600);
  a = new PVector(200, 200);
  b = new PVector(300, 100);
  c = new PVector(500, 200);
  circleCenter = circleCenter(a, b, c);
  circle = createCircleRadius(circleCenter, circleCenter.z, 360);
}

void draw() {
  background(255);
  fill(255, 0, 0);
  stroke(255, 0, 0);
  ellipse(a.x, a.y, 20, 20);
  ellipse(b.x, b.y, 20, 20);
  ellipse(c.x, c.y, 20, 20);
  fill(0, 0, 255);
  stroke(0, 0, 255);
  ellipse(circleCenter.x, circleCenter.y, 20, 20);
  fill(0, 255, 0);
  stroke(0, 255, 0);
  for (PVector p : circle) ellipse(p.x, p.y, 5, 5);
}

PVector circleCenter(PVector a, PVector b, PVector c) {
  float yDeltaA = b.y - a.y;
  float xDeltaA = b.x - a.x;
  float yDeltaB = c.y - b.y;
  float xDeltaB = c.x - b.x;
  PVector center = new PVector(0,0,0);
  if (xDeltaA == 0 || xDeltaB == 0) return null; // error condition
  float aSlope = yDeltaA / xDeltaA;
  float bSlope = yDeltaB / xDeltaB;
  if (bSlope-aSlope == 0 || aSlope == 0) return null; // error condition 2
  center.x = (aSlope*bSlope*(a.y-c.y) + bSlope*(a.x+b.x) -
              aSlope*(b.x+c.x)) / (2*(bSlope-aSlope));
  center.y = -1*(center.x - (a.x+b.x)/2)/aSlope + (a.y+b.y)/2;
  center.z = dist(center.x, center.y, a.x, a.y); // this actually contains the radius
  return center;
}

ArrayList<PVector> createCircleRadius(PVector center, float radius, int numPoints) {
  float angle = 0;
  float angleInc = (PI*2.0)/(float)numPoints;
  ArrayList<PVector> points = new ArrayList<PVector>();
  for (int n = 0; n < numPoints; n++) {
    points.add(new PVector(radius * cos(angle) + center.x,
                           radius * sin(angle) + center.y));
    angle += angleInc;
  }
  return points;
}
