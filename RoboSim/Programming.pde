
final int MTYPE_JOINT = 0, MTYPE_LINEAR = 1, MTYPE_CIRCULAR = 2;


public class Point {
  public PVector c; // coordinates
  public PVector a; // angles
  public float[] j = new float[6]; // joint values
  
  public Point() {
    c = new PVector(0,0,0);
    a = new PVector(0,0,0);
    for (int n = 0; n < j.length; n++) j[n] = 0;
  }
  
  public Point(float x, float y, float z, float w, float p, float r,
               float j1, float j2, float j3, float j4, float j5, float j6)
  {
    c = new PVector(x,y,z);
    a = new PVector(w,p,r);
    j[0] = j1;
    j[1] = j2;
    j[2] = j3;
    j[3] = j4;
    j[4] = j5;
    j[5] = j6;
  }
  
  public Point clone() {
    return new Point(c.x, c.y, c.z, a.x, a.y, a.z, j[0], j[1], j[2], j[3], j[4], j[5]);
  }
  
} // end Point class


Point[] pr = new Point[1000]; // global registers

public class Program {
  private String name;
  private ArrayList<Instruction> instructions;
  private Point[] p = new Point[1000]; // local registers
  private int nextRegister;
  
  public Program(String theName) {
    instructions = new ArrayList<Instruction>();
    for (int n = 0; n < p.length; n++) p[n] = new Point();
    name = theName;
    nextRegister = 0;
  }
  
  public ArrayList<Instruction> getInstructions() {
    return instructions;
  }
  
  public String getName(){
    return name;
  }
  
  public void addInstruction(Instruction i) {
    instructions.add(i);
    if (i instanceof MotionInstruction ) {
      MotionInstruction castIns = (MotionInstruction)i;
      if (!castIns.getGlobal() && castIns.getRegister() >= nextRegister) {
        nextRegister = castIns.getRegister()+1;
        if (nextRegister >= p.length) nextRegister = p.length-1;
      }
    }
  }
  
  public void overwriteInstruction(int idx, Instruction i) {
    instructions.set(idx, i);
    nextRegister++;
  }
  
  public void addInstruction(int idx, Instruction i) {
    instructions.add(idx, i);
  }
  
  public void addRegister(Point in, int idx) {
    if (idx >= 0 && idx < p.length) p[idx] = in;
  }
  
  public int nextRegister() {
    return nextRegister;
  }
  
  public Point getRegister(int idx) {
    if (idx >= 0 && idx < p.length) return p[idx];
    else return null;
  }
  
} // end Program class

public class Instruction {
}

public class MotionInstruction extends Instruction {
  private int motionType;
  private int register;
  private boolean globalRegister;
  private float speed;
  private float termination;
  private int coordinateFrame;
  
  public MotionInstruction(int m, int r, boolean g, float s, float t, int c) {
    motionType = m;
    register = r;
    globalRegister = g;
    speed = s;
    termination = t;
    coordinateFrame = c;
  }
  
  public int getMotionType() { return motionType; }
  public void setMotionType(int in) { motionType = in; }
  public int getRegister() { return register; }
  public void setRegister(int in) { register = in; }
  public boolean getGlobal() { return globalRegister; }
  public void setGlobal(boolean in) { globalRegister = in; }
  public float getSpeed() { return speed; }
  public void setSpeed(float in) { speed = in; }
  public float getTermination() { return termination; }
  public void setTermination(float in) { termination = in; }
  
  public float getSpeedForExec(ArmModel model) {
    if (motionType == MTYPE_JOINT) return speed;
    else return (speed / model.motorSpeed);
  }
  
  // TODO: Fix to account for user/tool frames
  public Point getVector(Program parent) {
    if (coordinateFrame == COORD_WORLD ) {
      Point out;
      if (globalRegister) out = pr[register].clone();
      else out = parent.p[register].clone();
      out.c = convertWorldToNative(out.c);
      return out;
    } else {
      if (globalRegister) return pr[register];
      else return parent.p[register];
    }
  } // end getVector()
  
  public String toString(){
     String me = "";
     switch (motionType){
        case MTYPE_JOINT:
           me += "J ";
           break;
        case MTYPE_LINEAR:
           me += "L ";
           break;
        case MTYPE_CIRCULAR:
           me += "C ";
           break;
     }
     if (globalRegister) me += "PR[";
     else me += "P[";
     me += Integer.toString(register)+"] ";
     if (motionType == MTYPE_JOINT) me += Float.toString(speed * 100) + "%";
     else me += Integer.toString((int)speed) + "mm/s";
     if (termination == 0) me += "FINE";
     else me += "CONT" + (int)(termination*100);
     return me;
  } // end toString()
  
} // end MotionInstruction class

public class FrameInstruction extends Instruction {
}

public class CoordinateFrame {
  private PVector origin = new PVector();
  private PVector rotation = new PVector();
  
  public PVector getOrigin() { return origin; }
  public void setOrigin(PVector in) { origin = in; }
  public PVector getRotation() { return rotation; }
  public void setRotation(PVector in) { rotation = in; }
} // end FrameInstruction class
