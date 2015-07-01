void gui(){
   //cp5 = new ControlP5(this);
   
   // group 1: simulator pad
   Group g1 = cp5.addGroup("group1")
                 .setPosition(5,5)
                 .setBackgroundColor(color(127,127,127))
                 .setBackgroundHeight(740)   
                 ;
   g1.setOpen(true); 
                 
   // create five functional buttons
   int fnWidth = 40;
   int fnHeight = 40;
   
   cp5.addButton("Prev")
      .setValue(1)
      .setPosition(20,310)
      .setSize(fnWidth, fnHeight)
      .setColorBackground(color(255,255,255))
      .setColorCaptionLabel(color(0,0,0))
      .moveTo(g1);
      
   cp5.addButton("F1")
      .setValue(1)
      .setPosition(80,300)
      .setSize(fnWidth, fnHeight)
      .setColorBackground(color(255,255,255))
      .setColorCaptionLabel(color(0,0,0))
      .moveTo(g1);
  
   cp5.addButton("F2")
      .setValue(2)
      .setPosition(140,300)
      .setSize(fnWidth, fnHeight)
      .setColorBackground(color(255,255,255))
      .setColorCaptionLabel(color(0,0,0))
      .moveTo(g1);
  
   cp5.addButton("F3")
      .setValue(2)
      .setPosition(200,300)
      .setSize(fnWidth, fnHeight)
      .setColorBackground(color(255,255,255))
      .setColorCaptionLabel(color(0,0,0))
      .moveTo(g1);
      
   cp5.addButton("F4")
      .setValue(2)
      .setPosition(260,300)
      .setSize(fnWidth, fnHeight)
      .setColorBackground(color(255,255,255))
      .setColorCaptionLabel(color(0,0,0))   
      .moveTo(g1);
   
   cp5.addButton("F5")
      .setValue(2)
      .setPosition(320,300)
      .setSize(fnWidth, fnHeight)  
      .setColorBackground(color(255,255,255))
      .setColorCaptionLabel(color(0,0,0))
      .moveTo(g1);
        
   cp5.addButton("Next")
      .setValue(1)
      .setPosition(380,310)
      .setSize(fnWidth, fnHeight)
      .setColorBackground(color(255,255,255))
      .setColorCaptionLabel(color(0,0,0))
      .moveTo(g1);
      
      cp5.addGroup("txt-g")
      .setPosition(49,19)
      .hideBar()
      .setBackgroundHeight(273)
      .setWidth(342)
      .setBackgroundColor(color(0,0,0))
      .moveTo(g1) ; 
      
   myTextarea = cp5.addTextarea("txt")
      .setPosition(50,20)
      .setSize(340,270)
      .setLineHeight(14)
      .setColor(color(128))
      .setColorBackground(color(255,255,255))
      .setColorForeground(color(0,0,0))
      .setBorderColor(color(255,0,0))
      .moveTo(g1);
   myTextarea.setText("hello world");
   
   
   // add 11 bangs to the left of display
   cp5.addBang("bang1")  // bang 1
      .setPosition(25,30)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);
      
   cp5.addBang("bang2")  // bang 2
      .setPosition(25,52)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);   
      
   cp5.addBang("bang3")  // bang 3
      .setPosition(25,74)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);      
   
   cp5.addBang("bang4")  // bang 4
      .setPosition(25,96)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);  
      
   cp5.addBang("bang5")  // bang 5
      .setPosition(25,118)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);     
      
   cp5.addBang("bang6")  // bang 6
      .setPosition(25,140)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1); 
      
   cp5.addBang("bang7")  // bang 7
      .setPosition(25,162)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);
      
   cp5.addBang("bang8")  // bang 8
      .setPosition(25,184)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1); 
    
   cp5.addBang("bang9")  // bang 9
      .setPosition(25,206)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);  
      
   cp5.addBang("10")  // bang 10
      .setPosition(25,228)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);  
      
   cp5.addBang("11")  // bang 11
      .setPosition(25,250)
      .setSize(20,10)
      .setLabelVisible(false) 
      .moveTo(g1);
      
   cp5.addBang("bang12")
      .setPosition(395,30)
      .setSize(30,30)
      .setLabelVisible(false)    
      .moveTo(g1);
      
   cp5.addBang("bang13")
      .setPosition(395,70)
      .setSize(30,30)
      .setLabelVisible(false)    
      .moveTo(g1);   
      
   cp5.addBang("bang14")
      .setPosition(395,110)
      .setSize(30,30)
      .setLabelVisible(false) 
      .setColorBackground(color(255, 0,0)) 
      .moveTo(g1);   
      
   cp5.addGroup("g1-1")
      .setPosition(8,355)
      .hideBar()
      .setBackgroundHeight(380)
      .setWidth(425)
      .setBackgroundColor(color(0,0,0))
      .moveTo(g1) ;  
      
   cp5.addGroup("g1-2")
                   .setPosition(10,357)
                   .hideBar()
                   .setBackgroundHeight(376)
                   .setWidth(421)
                   .setBackgroundColor(color(127,127,127))
                   .moveTo(g1) ;     
    
    cp5.addButton("LSHIFT")
       .setPosition(62,365)
       .setSize(fnWidth+5, fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255)) 
       .moveTo(g1);
       
    cp5.addButton("RSHIFT")
       .setPosition(343,365)
       .setSize(fnWidth+5, fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);   
       
    cp5.addButton("Menu")
       .setPosition(117,368)
       .setSize(fnWidth, fnHeight+2)
       .setColorBackground(color(255,255,255))
       .setColorCaptionLabel(color(0,0,0))  
       .moveTo(g1);   
       
    cp5.addButton("Select")
       .setPosition(117 + fnWidth+2+5,368)
       .setSize(fnWidth, fnHeight+2)
       .setColorBackground(color(255,255,255))
       .setColorCaptionLabel(color(0,0,0))  
       .moveTo(g1);    
       
    cp5.addButton("Edit")
       .setPosition(117 +2*(fnWidth+2) + 5,368)
       .setSize(fnWidth, fnHeight+2)
       .setColorBackground(color(255,255,255))
       .setColorCaptionLabel(color(0,0,0))  
       .moveTo(g1);    
       
    cp5.addButton("Data")
       .setPosition(117 +3*(fnWidth+2) + 5,368)
       .setSize(fnWidth, fnHeight+2)
       .setColorBackground(color(255,255,255))
       .setColorCaptionLabel(color(0,0,0))  
       .moveTo(g1);    
      
    cp5.addButton("Fctn")
       .setPosition(117 +4*(fnWidth+2) + 10,368)
       .setSize(fnWidth, fnHeight+2)
       .setColorBackground(color(255,255,255))
       .setColorCaptionLabel(color(0,0,0))  
       .moveTo(g1); 
       
    PImage[] imgs_hold = {loadImage("images/hold.png"), loadImage("images/hold.png"), loadImage("images/hold.png")};   
    cp5.addButton("HOLD")
       .setPosition(262,440)
       .setSize(fnWidth+5,fnHeight+5)
       .setImages(imgs_hold)
       .updateSize() 
       .moveTo(g1); 
     
    cp5.addButton("j1_neg")
       .setPosition(262 + fnWidth+5+2,440)
       .setSize(fnWidth+5,fnHeight+5)
       .setCaptionLabel("-X\n(J1)")
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
     
    cp5.addButton("j1_pos")
       .setPosition(262 + 2*(fnWidth+5+2),440)
       .setSize(fnWidth+5,fnHeight+5)
       .setCaptionLabel("+X\n(J1)")
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);
    
       
    PImage[] imgs_fwd = {loadImage("images/fwd.png"), loadImage("images/fwd.png"), loadImage("images/fwd.png")};     
    cp5.addButton("FWD")
       .setPosition(262,440+fnHeight+7)
       .setSize(fnWidth+5,fnHeight+5)
       .setImages(imgs_fwd)
       .updateSize()  
       .moveTo(g1); 
     
    cp5.addButton("j2_neg")
       .setPosition(262 + fnWidth+5+2,440+fnHeight+7)
       .setSize(fnWidth+5,fnHeight+5)
       .setCaptionLabel("-Y\n(J2)")
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
     
    cp5.addButton("j2_pos")
       .setPosition(262 + 2*(fnWidth+5+2),440+fnHeight+7)
       .setSize(fnWidth+5,fnHeight+5)
       .setCaptionLabel("+Y\n(J2)")
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);  
    
    PImage[] imgs_bwd = {loadImage("images/bwd.png"), loadImage("images/bwd.png"), loadImage("images/bwd.png")};   
    cp5.addButton("BWD")
       .setPosition(262,440+2*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setImages(imgs_bwd)
       .updateSize() 
       .moveTo(g1); 
     
    cp5.addButton("j3_neg")
       .setPosition(262 + fnWidth+5+2,440+2*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setCaptionLabel("-Z\n(J3)")
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
     
    cp5.addButton("j3_pos")
       .setPosition(262 + 2*(fnWidth+5+2),440+2*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setCaptionLabel("+Z\n(J3)")
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);     
       
    cp5.addButton("COORD")
       .setPosition(262,440+3*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(150,150,255))
       .setColorCaptionLabel(color(0,0,0))  
       .moveTo(g1); 
     
    cp5.addButton("-X\n(J4)")
       .setPosition(262 + fnWidth+5+2,440+3*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
     
    cp5.addButton("+X\n(J4)")
       .setPosition(262 + 2*(fnWidth+5+2),440+3*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);     
       
    PImage[] imgs_positive_percent = {loadImage("images/positive_percent.png"), loadImage("images/positive_percent.png"), loadImage("images/positive_percent.png")};      
    cp5.addButton("+%")
       .setPosition(262,440+4*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setImages(imgs_positive_percent)
       .updateSize() 
       .moveTo(g1); 
     
    cp5.addButton("-Y\n(J5)")
       .setPosition(262 + fnWidth+5+2,440+4*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
     
    cp5.addButton("+Y\n(J5)")
       .setPosition(262 + 2*(fnWidth+5+2),440+4*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);     
       
    PImage[] imgs_negative_percent = {loadImage("images/negative_percent.png"), loadImage("images/negative_percent.png"), loadImage("images/negative_percent.png")};     
    cp5.addButton("-%")
       .setPosition(262,440+5*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setImages(imgs_negative_percent) 
       .updateSize()
       .moveTo(g1); 
     
    cp5.addButton("-Z\n(J6)")
       .setPosition(262 + fnWidth+5+2,440+5*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
     
    cp5.addButton("+Z\n(J6)")
       .setPosition(262 + 2*(fnWidth+5+2),440+5*(fnHeight+7))
       .setSize(fnWidth+5,fnHeight+5)
       .setColorBackground(color(0,0,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);   
     
    cp5.addButton("RESET")
       .setPosition(65,507)
       .setSize(40,30)
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;
       
    PImage[] imgs_LEFT = {loadImage("images/LEFT.png"), loadImage("images/LEFT.png"), loadImage("images/LEFT.png")};   
    cp5.addButton("LEFT")
       .setPosition(65+40+2,507)
       .setSize(40,30)
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .setImages(imgs_LEFT)
       .updateSize()
       .moveTo(g1) ;   
       
    cp5.addButton("Item")
       .setPosition(65+2*(40+2),507)
       .setSize(40,30)
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
       
    cp5.addButton("ENTER")
       .setPosition(65+3*(40+2),507)
       .setSize(40,30)
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;     
      
    cp5.addButton("num7")
       .setPosition(65,507+30+2)
       .setSize(40,30)
       .setCaptionLabel("7")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;
       
    cp5.addButton("num8")
       .setPosition(65+40+2,507+30+2)
       .setSize(40,30)
       .setCaptionLabel("8")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;   
       
    cp5.addButton("num9")
       .setPosition(65+2*(40+2),507+30+2)
       .setSize(40,30)
       .setCaptionLabel("9")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
       
    cp5.addButton("tool1")
       .setPosition(65+3*(40+2),507+30+2)
       .setSize(40,30)
       .setCaptionLabel("Tool1")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
     
    cp5.addButton("num4")
       .setPosition(65,507+2*(30+2))
       .setSize(40,30)
       .setCaptionLabel("4")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;
       
    cp5.addButton("num5")
       .setPosition(65+40+2,507+2*(30+2))
       .setSize(40,30)
       .setCaptionLabel("5")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;   
       
    cp5.addButton("num6")
       .setPosition(65+2*(40+2),507+2*(30+2))
       .setSize(40,30)
       .setCaptionLabel("6")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
       
    cp5.addButton("tool2")
       .setPosition(65+3*(40+2),507+2*(30+2))
       .setSize(40,30)
       .setCaptionLabel("Tool2")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
     
    cp5.addButton("num1")
       .setPosition(65,507+3*(30+2))
       .setSize(40,30)
       .setCaptionLabel("1")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;
       
    cp5.addButton("num2")
       .setPosition(65+40+2,507+3*(30+2))
       .setSize(40,30)
       .setCaptionLabel("1")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;   
       
    cp5.addButton("num3")
       .setPosition(65+2*(40+2),507+3*(30+2))
       .setSize(40,30)
       .setCaptionLabel("3")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
       
    cp5.addButton("move")
       .setPosition(65+3*(40+2),507+3*(30+2))
       .setSize(40,30)
       .setCaptionLabel("Move\nMenu")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;    
       
    cp5.addButton("num0")
       .setPosition(65,507+4*(30+2))
       .setSize(40,30)
       .setCaptionLabel("0")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;
       
    cp5.addButton("period")
       .setPosition(65+40+2,507+4*(30+2))
       .setSize(40,30)
       .setCaptionLabel(".")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;   
       
    cp5.addButton("comma")
       .setPosition(65+2*(40+2),507+4*(30+2))
       .setSize(40,30)
       .setCaptionLabel(",")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
       
    cp5.addButton("Setup")
       .setPosition(65+3*(40+2),507+4*(30+2))
       .setSize(40,30)
       .setCaptionLabel("SetUp")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;      
       
    cp5.addButton("-")
       .setPosition(65,507+5*(30+2))
       .setSize(40,30)
       .setCaptionLabel("-")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;
       
    cp5.addButton("posn")
       .setPosition(65+40+2,507+5*(30+2))
       .setSize(40,30)
       .setCaptionLabel("Posn")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;   
       
    cp5.addButton("no")
       .setPosition(65+2*(40+2),507+5*(30+2))
       .setSize(40,30)
       .setCaptionLabel("NO")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
       
    cp5.addButton("status")
       .setPosition(65+3*(40+2),507+5*(30+2))
       .setSize(40,30)
       .setCaptionLabel("Status")
       .setColorBackground(color(210,200,180))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;    
       
    cp5.addButton("step")
       .setPosition(67,467)
       .setSize(35,35)
       .setCaptionLabel("Step")
       .setColorBackground(color(150,150,255))
       .setColorCaptionLabel(color(0,0,0))
       .moveTo(g1) ;  
    
    PImage[] imgs_arrow_l = {loadImage("images/arrow-l.png"), loadImage("images/arrow-l.png"), loadImage("images/arrow-l.png")};
    cp5.addButton("arrow-l")
       .setPosition(132,449)
       .setSize(35,35)
       .setImages(imgs_arrow_l)
       .updateSize()
       .moveTo(g1) ;  
    
    PImage[] imgs_arrow_r = {loadImage("images/arrow-r.png"), loadImage("images/arrow-r.png"), loadImage("images/arrow-r.png")};
    cp5.addButton("arrow-r")
       .setPosition(206,449)
       .setSize(35,35)
       .setImages(imgs_arrow_r)
       .updateSize()
       .moveTo(g1) ; 
       
    PImage[] imgs_arrow_up = {loadImage("images/arrow-up.png"), loadImage("images/arrow-up.png"), loadImage("images/arrow-up.png")};   
    cp5.addButton("arrow-up")
       .setPosition(169,431)
       .setSize(35,35)
       .setImages(imgs_arrow_up)
       .updateSize()
       .moveTo(g1) ;    
       
    PImage[] imgs_arrow_down = {loadImage("images/arrow-down.png"), loadImage("images/arrow-down.png"), loadImage("images/arrow-down.png")};   
    cp5.addButton("arrow-down")
       .setPosition(169,468)
       .setSize(35,35)
       .setImages(imgs_arrow_down)
       .updateSize()
       .moveTo(g1) ;    
    
    PImage[] imgs_switch = {loadImage("images/switch.png"), loadImage("images/switch.png"), loadImage("images/switch.png")};   
    cp5.addButton("switch")
       .setPosition(17,462)
       .setSize(45,45)
       .setImages(imgs_switch)
       .updateSize()
       .moveTo(g1) ;    
       
    // toolbar   
    Group g2 = cp5.addGroup("group2")
                 .setPosition(500,15)
                 .setBackgroundColor(color(255,255,255, 50))
                 .setBackgroundHeight(100)   
                 .setWidth(400);
                 ;
                 
    PImage[] zoomin = {loadImage("images/zoomin_30x30.png"), loadImage("images/zoomin_over.png"), loadImage("images/zoomin_20x20.png")};   
    cp5.addButton("zoomin")
       .setPosition(0,0)
       .setSize(30,30)
       .setImages(zoomin)
       .updateSize()
       .moveTo(g2) ;  
       
    PImage[] zoomout = {loadImage("images/zoomout_30x30.png"), loadImage("images/zoomout_over.png"), loadImage("images/zoomout_20x20.png")};   
    cp5.addButton("zoomout")
       .setPosition(32,0)
       .setSize(30,30)
       .setImages(zoomout)
       .updateSize()
       .moveTo(g2) ;    
       
    PImage[] pan = {loadImage("images/pan.png"), loadImage("images/pan_over.png"), loadImage("images/pan_20x20.png")};   
    cp5.addButton("pan")
       .setPosition(64,0)
       .setSize(30,30)
       .setImages(pan)
       .updateSize()
       .moveTo(g2) ;    
       
    PImage[] rotate = {loadImage("images/rotate.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_20x20.png")};   
    cp5.addButton("rotate")
       .setPosition(96,0)
       .setSize(30,30)
       .setImages(rotate)
       .updateSize()
       .moveTo(g2) ;      
      
   // change buttons' font size
   PFont pfont = createFont("Arial",20,true); // new font
   ControlFont font = new ControlFont(pfont, 12);  
   cp5.getController("Prev")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);
      
   cp5.getController("F1")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);   
      
   cp5.getController("F2")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);   
    
   cp5.getController("F3")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);   
      
   cp5.getController("F4")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);   
     
   cp5.getController("F5")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);    
      
   cp5.getController("Next")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);    
      
   myTextarea.setFont(font);   
   
   cp5.getController("LSHIFT")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);  
      
   cp5.getController("RSHIFT")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);     
      
   ControlFont font2 = new ControlFont(pfont, 10);   
   cp5.getController("Menu")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);     
     
   cp5.getController("Select")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);     
   
   cp5.getController("Edit")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2); 
   
   cp5.getController("Data")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2); 
   
   cp5.getController("Fctn")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2); 
      
   ControlFont font3 = new ControlFont(pfont, 15);    
   cp5.getController("HOLD")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3);  
      
   cp5.getController("j1_neg")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);    
      
   cp5.getController("j1_pos")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3); 
 
   cp5.getController("FWD")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3);  
      
   cp5.getController("j2_neg")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);    
      
   cp5.getController("j2_pos")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);        
      
   cp5.getController("BWD")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3);  
      
   cp5.getController("j3_neg")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);    
      
   cp5.getController("j3_pos")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3); 
  
   cp5.getController("COORD")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font);  
      
   cp5.getController("-X\n(J4)")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);    
      
   cp5.getController("+X\n(J4)")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);    
      
   cp5.getController("+%")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3);  
      
   cp5.getController("-Y\n(J5)")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);    
      
   cp5.getController("+Y\n(J5)")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);       
      
   cp5.getController("-%")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3);  
      
   cp5.getController("-Z\n(J6)")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);    
      
   cp5.getController("+Z\n(J6)")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font3);      
   
   cp5.getController("RESET")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2); 
      
  // cp5.getController("LEFT")
  //    .getCaptionLabel()
  //    .align(ControlP5.CENTER, ControlP5.CENTER)
  //    .setFont(font2);    
   
   cp5.getController("Item")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2); 
      
   cp5.getController("ENTER")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);    
   
   cp5.getController("num7")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2); 
      
    cp5.getController("num8")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("num9")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("tool1")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("num4")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("num5")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("num6")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("tool2")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
    
     cp5.getController("num1")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("num2")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("num3")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
    cp5.getController("move")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.TOP)
      .setFont(font2); 
   
   cp5.getController("num0")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
   cp5.getController("period")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3);   
    
   cp5.getController("comma")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3);
   
   cp5.getController("Setup")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);   
      
   cp5.getController("-")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font3); 
      
   cp5.getController("posn")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);    
      
   cp5.getController("no")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);  
    
   cp5.getController("status")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2);  
    
   cp5.getController("step")
      .getCaptionLabel()
      .align(ControlP5.CENTER, ControlP5.CENTER)
      .setFont(font2); 
      
   // create a new accordion
   // add group1 to it
   accordion = cp5.addAccordion("acc")
                  .setPosition(5,5)
                  .setWidth(440)
                  .addItem(g1);  
 
}

