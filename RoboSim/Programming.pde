
public class Program {
  private ArrayList<Instruction> instructions;
  
  public Program() {
    instructions = new ArrayList<Instruction>();
  }
  
  public ArrayList<Instruction> getInstructions() {
    return instructions;
  }
  
  public void addInstruction(Instruction i) {
    instructions.add(i);
  }
  
  public void addInstruction(int idx, Instruction i) {
    instructions.add(idx, i);
  }
}

public class Instruction {
}

public class MotionInstruction extends Instruction {
  private int motionType;
  private int register;
  private float speed;
  private int terminationType;
  
  public MotionInstruction(int m, int r, float s, int t) {
    motionType = m;
    register = r;
    speed = s;
    terminationType = t;
  }
  
  public int getMotionType() { return motionType; }
  public void setMotionType(int in) { motionType = in; }
  public int getRegister() { return register; }
  public void setRegister(int in) { register = in; }
  public float getSpeed() { return speed; }
  public void setSpeed(float in) { speed = in; }
  public int getTerminationType() { return terminationType; }
  public void setTerminationType(int in) { terminationType = in; }
}

public class FrameInstruction extends Instruction {
}

public class CoordinateFrame {
  private PVector origin = new PVector();
  private PVector rotation = new PVector();
  
  public PVector getOrigin() { return origin; }
  public void setOrigin(PVector in) { origin = in; }
  public PVector getRotation() { return rotation; }
  public void setRotation(PVector in) { rotation = in; }
}
