
final int MTYPE_JOINT = 0, MTYPE_LINEAR = 1, MTYPE_CIRCULAR = 2;
final float SPEED_FINE = 0.0025;
final float SPEED_VFINE = 0.001;


PVector[] pr = new PVector[1000]; // global registers

public class Program {
  private String name;
  private ArrayList<Instruction> instructions;
  private PVector[] p = new PVector[1000]; // local registers
  
  public Program(String theName) {
    instructions = new ArrayList<Instruction>();
    for (int n = 0; n < p.length; n++) p[n] = new PVector();
    name = theName;
  }
  
  public ArrayList<Instruction> getInstructions() {
    return instructions;
  }
  
  public String getName(){
    return name;
  }
  
  public void addInstruction(Instruction i) {
    instructions.add(i);
  }
  
  public void addInstruction(int idx, Instruction i) {
    instructions.add(idx, i);
  }
  
  public void addRegister(PVector in, int idx) {
    if (idx >= 0 && idx < p.length) p[idx] = in;
  }
  
  public PVector getRegister(int idx) {
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
  
  public MotionInstruction(int m, int r, boolean g, float s, float t) {
    motionType = m;
    register = r;
    globalRegister = g;
    speed = s;
    termination = t;
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
  
  public PVector getVector(Program parent) {
    if (globalRegister) return pr[register];
    else return parent.p[register];
  }
  
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