// events

public void mousePressed(){
   if ((clickPan % 2) == 1 ) { // pan button is pressed
      if (doPan) {
         doPan = false;
      } else {
         doPan = true;
      }
   }
   
   if ((clickRotate % 2) == 1 ) { // rotate button is pressed
      if (doRotate) {
         doRotate = false;
      } else {
         doRotate = true;
      }
   }
}


public void mouseMoved(){
   if (doPan){
      panX += mouseX - pmouseX;
      panY += mouseY - pmouseY;
   }
   if (doRotate){
      myRotX += (mouseY - pmouseY) * 0.01;
      myRotY += (mouseX - pmouseX) * 0.01;
   }
}


// scroll mouse to zoom in / out
public void mouseWheel(MouseEvent event){
   float e = event.getCount();
   if (e > 0 ) {
      myscale *= 1.1;
   }
   if (e < 0){
      myscale *= 0.9; 
   }
   println(e);
}

public void keyPressed(){
   /* click spacebar once to activate pan button
    * click spacebar again to deactivate pan button
    */ 
   if (key == ' '){ 
      clickPan += 1;
      if ((clickPan % 2) == 1){
         cursorMode = HAND;
         PImage[] pressed = {loadImage("images/pan_20x20.png"), loadImage("images/pan_20x20.png"), loadImage("images/pan_20x20.png")};
         cp5.getController("pan")
            .setImages(pressed);   
      }else{
         cursorMode = ARROW;
         PImage[] released = {loadImage("images/pan.png"), loadImage("images/pan_over.png"), loadImage("images/pan_20x20.png")}; 
         cp5.getController("pan")
            .setImages(released);
         doPan = false;   
      }
   }
   
   if (keyCode == SHIFT){ 
      clickRotate += 1;
      if ((clickRotate % 2) == 1){
         PImage[] pressed = {loadImage("images/rotate_20x20.png"), loadImage("images/rotate_20x20.png"), loadImage("images/rotate_20x20.png")};
         cp5.getController("rotate")
            .setImages(pressed);   
      }else{
         PImage[] released = {loadImage("images/rotate.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_20x20.png")}; 
         cp5.getController("rotate")
            .setImages(released);
         doRotate = false;   
      }
   }
}


