
final int FRAME_JOINT = 0, 
          FRAME_JGFRM = 1, 
          FRAME_WORLD = 2, 
          FRAME_TOOL = 3, 
          FRAME_USER = 4;
final int SMALL_BUTTON = 20,
          LARGE_BUTTON = 35; 
final int OFF = 0, ON = 1;      
final int NONE = 0, 
          PROGRAM_NAV = 1, 
          INSTRUCTION_NAV = 2,
          INSTRUCTION_EDIT = 3,
          SET_INSTRUCTION_SPEED = 4,
          SET_INSTRUCTION_REGISTER = 5;

int frame = FRAME_JOINT; // current frame
//String displayFrame = "JOINT";

 
int active_program = -1; // which program is on focus when in PROGRAM_NAV mode?
int select_program = -1; // which program is being edited when in INSTRUCTION_NAV or INSTRUCTION_EDIT mode?
int active_instruction = -1; // which motion instruction is on focus when in INSTRUCTION_NAV mode?
int select_instruction = -1; // which motion instruction is being edited when in INSTRUCTION_EDIT mode?
int mode = NONE; 
int NUM_MODE; // When NUM_MODE is ON, allows for entering numbers
int shift = OFF; // Does shift button is pressed or not?
 
int g1_px, g1_py; // the left-top corner of group1
int g1_width, g1_height; // group 1's width and height
int display_px, display_py; // the left-top corner of display screen

Group g1;
Button bt_show, bt_hide, 
       bt_zoomin_shrink, bt_zoomin_normal,
       bt_zoomout_shrink, bt_zoomout_normal,
       bt_pan_shrink, bt_pan_normal,
       bt_rotate_shrink, bt_rotate_normal
       ;
Textlabel fn_info, num_info;

int setSpeed; // for setting the speed of instructions
String workingNum; // when entering a number with the number keys

// display on screen
ArrayList<ArrayList<String>> contents = new ArrayList<ArrayList<String>>(); // display list of programs or motion instructions
ArrayList<String> options = new ArrayList<String>(); // display options for an element in a motion instruction
ArrayList<Integer> nums = new ArrayList<Integer>(); // store numbers pressed by the user
int active_row = 0, active_col = 0; // which element is on focus now?
int which_option = -1; // which option is on focus now?
int index_contents = 0, index_options = 100, index_nums = 1000; // how many textlabels have been created for display

