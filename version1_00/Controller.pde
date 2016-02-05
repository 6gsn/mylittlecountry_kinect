class Controller {
  float x, y;
  float cX, cY;
  int size;
  int radius;
  float rot;
  
  PImage image;
  
  Controller(float tx, float ty, int tsize) {
    cX = width/2;
    cY = height/2;
    radius = 80;
    size = tsize;
  }
  
  void drawController(){
    image(image, x, y);
  }
}

class attackController extends Controller {
  attackController(float tx, float ty, int tsize) {
    super(tx, ty, tsize);
    image = loadImage("Attack.png");
  }
    void Update(){
    if(convertedRightHand != null){
      int convertPostionX = int(player.x-(width/2));
      int convertPostionY = int(player.y-(height/2));
     
     rot = atan2((mouseY)-cY, (mouseX)-cX);
     //using can update hand position
     //rot = atan2((convertedRightHand.y-convertPostionY)-cY, (convertedRightHand.x-convertPostionX)-cX);
    }else{
      rot = atan2((mouseY)-cY, (mouseX)-cX);
    }
    
    x = cX + (radius * cos(rot));
    y = cY + (radius * sin(rot));
  }
}

class defenceController extends Controller {
   defenceController(float tx, float ty, int tsize) {
    super(tx, ty, tsize);
    image = loadImage("Deffence.png");
   }
    void Update(){
    if(convertedLeftHand != null){
      int convertPostionX = int(player.x-(width/2));
      int convertPostionY = int(player.y-(height/2));
     
     rot = atan2(mouseY-cY, mouseX-cX);
    //using can update hand position 
     //rot = atan2((convertedLeftHand.y-convertPostionY)-cY, (convertedLeftHand.x-convertPostionX)-cX);
    }else{
      rot = atan2(mouseY-cY, mouseX-cX);
    }
    x = cX + (radius * cos(rot));
    y = cY + (radius * sin(rot));
  }
  
   void isHit() {
     if(player.skillFlag != true){
       player.skillGage++;
       
       if(player.skillGage >= 10){
         player.skillFlag = true;
       }
     }
   }
}