// buttons event
public void controlEvent(ControlEvent theEvent){
   println(theEvent.getController().getName());
   
}
// zoomin button
public void zoomin(int theValue){
   myscale *= 1.1;
}

// zoomout button
public void zoomout(int theValue){
   myscale *= 0.9;
}

// pan button
public void pan(int theValue){
  clickPan += 1;
  if ((clickPan % 2) == 1){
     cursorMode = HAND;
     PImage[] pressed = {loadImage("images/pan_20x20.png"), loadImage("images/pan_20x20.png"), loadImage("images/pan_20x20.png")};
     cp5.getController("pan")
        .setImages(pressed);   
  }else{
     cursorMode = ARROW;
     PImage[] released = {loadImage("images/pan.png"), loadImage("images/pan_over.png"), loadImage("images/pan_20x20.png")}; 
     cp5.getController("pan")
        .setImages(released);
     doPan = false;   
  }
}

public void rotate(int theValue){
   clickRotate += 1;
   if ((clickRotate % 2) == 1){
     PImage[] pressed = {loadImage("images/rotate_20x20.png"), loadImage("images/rotate_20x20.png"), loadImage("images/rotate_20x20.png")};
     cp5.getController("rotate")
        .setImages(pressed);   
  }else{
     PImage[] released = {loadImage("images/rotate.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_20x20.png")}; 
     cp5.getController("rotate")
        .setImages(released);
     doRotate = false;   
  }
}

public void j1_neg(int theValue){
  if (jointsMoving[0] < 0) jointsMoving[0] = 0;
  else jointsMoving[0] = -1;
}

public void j1_pos(int theValue){
  if (jointsMoving[0] > 0) jointsMoving[0] = 0;
  else jointsMoving[0] = 1;
}

public void j2_neg(int theValue){
  if (jointsMoving[1] < 0) jointsMoving[1] = 0;
  else jointsMoving[1] = -1;
}

public void j2_pos(int theValue){
  if (jointsMoving[1] > 0) jointsMoving[1] = 0;
  else jointsMoving[1] = 1;
}

public void j3_neg(int theValue){
  if (jointsMoving[2] < 0) jointsMoving[2] = 0;
  else jointsMoving[2] = -1;
}

public void j3_pos(int theValue) {
  if (jointsMoving[2] > 0) jointsMoving[2] = 0;
  else jointsMoving[2] = 1;
}