void gui(){
   int display_width = 340, display_height = 270;
   g1_px = 0;
   g1_py = 0;
   g1_width = 100;
   g1_height = 100;
   display_px = g1_width / 2;
   display_py = SMALL_BUTTON + 1;
   /*
   PFont pfont = createFont("ArialNarrow",9,true); // new font
   ControlFont font = new ControlFont(pfont, 9);
   cp5.setFont(font);
   */
   
   // group 1: display and function buttons
   g1 = cp5.addGroup("DISPLAY")
                 .setPosition(g1_px, g1_py)
                 .setBackgroundColor(color(127,127,127,50))
                 ;            
   
   myTextarea = cp5.addTextarea("txt")
      .setPosition(display_px,display_py)
      .setSize(display_width, display_height)
      .setLineHeight(14)
      .setColor(color(128))
      .setColorBackground(color(200,255,255))
      .setColorForeground(color(0,0,0))
      .moveTo(g1); 
   
   // expand group 1's width and height
   g1_width += 340;
   g1_height += 270;
   
   // text label to show how to use F1 - F5 keys
   fn_info = cp5.addTextlabel("fn_info")
                .hide()
                ;    
   num_info = cp5.addTextlabel("num_info")
                .hide();   
   // button to show g1
   int bt_show_px = 1;
   int bt_show_py = 1;
   bt_show = cp5.addButton("show")
       .setPosition(bt_show_px, bt_show_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setCaptionLabel("SHOW")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .hide()
       ;
       
    int zoomin_shrink_px =  bt_show_px + LARGE_BUTTON;
    int zoomin_shrink_py = bt_show_py;
    PImage[] zoomin_shrink = {loadImage("images/zoomin_35x20.png"), loadImage("images/zoomin_over.png"), loadImage("images/zoomin_down.png")};   
    bt_zoomin_shrink = cp5.addButton("zoomin_shrink")
       .setPosition(zoomin_shrink_px, zoomin_shrink_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(zoomin_shrink)
       .updateSize()
       .hide()
       ;   
       
    int zoomout_shrink_px = zoomin_shrink_px + LARGE_BUTTON ;
    int zoomout_shrink_py = zoomin_shrink_py;   
    PImage[] zoomout_shrink = {loadImage("images/zoomout_35x20.png"), loadImage("images/zoomout_over.png"), loadImage("images/zoomout_down.png")};   
    bt_zoomout_shrink = cp5.addButton("zoomout_shrink")
       .setPosition(zoomout_shrink_px, zoomout_shrink_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(zoomout_shrink)
       .updateSize()
       .hide()
       ;    
   
    int pan_shrink_px = zoomout_shrink_px + LARGE_BUTTON;
    int pan_shrink_py = zoomout_shrink_py ;
    PImage[] pan_shrink = {loadImage("images/pan_35x20.png"), loadImage("images/pan_over.png"), loadImage("images/pan_down.png")};   
    bt_pan_shrink = cp5.addButton("pan_shrink")
       .setPosition(pan_shrink_px, pan_shrink_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(pan_shrink)
       .updateSize()
       .hide()
       ;    
       
    int rotate_shrink_px = pan_shrink_px + LARGE_BUTTON;
    int rotate_shrink_py = pan_shrink_py;   
    PImage[] rotate_shrink = {loadImage("images/rotate_35x20.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_down.png")};   
    bt_rotate_shrink = cp5.addButton("rotate_shrink")
       .setPosition(rotate_shrink_px, rotate_shrink_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(rotate_shrink)
       .updateSize()
       .hide()
       ;     
      
   // button to hide g1
   int hide_px = display_px;
   int hide_py = display_py - SMALL_BUTTON - 1;
   bt_hide = cp5.addButton("hide")
       .setPosition(hide_px, hide_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setCaptionLabel("HIDE")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);
     
    int zoomin_normal_px =  hide_px + LARGE_BUTTON + 1;
    int zoomin_normal_py = hide_py;
    PImage[] zoomin_normal = {loadImage("images/zoomin_35x20.png"), loadImage("images/zoomin_over.png"), loadImage("images/zoomin_down.png")};   
    bt_zoomin_normal = cp5.addButton("zoomin_normal")
       .setPosition(zoomin_normal_px, zoomin_normal_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(zoomin_normal)
       .updateSize()
       .moveTo(g1) ;   
       
    int zoomout_normal_px = zoomin_normal_px + LARGE_BUTTON + 1;
    int zoomout_normal_py = zoomin_normal_py;   
    PImage[] zoomout_normal = {loadImage("images/zoomout_35x20.png"), loadImage("images/zoomout_over.png"), loadImage("images/zoomout_down.png")};   
    bt_zoomout_normal = cp5.addButton("zoomout_normal")
       .setPosition(zoomout_normal_px, zoomout_normal_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(zoomout_normal)
       .updateSize()
       .moveTo(g1) ;    
   
    int pan_normal_px = zoomout_normal_px + LARGE_BUTTON + 1;
    int pan_normal_py = zoomout_normal_py ;
    PImage[] pan = {loadImage("images/pan_35x20.png"), loadImage("images/pan_over.png"), loadImage("images/pan_down.png")};   
    bt_pan_normal = cp5.addButton("pan_normal")
       .setPosition(pan_normal_px, pan_normal_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(pan)
       .updateSize()
       .moveTo(g1) ;    
       
    int rotate_normal_px = pan_normal_px + LARGE_BUTTON + 1;
    int rotate_normal_py = pan_normal_py;   
    PImage[] rotate = {loadImage("images/rotate_35x20.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_down.png")};   
    bt_rotate_normal = cp5.addButton("rotate_normal")
       .setPosition(rotate_normal_px, rotate_normal_py)
       .setSize(LARGE_BUTTON, SMALL_BUTTON)
       .setImages(rotate)
       .updateSize()
       .moveTo(g1) ;     
       
   PImage[] imgs_arrow_up = {loadImage("images/arrow-up.png"), loadImage("images/arrow-up_over.png"), loadImage("images/arrow-up_down.png")};   
   int up_px = display_px+display_width + 2;
   int up_py = display_py;
   cp5.addButton("up")
       .setPosition(up_px, up_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setImages(imgs_arrow_up)
       .updateSize()
       .moveTo(g1) ;     
   
    PImage[] imgs_arrow_down = {loadImage("images/arrow-down.png"), loadImage("images/arrow-down_over.png"), loadImage("images/arrow-down_down.png")};   
    int dn_px = up_px;
    int dn_py = up_py + LARGE_BUTTON + 2;
    cp5.addButton("dn")
       .setPosition(dn_px, dn_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setImages(imgs_arrow_down)
       .updateSize()
       .moveTo(g1) ;    
   
    PImage[] imgs_arrow_l = {loadImage("images/arrow-l.png"), loadImage("images/arrow-l_over.png"), loadImage("images/arrow-l_down.png")};
    int lt_px = dn_px;
    int lt_py = dn_py + LARGE_BUTTON + 2;
    cp5.addButton("lt")
       .setPosition(lt_px, lt_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setImages(imgs_arrow_l)
       .updateSize()
       .moveTo(g1) ;  
    
    PImage[] imgs_arrow_r = {loadImage("images/arrow-r.png"), loadImage("images/arrow-r_over.png"), loadImage("images/arrow-r_down.png")};
    int rt_px = lt_px;
    int rt_py = lt_py + LARGE_BUTTON + 2;;
    cp5.addButton("rt")
       .setPosition(rt_px, rt_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setImages(imgs_arrow_r)
       .updateSize()
       .moveTo(g1) ; 
    
    int fn_px = rt_px;
    int fn_py = rt_py + LARGE_BUTTON + 2;   
    cp5.addButton("Fn")
       .setPosition(fn_px, fn_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("FCTN")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
       
    int sf_px = fn_px;
    int sf_py = fn_py + LARGE_BUTTON + 2;   
    cp5.addButton("sf")
       .setPosition(sf_px, sf_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("SHIFT")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);       
       
    int ne_px = sf_px ;
    int ne_py = sf_py + LARGE_BUTTON + 2;   
    cp5.addButton("ne")
       .setPosition(ne_px, ne_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("NEXT")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
       
    int se_px = display_px - 2 - LARGE_BUTTON;
    int se_py = display_py;   
    cp5.addButton("se")
       .setPosition(se_px, se_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("SELECT")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);           
    
    int mu_px = se_px ;
    int mu_py = se_py + LARGE_BUTTON + 2;   
    cp5.addButton("mu")
       .setPosition(mu_px, mu_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("MENU")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);      
    
    int ed_px = mu_px ;
    int ed_py = mu_py + LARGE_BUTTON + 2;   
    cp5.addButton("ed")
       .setPosition(ed_px, ed_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("EDIT")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);      
     
    int da_px = ed_px ;
    int da_py = ed_py + LARGE_BUTTON + 2;   
    cp5.addButton("da")
       .setPosition(da_px, da_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("DATA")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);  
    
    int sw_px = da_px ;
    int sw_py = da_py + LARGE_BUTTON + 2;   
    cp5.addButton("sw")
       .setPosition(sw_px, sw_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("SWITH")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);     
    
    int st_px = sw_px ;
    int st_py = sw_py + LARGE_BUTTON + 2;   
    cp5.addButton("st")
       .setPosition(st_px, st_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("STEP")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);        
    
    int pr_px = st_px ;
    int pr_py = st_py + LARGE_BUTTON + 2;   
    cp5.addButton("pr")
       .setPosition(pr_px, pr_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("PREV")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);     
      
    int f1_px = display_px ;
    int f1_py = display_py + display_height + 2;   
    cp5.addButton("f1")
       .setPosition(f1_px, f1_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("F1")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);     
         
    int f2_px = f1_px + 41 ;
    int f2_py = f1_py;   
    cp5.addButton("f2")
       .setPosition(f2_px, f2_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("F2")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);  
       
    int f3_px = f2_px + 41 ;
    int f3_py = f2_py;   
    cp5.addButton("f3")
       .setPosition(f3_px, f3_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("F3")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
       
    int f4_px = f3_px + 41 ;
    int f4_py = f3_py;   
    cp5.addButton("f4")
       .setPosition(f4_px, f4_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("F4")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);   
      
    int f5_px = f4_px + 41;
    int f5_py = f4_py;   
    cp5.addButton("f5")
       .setPosition(f5_px, f5_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("F5")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);   
    
    int hd_px = f5_px + 41;
    int hd_py = f5_py;   
    cp5.addButton("hd")
       .setPosition(hd_px, hd_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("HOLD")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
       
    int fd_px = hd_px + 41;
    int fd_py = hd_py;   
    cp5.addButton("fd")
       .setPosition(fd_px, fd_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("FWD")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);   
      
    int bd_px = fd_px + 41;
    int bd_py = fd_py;   
    cp5.addButton("bd")
       .setPosition(bd_px, bd_py)
       .setSize(LARGE_BUTTON, LARGE_BUTTON)
       .setCaptionLabel("BWD")
       .setColorBackground(color(127,127,255))
       .setColorCaptionLabel(color(255,255,255))  
       .moveTo(g1);    
       
   // adjust group 1's width to include all controllers  
   g1.setWidth(g1_width)
     .setBackgroundHeight(g1_height); 
  
    
   // group 2: tool bar
   Group g2 = cp5.addGroup("TOOLBAR")
                 .setPosition(0,display_py + display_height + LARGE_BUTTON + 15)
                 .setBackgroundColor(color(127,127,127, 50))
                 //.setWidth(g1_width)
                 //.setBackgroundHeight(740)
                 .moveTo(g1)   
                 ;
   g2.setOpen(true);              
   
   int RESET_px = 0;
   int RESET_py = 0;
   cp5.addButton("RESET")
      .setPosition(RESET_px, RESET_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("RESET")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
 
   int LEFT_px = RESET_px + LARGE_BUTTON + 1;
   int LEFT_py = RESET_py;
   PImage[] imgs_LEFT = {loadImage("images/LEFT.png"), loadImage("images/LEFT.png"), loadImage("images/LEFT.png")};  
   cp5.addButton("LEFT")
      .setPosition(LEFT_px, LEFT_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setImages(imgs_LEFT)
      .setColorBackground(color(127,127,255)) 
      .moveTo(g2);   
      
   int ITEM_px = LEFT_px + LARGE_BUTTON + 1 ;
   int ITEM_py = LEFT_py;
   cp5.addButton("ITEM")
      .setPosition(ITEM_px, ITEM_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("ITEM")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
    
   int ENTER_px = ITEM_px + LARGE_BUTTON + 1 ;
   int ENTER_py = ITEM_py;
   cp5.addButton("ENTER")
      .setPosition(ENTER_px, ENTER_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("ENTER")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
      
   int TOOL1_px = ENTER_px + LARGE_BUTTON + 1 ;
   int TOOL1_py = ENTER_py;
   cp5.addButton("TOOL1")
      .setPosition(TOOL1_px, TOOL1_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("TOOL1")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
      
   int TOOL2_px = TOOL1_px + LARGE_BUTTON + 1 ;
   int TOOL2_py = TOOL1_py;
   cp5.addButton("TOOL2")
      .setPosition(TOOL2_px, TOOL2_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("TOOL2")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);
 
   int MOVEMENU_px = TOOL2_px + LARGE_BUTTON + 1 ;
   int MOVEMENU_py = TOOL2_py;
   cp5.addButton("MOVEMENU")
      .setPosition(MOVEMENU_px, MOVEMENU_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("MVMU")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2); 
      
   int SETUP_px = MOVEMENU_px + LARGE_BUTTON + 1 ;
   int SETUP_py = MOVEMENU_py;
   cp5.addButton("SETUP")
      .setPosition(SETUP_px, SETUP_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("SETUP")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
      
   int STATUS_px = SETUP_px + LARGE_BUTTON + 1 ;
   int STATUS_py = SETUP_py;
   cp5.addButton("STATUS")
      .setPosition(STATUS_px, STATUS_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("STATUS")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
      
   int NO_px = STATUS_px + LARGE_BUTTON + 1 ;
   int NO_py = STATUS_py;
   cp5.addButton("NO")
      .setPosition(NO_px, NO_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("NO.")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
     
   int POSN_px = NO_px + LARGE_BUTTON + 1 ;
   int POSN_py = NO_py;
   cp5.addButton("POSN")
      .setPosition(POSN_px, POSN_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("POSN")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
    
   int SPEEDUP_px = POSN_px + LARGE_BUTTON + 1 ;
   int SPEEDUP_py = POSN_py;
   cp5.addButton("SPEEDUP")
      .setPosition(SPEEDUP_px, SPEEDUP_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("+%")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
    
   int SLOWDOWN_px = SPEEDUP_px + LARGE_BUTTON + 1 ;
   int SLOWDOWN_py = SPEEDUP_py;
   cp5.addButton("SLOWDOWN")
      .setPosition(SLOWDOWN_px, SLOWDOWN_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-%")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
   
   int NUM1_px = RESET_px ;
   int NUM1_py = RESET_py + SMALL_BUTTON + 1;
   cp5.addButton("NUM1")
      .setPosition(NUM1_px, NUM1_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("1")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);  
      
   int NUM2_px = NUM1_px + LARGE_BUTTON + 1;
   int NUM2_py = NUM1_py;
   cp5.addButton("NUM2")
      .setPosition(NUM2_px, NUM2_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("2")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);  
  
   int NUM3_px = NUM2_px + LARGE_BUTTON + 1;
   int NUM3_py = NUM2_py;
   cp5.addButton("NUM3")
      .setPosition(NUM3_px, NUM3_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("3")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2); 
 
   int NUM4_px = NUM3_px + LARGE_BUTTON + 1;
   int NUM4_py = NUM3_py;
   cp5.addButton("NUM4")
      .setPosition(NUM4_px, NUM4_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("4")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2); 

   int NUM5_px = NUM4_px + LARGE_BUTTON + 1;
   int NUM5_py = NUM4_py;
   cp5.addButton("NUM5")
      .setPosition(NUM5_px, NUM5_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("5")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
 
   int NUM6_px = NUM5_px + LARGE_BUTTON + 1;
   int NUM6_py = NUM5_py;
   cp5.addButton("NUM6")
      .setPosition(NUM6_px, NUM6_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("6")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
    
   int NUM7_px = NUM6_px + LARGE_BUTTON + 1;
   int NUM7_py = NUM6_py;
   cp5.addButton("NUM7")
      .setPosition(NUM7_px, NUM7_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("7")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);     
      
   int NUM8_px = NUM7_px + LARGE_BUTTON + 1;
   int NUM8_py = NUM7_py;
   cp5.addButton("NUM8")
      .setPosition(NUM8_px, NUM8_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("8")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
      
   int NUM9_px = NUM8_px + LARGE_BUTTON + 1;
   int NUM9_py = NUM8_py;
   cp5.addButton("NUM9")
      .setPosition(NUM9_px, NUM9_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("9")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);  
  
   int NUM0_px = NUM9_px + LARGE_BUTTON + 1;
   int NUM0_py = NUM9_py;
   cp5.addButton("NUM0")
      .setPosition(NUM0_px, NUM0_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("0")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
  
   int LINE_px = NUM0_px + LARGE_BUTTON + 1;
   int LINE_py = NUM0_py;
   cp5.addButton("LINE")
      .setPosition(LINE_px, LINE_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
   
   int PERIOD_px = LINE_px + LARGE_BUTTON + 1;
   int PERIOD_py = LINE_py;
   cp5.addButton("PERIOD")
      .setPosition(PERIOD_px, PERIOD_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel(".")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);   
   
   int COMMA_px = PERIOD_px + LARGE_BUTTON + 1;
   int COMMA_py = PERIOD_py;
   cp5.addButton("COMMA")
      .setPosition(COMMA_px, COMMA_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel(",")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);     
   
   int JOINT1_NEG_px = NUM1_px;
   int JOINT1_NEG_py = NUM1_py + SMALL_BUTTON + 1;
   cp5.addButton("JOINT1_NEG")
      .setPosition(JOINT1_NEG_px, JOINT1_NEG_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-X (J1)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
     
   int JOINT1_POS_px = JOINT1_NEG_px + LARGE_BUTTON + 1;
   int JOINT1_POS_py = JOINT1_NEG_py;
   cp5.addButton("JOINT1_POS")
      .setPosition(JOINT1_POS_px, JOINT1_POS_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("+X (J1)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);      
      
   int JOINT2_NEG_px = JOINT1_POS_px + LARGE_BUTTON + 1;
   int JOINT2_NEG_py = JOINT1_POS_py;
   cp5.addButton("JOINT2_NEG")
      .setPosition(JOINT2_NEG_px, JOINT2_NEG_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-Y (J2)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);      
     
   int JOINT2_POS_px = JOINT2_NEG_px + LARGE_BUTTON + 1;
   int JOINT2_POS_py = JOINT2_NEG_py;
   cp5.addButton("JOINT2_POS")
      .setPosition(JOINT2_POS_px, JOINT2_POS_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("+Y (J2)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);     
    
   int JOINT3_NEG_px = JOINT2_POS_px + LARGE_BUTTON + 1;
   int JOINT3_NEG_py = JOINT2_POS_py;
   cp5.addButton("JOINT3_NEG")
      .setPosition(JOINT3_NEG_px, JOINT3_NEG_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-Z (J3)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);  
   
   int JOINT3_POS_px = JOINT3_NEG_px + LARGE_BUTTON + 1;
   int JOINT3_POS_py = JOINT3_NEG_py;
   cp5.addButton("JOINT3_POS")
      .setPosition(JOINT3_POS_px, JOINT3_POS_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("+Z (J3)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
      
   int JOINT4_NEG_px = JOINT3_POS_px + LARGE_BUTTON + 1;
   int JOINT4_NEG_py = JOINT3_POS_py;
   cp5.addButton("JOINT4_NEG")
      .setPosition(JOINT4_NEG_px, JOINT4_NEG_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-X (J4)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
     
   int JOINT4_POS_px = JOINT4_NEG_px + LARGE_BUTTON + 1;
   int JOINT4_POS_py = JOINT4_NEG_py;
   cp5.addButton("JOINT4_POS")
      .setPosition(JOINT4_POS_px, JOINT4_POS_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("+X (J4)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);      
      
   int JOINT5_NEG_px = JOINT4_POS_px + LARGE_BUTTON + 1;
   int JOINT5_NEG_py = JOINT4_POS_py;
   cp5.addButton("JOINT5_NEG")
      .setPosition(JOINT5_NEG_px, JOINT5_NEG_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-Y (J5)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);      
     
   int JOINT5_POS_px = JOINT5_NEG_px + LARGE_BUTTON + 1;
   int JOINT5_POS_py = JOINT5_NEG_py;
   cp5.addButton("JOINT5_POS")
      .setPosition(JOINT5_POS_px, JOINT5_POS_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("+Y (J5)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);     
    
   int JOINT6_NEG_px = JOINT5_POS_px + LARGE_BUTTON + 1;
   int JOINT6_NEG_py = JOINT5_POS_py;
   cp5.addButton("JOINT6_NEG")
      .setPosition(JOINT6_NEG_px, JOINT6_NEG_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("-Z (J6)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);  
   
   int JOINT6_POS_px = JOINT6_NEG_px + LARGE_BUTTON + 1;
   int JOINT6_POS_py = JOINT6_NEG_py;
   cp5.addButton("JOINT6_POS")
      .setPosition(JOINT6_POS_px, JOINT6_POS_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("+Z (J6)")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);    
   
   int COORD_px = JOINT6_POS_px + LARGE_BUTTON + 1;
   int COORD_py = JOINT6_POS_py;
   cp5.addButton("COORD")
      .setPosition(COORD_px, COORD_py)
      .setSize(LARGE_BUTTON, SMALL_BUTTON)
      .setCaptionLabel("COORD")
      .setColorBackground(color(127,127,255))
      .setColorCaptionLabel(color(255,255,255))  
      .moveTo(g2);      
}   

/* mouse events */
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
         PImage[] pressed = {loadImage("images/pan_down.png"), loadImage("images/pan_down.png"), loadImage("images/pan_down.png")};
         if (bt_show.isVisible()){
              cp5.getController("pan_shrink")
                 .setImages(pressed);
         }else{
              cp5.getController("pan_normal")
                 .setImages(pressed);
         }
            
      }else{
         cursorMode = ARROW;
         PImage[] released = {loadImage("images/pan_35x20.png"), loadImage("images/pan_over.png"), loadImage("images/pan_down.png")}; 
         if (bt_show.isVisible()){
              cp5.getController("pan_shrink")
                 .setImages(released);
         }else{
              cp5.getController("pan_normal")
                 .setImages(released);
         }
         doPan = false;   
      }
   }
   
   if (keyCode == SHIFT){ 
      clickRotate += 1;
      if ((clickRotate % 2) == 1){
         PImage[] pressed = {loadImage("images/rotate_down.png"), loadImage("images/rotate_down.png"), loadImage("images/rotate_down.png")};
         if (bt_show.isVisible()){
            cp5.getController("rotate_shrink")
               .setImages(pressed); 
         }else{
            cp5.getController("rotate_normal")
               .setImages(pressed); 
         }
        
      }else{
         PImage[] released = {loadImage("images/rotate_35x20.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_down.png")}; 
         if (bt_show.isVisible()){
            cp5.getController("rotate_shrink")
               .setImages(released); 
         }else{
            cp5.getController("rotate_normal")
               .setImages(released); 
         }
         doRotate = false;   
      }
   }
}

/* buttons event */

// need this function to call buttons' event
public void controlEvent(ControlEvent theEvent){
   //println(theEvent.getController().getName());
   
}

public void hide(int theValue){
   g1.hide();
   bt_show.show();
   bt_zoomin_shrink.show();
   bt_zoomout_shrink.show();
   bt_pan_shrink.show();
   bt_rotate_shrink.show(); 
   
   // release buttons of pan and rotate
   clickPan = 0;
   clickRotate = 0;
   cursorMode = ARROW;
   PImage[] pan_released = {loadImage("images/pan_35x20.png"), loadImage("images/pan_over.png"), loadImage("images/pan_down.png")}; 
   cp5.getController("pan_normal")
      .setImages(pan_released);
   cp5.getController("pan_shrink")
      .setImages(pan_released);   
   doPan = false;    

   cursorMode = ARROW;
   PImage[] rotate_released = {loadImage("images/rotate_35x20.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_down.png")}; 
   cp5.getController("rotate_normal")
      .setImages(rotate_released);
   cp5.getController("rotate_shrink")
      .setImages(rotate_released);   
   doRotate = false;   
   
}

public void show(int theValue){
   g1.show();
   bt_show.hide();
   bt_zoomin_shrink.hide();
   bt_zoomout_shrink.hide();
   bt_pan_shrink.hide();
   bt_rotate_shrink.hide();
   
   // release buttons of pan and rotate
   clickPan = 0;
   clickRotate = 0;
   cursorMode = ARROW;
   PImage[] pan_released = {loadImage("images/pan_35x20.png"), loadImage("images/pan_over.png"), loadImage("images/pan_down.png")}; 
   cp5.getController("pan_normal")
      .setImages(pan_released);
   doPan = false;    

   cursorMode = ARROW;
   PImage[] rotate_released = {loadImage("images/rotate_35x20.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_down.png")}; 
   cp5.getController("rotate_normal")
      .setImages(rotate_released);
   doRotate = false;  
}

public void NUM0(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(0);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "0";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
   
}

public void NUM1(int theValue){
   /*println("NUM_MODE="+NUM_MODE+" nums.size()="+nums.size());
   
   if (NUM_MODE == ON){
      nums.add(1);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "1";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void NUM2(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(2);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "2";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void NUM3(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(3);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "3";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}
public void NUM4(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(4);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "4";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void NUM5(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(5);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "5";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void NUM6(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(6);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "6";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void NUM7(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(7);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "7";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void NUM8(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(8);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "8";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void NUM9(int theValue){
   /*if (NUM_MODE == ON){
      nums.add(9);
   } /* */
   if (mode == SET_INSTRUCTION_REGISTER) {
     workingNum += "9";
     options.set(1, workingNum);
     updateScreen(color(255,0,0), color(0,0,0));
   }
}

public void PERIOD(int theValue){
   if (NUM_MODE == ON){
      nums.add(-1);
   }
   updateScreen(color(255,0,0), color(0,0,0));
}

public void se(int theValue){
   mode = NONE;
   options = new ArrayList<String>(); // clear options
   nums = new ArrayList<Integer>(); // clear numbers
   clearScreen();
   
   int size = programs.size();
   if (size <= 0){
      programs.add(new Program("My Program 1"));
   }
   
   contents = new ArrayList<ArrayList<String>>();  
   for(int i=0;i<size;i++){
      ArrayList<String> temp = new ArrayList<String>();
      temp.add(programs.get(i).getName());
      contents.add(temp);
   }
  
   updateScreen(color(255,0,0), color(0,0,0));
   mode = PROGRAM_NAV;
   active_program = 0;
   active_instruction = 0;
   
}

public void up(int theValue){
   switch (mode){
      case PROGRAM_NAV:
         options = new ArrayList<String>();
         clearOptions();
         if (active_row == 0){
             // does nothing
         }else{
             active_row -= 1;
             active_col = 0;
             active_program -= 1;
         }
         break;
      case INSTRUCTION_NAV:
         options = new ArrayList<String>();
         clearOptions();
         if(active_row == 0){
            // does nothing
         }else{
            active_row -= 1;
            active_col = 0;
            active_instruction -= 1;
         }
         break;
      case INSTRUCTION_EDIT:
         if (which_option == 0){
            // does nothing
         }else{
            which_option -= 1;
         }
         break;   
   }
   
   updateScreen(color(255,0,0), color(0,0,0));
}

public void dn(int theValue){
   switch (mode){
      case PROGRAM_NAV:
         options = new ArrayList<String>();
         clearOptions();
         if (active_row == contents.size()-1){
             // does nothing
         }else{
             active_row += 1;
             active_col = 0;
             active_program += 1;
         }
         break;
      case INSTRUCTION_NAV:
         options = new ArrayList<String>();
         clearOptions();
         if (active_row == contents.size()-1){
             // does nothing
         }else{
             active_row += 1;
             active_col = 0;
             active_instruction += 1;
         }
         break;
      case INSTRUCTION_EDIT:
         if (which_option == options.size() - 1){
            // does nothing
         }else{
            which_option += 1;
         }
         break;
   }  
   updateScreen(color(255,0,0), color(0,0,0));
}

public void lt(int theValue){
   switch (mode){
      case PROGRAM_NAV:
          break;
      case INSTRUCTION_NAV:
          options = new ArrayList<String>();
          clearOptions();
          if (active_col == 0){
              // does nothing
          }else{
              active_col -= 1;
          }
          updateScreen(color(255,0,0), color(0,0,0));
          break;
      case INSTRUCTION_EDIT:
          mode = INSTRUCTION_NAV;
          lt(1);
          break;
      case SET_INSTRUCTION_SPEED:
          setSpeed -= 5;
          if (setSpeed < 5) setSpeed = 5;
          options.set(1, String.valueOf(setSpeed) + "%");
          updateScreen(color(255,0,0), color(0,0,0));
          break;
   }
   
}


public void rt(int theValue){
  switch (mode){
      case PROGRAM_NAV:
          break;
      case INSTRUCTION_NAV:
          options = new ArrayList<String>();
          clearOptions();
          if (active_col == contents.get(active_row).size()-1){
             // does nothing
          }else{
             active_col += 1;
          }
          updateScreen(color(255,0,0), color(0,0,0));
          break;
      case INSTRUCTION_EDIT:
          mode = INSTRUCTION_NAV;
          rt(1);
          break;
      case SET_INSTRUCTION_SPEED:
          setSpeed += 5;
          if (setSpeed > 100) setSpeed = 100;
          options.set(1, String.valueOf(setSpeed) + "%");
          updateScreen(color(255,0,0), color(0,0,0));
          break;
   }
}

public void sf(int theValue){
   if (shift == OFF){
      shift = ON;
   }else{
      shift = OFF;
   }
}

public void pr(int theValue){
   se(1);
}

public void f1(int theValue){
   switch (mode){
      case PROGRAM_NAV:
         shift = OFF;
         break;
      case INSTRUCTION_NAV:
         if (shift == ON) {
             MotionInstruction m = new MotionInstruction(MTYPE_JOINT, 0, false, 0.25, TERM_FINE);
             Program current_p = programs.get(select_program);
             current_p.addInstruction(m);
             loadInstructions(select_program);
             options = new ArrayList<String>();
             which_option = -1;
             clearOptions();
             updateScreen(color(255,0,0), color(0,0,0));
         }
         shift = OFF;
         break;
      case INSTRUCTION_EDIT:
         shift = OFF;
         break;
   }
    
}

public void f4(int theValue){
   mode = INSTRUCTION_NAV;
   switch (mode){
      case INSTRUCTION_NAV:
         //MotionInstruction m = (MotionInstruction) programs.get(select_program).getInstructions().get(active_row);
         switch (active_col){
             case 0: // motion type
                options = new ArrayList<String>();
                options.add("1.JOINT");
                options.add("2.LINEAR");
                options.add("3.CIRCULAR");
                //NUM_MODE = ON;
                select_instruction = active_instruction;
                mode = INSTRUCTION_EDIT;
                which_option = 0;
                break;
             case 1: // register type
                options = new ArrayList<String>();
                options.add("1.LOCAL(P)");
                options.add("2.GLOBAL(PR)");
                //NUM_MODE = ON;
                select_instruction = active_instruction;
                mode = INSTRUCTION_EDIT;
                which_option = 0;
                break;
             case 2: // register
                select_instruction = active_instruction;
                options = new ArrayList<String>();
                options.add("Use number keys to enter a register number (0-999)");
                workingNum = "";
                options.add(workingNum);
                mode = SET_INSTRUCTION_REGISTER;
                which_option = 0;
                break;
             case 3: // speed
                select_instruction = active_instruction;
                options = new ArrayList<String>();
                options.add("Use left and right arrow keys to adjust speed");
                MotionInstruction castIns = (MotionInstruction)(programs.get(select_program).getInstructions().get(select_instruction));
                float tempSpeed = castIns.getSpeed();
                setSpeed = (int)(tempSpeed * 100);
                options.add(String.valueOf(setSpeed) + "%");
                mode = SET_INSTRUCTION_SPEED;
                which_option = 0;
                break;
             case 4: // termination type
                options = new ArrayList<String>();
                options.add("1.FINE");
                options.add("2.CONT0");
                options.add("3.CONT50");
                options.add("4.CONT75");
                options.add("5.CONT100");
                //NUM_MODE = ON;
                select_instruction = active_instruction;
                mode = INSTRUCTION_EDIT;
                which_option = 0;
                break;   
         } 
         break;  
     case INSTRUCTION_EDIT:
         break;    
     case PROGRAM_NAV:
         break;    
   }
   //println("mode="+mode+" active_col"+active_col);
   updateScreen(color(255,0,0), color(0,0,0));
}

public void hd(int theValue){

}

public void fd(int theValue){
   if (active_instruction == 0 && shift == ON) {
      readyProgram();
      doneMoving = executeProgram(programs.get(select_program), armModel);
   }
   shift = OFF;
}

public void bd(int theValue){

}
public void ENTER(int theValue){
   switch (mode){
      case NONE:
         break;
      case PROGRAM_NAV:
         select_program = active_program;
         mode = INSTRUCTION_NAV;
         clearScreen();
         println("after clear screen");
         loadInstructions(select_program);
         println("after load instruction");
         updateScreen(color(255,0,0), color(0,0,0));
         println("after update screen");
         break;
      case INSTRUCTION_NAV:
         if (active_col == 1 || active_col == 2){
            select_instruction = active_instruction;
            mode = INSTRUCTION_EDIT;
            NUM_MODE = ON;
            num_info.setText(" ");
         }
         break;
      case INSTRUCTION_EDIT:
         Program current_p = programs.get(select_program);
         println("select_instruction="+select_instruction);
         MotionInstruction m = (MotionInstruction)current_p.getInstructions().get(select_instruction);
         switch (active_col){
            case 0: // motion type
               if (which_option == 0){
                  m.setMotionType(MTYPE_JOINT);
               }else if (which_option == 1){
                  m.setMotionType(MTYPE_LINEAR);
               }else if(which_option == 2){
                  m.setMotionType(MTYPE_CIRCULAR);
               }
               break;
            case 1: // register type
               if (which_option == 0) m.setGlobal(false);
               else m.setGlobal(true);
               break;
            case 2: // register
               try{
                  String input = "";
                  for(int i=0;i<nums.size();i++){
                     if (nums.get(i) == -1){
                        input += ".";
                     }else{
                        input += nums.get(i).toString();
                     }
                  }
                  m.setRegister(Integer.parseInt(input));
                  NUM_MODE = OFF; 
               }catch (NumberFormatException ex){
                  num_info.setText("Invalid input")
                             ;
                  nums = new ArrayList<Integer>();
                  clearNums();
                  updateScreen(color(255,0,0), color(0,0,0));
               }
               break;
            case 3: // speed
               break;
            case 4: // termination type
               if (which_option == 0){
                  m.setTerminationType(TERM_FINE);
               }else if (which_option == 1){
                  m.setTerminationType(TERM_CONT0);
               }else if (which_option == 2){
                  m.setTerminationType(TERM_CONT50);
               }else if (which_option == 3){
                  m.setTerminationType(TERM_CONT75);
               }else if (which_option == 4){
                  m.setTerminationType(TERM_CONT100);
               }
               break;   
         }
         loadInstructions(active_program);
         mode = INSTRUCTION_NAV;
         NUM_MODE = OFF;
         options = new ArrayList<String>();
         which_option = -1;
         clearOptions();
         nums = new ArrayList<Integer>();
         clearNums();
         updateScreen(color(255,0,0), color(0,0,0));
         break;
      case SET_INSTRUCTION_SPEED:
         float tempSpeed = ((float)setSpeed/100.0);
         MotionInstruction castIns = (MotionInstruction)(programs.get(select_program).getInstructions().get(select_instruction));
         castIns.setSpeed(tempSpeed);
         loadInstructions(active_program);
         mode = INSTRUCTION_NAV;
         options = new ArrayList<String>();
         which_option = -1;
         clearOptions();
         updateScreen(color(255,0,0), color(0,0,0));
         break;
      case SET_INSTRUCTION_REGISTER:
         int tempRegister = Integer.parseInt(workingNum);
         if (tempRegister >= 0 && tempRegister < pr.length) {
           castIns = (MotionInstruction)(programs.get(select_program).getInstructions().get(select_instruction));
           castIns.setRegister(tempRegister);
         }
         loadInstructions(active_program);
         mode = INSTRUCTION_NAV;
         options = new ArrayList<String>();
         which_option = -1;
         clearOptions();
         updateScreen(color(255,0,0), color(0,0,0));
         break;
   }
}

/* navigation buttons */
// zoomin button when interface is at full size
public void zoomin_normal(int theValue){
   myscale *= 1.1;
}

// zoomout button when interface is at full size
public void zoomout_normal(int theValue){
   myscale *= 0.9;
}

// pan button when interface is at full size
public void pan_normal(int theValue){
  clickPan += 1;
  if ((clickPan % 2) == 1){
     cursorMode = HAND;
     PImage[] pressed = {loadImage("images/pan_down.png"), loadImage("images/pan_down.png"), loadImage("images/pan_down.png")};
     cp5.getController("pan_normal")
        .setImages(pressed);   
  }else{
     cursorMode = ARROW;
     PImage[] released = {loadImage("images/pan_35x20.png"), loadImage("images/pan_over.png"), loadImage("images/pan_down.png")}; 
     cp5.getController("pan_normal")
        .setImages(released);
     doPan = false;   
  }
}

// pan button when interface is minimized
public void pan_shrink(int theValue){
  clickPan += 1;
  if ((clickPan % 2) == 1){
     cursorMode = HAND;
     PImage[] pressed = {loadImage("images/pan_down.png"), loadImage("images/pan_down.png"), loadImage("images/pan_down.png")};
     cp5.getController("pan_shrink")
        .setImages(pressed);   
  }else{
     cursorMode = ARROW;
     PImage[] released = {loadImage("images/pan_35x20.png"), loadImage("images/pan_over.png"), loadImage("images/pan_down.png")}; 
     cp5.getController("pan_shrink")
        .setImages(released);
     doPan = false;   
  }
}

// rotate button when interface is at full size
public void rotate_normal(int theValue){
   clickRotate += 1;
   if ((clickRotate % 2) == 1){
     cursorMode = MOVE;
     PImage[] pressed = {loadImage("images/rotate_down.png"), loadImage("images/rotate_down.png"), loadImage("images/rotate_down.png")};
     cp5.getController("rotate_normal")
        .setImages(pressed);   
  }else{
     cursorMode = ARROW;
     PImage[] released = {loadImage("images/rotate_35x20.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_down.png")}; 
     cp5.getController("rotate_normal")
        .setImages(released);
     doRotate = false;   
  }
}

// rotate button when interface is minized
public void rotate_shrink(int theValue){
   clickRotate += 1;
   if ((clickRotate % 2) == 1){
     cursorMode = MOVE;
     PImage[] pressed = {loadImage("images/rotate_down.png"), loadImage("images/rotate_down.png"), loadImage("images/rotate_down.png")};
     cp5.getController("rotate_shrink")
        .setImages(pressed);   
  }else{
     cursorMode = ARROW;
     PImage[] released = {loadImage("images/rotate_35x20.png"), loadImage("images/rotate_over.png"), loadImage("images/rotate_down.png")}; 
     cp5.getController("rotate_shrink")
        .setImages(released);
     doRotate = false;   
  }
}


public void JOINT1_NEG(int theValue) {
  if (armModel.segments.size() >= 1) {
    Model model = armModel.segments.get(0);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = -1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT1_POS(int theValue) {
  if (armModel.segments.size() >= 1) {
    Model model = armModel.segments.get(0);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = 1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT2_NEG(int theValue) {
  if (armModel.segments.size() >= 2) {
    Model model = armModel.segments.get(1);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = -1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT2_POS(int theValue) {
  if (armModel.segments.size() >= 2) {
    Model model = armModel.segments.get(1);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = 1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT3_NEG(int theValue) {
  if (armModel.segments.size() >= 3) {
    Model model = armModel.segments.get(2);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = -1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT3_POS(int theValue) {
  if (armModel.segments.size() >= 3) {
    Model model = armModel.segments.get(2);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = 1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT4_NEG(int theValue) {
  if (armModel.segments.size() >= 4) {
    Model model = armModel.segments.get(3);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = -1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT4_POS(int theValue) {
  if (armModel.segments.size() >= 4) {
    Model model = armModel.segments.get(3);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = 1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT5_NEG(int theValue) {
  if (armModel.segments.size() >= 5) {
    Model model = armModel.segments.get(4);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = -1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT5_POS(int theValue) {
  if (armModel.segments.size() >= 5) {
    Model model = armModel.segments.get(4);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = 1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT6_NEG(int theValue) {
  if (armModel.segments.size() >= 6) {
    Model model = armModel.segments.get(5);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = -1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}

public void JOINT6_POS(int theValue) {
  if (armModel.segments.size() >= 6) {
    Model model = armModel.segments.get(5);
    for (int n = 0; n < 3; n++) {
      if (model.rotations[n]) {
        if (model.jointsMoving[n] == 0) model.jointsMoving[n] = 1;
        else model.jointsMoving[n] = 0;
      }
    }
  }
}


// update what displayed on screen
public void updateScreen(color active, color normal){
   int next_px = display_px;
   int next_py = display_py;
   
   // display the name of the program that is being edited 
   switch (mode){
      case INSTRUCTION_NAV:
         cp5.addTextlabel("-1")
            .setText(programs.get(select_program).getName()) 
            .setPosition(next_px, next_py)
            .setColorValue(normal)
            .show()
            .moveTo(g1)
            ;
         next_px = display_px;
         next_py += 14;   
         break;
      case INSTRUCTION_EDIT:
      case SET_INSTRUCTION_SPEED:
      case SET_INSTRUCTION_REGISTER:
         cp5.addTextlabel("-1")
            .setText(programs.get(select_program).getName()) 
            .setPosition(next_px, next_py)
            .setColorValue(normal)
            .show()
            .moveTo(g1)
            ;
         next_px = display_px;
         next_py += 14;   
         //println("I am in instruction mode");
         break;
   }
   
   // display the main list on screen
   index_contents = 0;
   for(int i=0;i<contents.size();i++){
      ArrayList<String> temp = contents.get(i);
      for (int j=0;j<temp.size();j++){
          if (i == active_row && j == active_col){
             cp5.addTextlabel(Integer.toString(index_contents))
                .setText(temp.get(j))
                .setPosition(next_px, next_py)
                .setColorValue(active)
                .moveTo(g1)
                ;
          }else{
             cp5.addTextlabel(Integer.toString(index_contents))
                .setText(temp.get(j))
                .setPosition(next_px, next_py)
                .setColorValue(normal)
                .moveTo(g1)
                ;  
          }
          index_contents++;
          next_px += temp.get(j).length() * 6 + 5; 
      }
      next_px = display_px;
      next_py += 14;
      
      
   }
   
   // display 'END' at the end of the program 
   switch (mode){
      case INSTRUCTION_NAV:
         cp5.addTextlabel("-2")
            .setText("End") 
            .setPosition(next_px, next_py)
            .setColorValue(normal)
            .moveTo(g1)
            ;
         next_px = display_px;
         next_py += 14;   
         break;
      case INSTRUCTION_EDIT:
      case SET_INSTRUCTION_SPEED:
      case SET_INSTRUCTION_REGISTER:
         cp5.addTextlabel("-2")
            .setText("End") 
            .setPosition(next_px, next_py)
            .setColorValue(normal)
            .moveTo(g1)
            ;
         next_px = display_px;
         next_py += 14; 
         break;
   }
   
   // display options for an element being edited
   next_py += 14;
   index_options = 100;
   if (options.size() > 0){
      for(int i=0;i<options.size();i++){
        if (i==which_option){
           cp5.addTextlabel(Integer.toString(index_options))
              .setText(options.get(i))
              .setPosition(next_px, next_py)
              .setColorValue(active)
              .moveTo(g1)
              ;
        }else{
            cp5.addTextlabel(Integer.toString(index_options))
               .setText(options.get(i))
               .setPosition(next_px, next_py)
               .setColorValue(normal)
               .moveTo(g1)
               ;
        }
        
         index_options++;
         next_px = display_px;
         next_py += 14;    
      }
   }
   
   // display the numbers that the user has typed
   next_py += 14;
   index_nums = 1000;
   if (nums.size() > 0){
      println("nums size is " + nums.size());
      for(int i=0;i<nums.size();i++){
         if (nums.get(i) == -1){
            cp5.addTextlabel(Integer.toString(index_nums))
               .setText(".")
               .setPosition(next_px, next_py)
               .setColorValue(normal)
               .moveTo(g1)
               ;
         }else{
            cp5.addTextlabel(Integer.toString(index_nums))
               .setText(Integer.toString(nums.get(i)))
               .setPosition(next_px, next_py)
               .setColorValue(normal)
               .moveTo(g1)
               ;
         }
         
         index_nums++;
         next_px += 5;   
      }
   }
   
   // display the comment for the user's input
   num_info.setPosition(next_px, next_py)
           .setColorValue(normal) 
           .show()
           ;
   next_px = display_px;
   next_py += 14;   
   
   // display hints for function keys
   next_py += 100;
   if (mode == INSTRUCTION_NAV){
          fn_info.setText("F4: CHOICE")
                 .setPosition(next_px, next_py)
                 .setColorValue(normal)
                 .show()
                 .moveTo(g1)
                 ;
    } else if (mode == INSTRUCTION_EDIT){
          fn_info.show()
                 .moveTo(g1)
                 ;
    }
}

// clear screen
public void clearScreen(){
   clearContents();
   clearOptions();
   
   // hide the text labels that show the start and end of a program
   if (mode == INSTRUCTION_NAV){
      
   } else if (mode == INSTRUCTION_EDIT){
     
   }else{
      if (cp5.getController("-1") != null){
           cp5.getController("-1")
              .hide()
              ;
      }     
      if (cp5.getController("-2") != null){
           cp5.getController("-2")
              .hide()
              ;   
      }
      fn_info.hide();
   }
   
  clearNums();
   
   cp5.update();
   active_row = 0;
   active_col = 0;
   contents = new ArrayList<ArrayList<String>>();
}

public void clearContents(){
   for(int i=0;i<index_contents;i++){
      cp5.getController(Integer.toString(i)).hide();
   }
   index_contents = 0;
}

public void clearOptions(){
   for(int i=100;i<index_options;i++){
      cp5.getController(Integer.toString(i)).hide();
   }
   index_options = 100;
}

public void clearNums(){
   for(int i=1000;i<index_nums;i++){
      cp5.getController(Integer.toString(i)).hide();
   }
   index_nums = 1000;
}

// prepare for displaying motion instructions on screen
public void loadInstructions(int programID){
   Program p = programs.get(programID);
   contents = new ArrayList<ArrayList<String>>();
   int size = p.getInstructions().size();
   
   //TODO: TEST
   println("programID="+programID+" instructions size = "+size);
   
   for(int i=0;i<size;i++){
      ArrayList<String> m = new ArrayList<String>();
      MotionInstruction a = (MotionInstruction)p.getInstructions().get(i);
      // add motion type
      switch (a.getMotionType()){
         case MTYPE_JOINT:
            m.add("J");
            break;
         case MTYPE_LINEAR:
            m.add("L");
            break;
         case MTYPE_CIRCULAR:
            m.add("C");
            break; 
      }
      
      // load register no, speed and termination type
      if (a.getGlobal()) m.add("PR[");
      else m.add("P[");
      m.add(a.getRegister()+"]");
      m.add(a.getSpeed() * 100 + "%");
      switch (a.getTerminationType()){
         case TERM_FINE:
            m.add("FINE");
            break;
         case TERM_CONT0:
            m.add("CONT0");
            break;
         case TERM_CONT50:
            m.add("CONT50");
            break;
         case TERM_CONT75:
            m.add("CONT75");
            break;
         case TERM_CONT100:
            m.add("CONT100");
            break;   
      }
      contents.add(m);
      println("hi " + m.toString());
   } 
   
}
