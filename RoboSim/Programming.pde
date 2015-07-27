
final int MTYPE_JOINT = 0, MTYPE_LINEAR = 1, MTYPE_CIRCULAR = 2;
final int TERM_FINE = 0, TERM_CONT0 = 1, TERM_CONT50 = 2,
          TERM_CONT75 = 3, TERM_CONT100 = 4;
final float SPEED_FINE = 0.0025;
final float SPEED_VFINE = 0.001;


PVector[] pr = new PVector[999]; // global registers

public class Program {
  private String name;
  private ArrayList<Instruction> instructions;
  private PVector[] p = new PVector[999]; // local registers
  
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
  private int terminationType;
  
  public MotionInstruction(int m, int r, boolean g, float s, int t) {
    motionType = m;
    register = r;
    globalRegister = g;
    speed = s;
    terminationType = t;
  }
  
  public int getMotionType() { return motionType; }
  public void setMotionType(int in) { motionType = in; }
  public int getRegister() { return register; }
  public void setRegister(int in) { register = in; }
  public boolean getGlobal() { return globalRegister; }
  public void setGlobal(boolean in) { globalRegister = in; }
  public float getSpeed() { return speed; }
  public void setSpeed(float in) { speed = in; }
  public int getTerminationType() { return terminationType; }
  public void setTerminationType(int in) { terminationType = in; }
  
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
     me += Float.toString(speed * 100) + "% ";
     switch (terminationType){
        case TERM_FINE:
           me += "FINE ";
           break;
        case TERM_CONT0:
           me += "CONT0 ";
           break;
        case TERM_CONT50:
           me += "CONT50 ";
           break;
        case TERM_CONT75:
           me += "CONT75 ";
           break;   
        case TERM_CONT100:
           me += "CONT100 ";
           break;   
     } 
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
