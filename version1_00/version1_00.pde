import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

//set Character
Player player;
ArrayList enemy = new ArrayList();
ArrayList effectImage = new ArrayList();

//set ControllerPointer
attackController acont;
defenceController dcont;

//set Postion of hand
PVector convertedRightHand;
PVector convertedLeftHand;

//set Flag
int sceneFlag = 4;  // 0 = setting, 1 = Start, 2 = Clear, 3 = Lose, 4 = Opening, 5 = Ending
int stageFlag = 0;  // 0 = start, 2 = end
int BgmFlag = 0;
int handAreaFlag = 0; //0 = start, 1 = restart, 2
int gameTimer = 0;
int gameScore[] = {0, 0, 0};
final int maxTime = 15;

//set Sound
import ddf.minim.*;

Minim minim;
AudioPlayer bulletSound, BGM1, BGM2, BGM3;

//set font
PFont font;

//stageInfo[stageFlag][obejectNum(0 = player)][i(0 = x, 1 = y, 2 = size)]
float stageInfo[][][] ={{{424.0, 285.5, 150}, {448.0, 112.0, 70, 110}, {365.0, 83.5, 60, 120}, {330.5, 136.5, 35, 130},   
                         {316.0, 160.5, 50, 140}, {279.5, 93.0, 60, 150}, {543.0, 118.5, 70, 160}, {612.0, 220.0, 50, 170},
                         {244.5, 175.0, 45, 180}, {217.5, 250.0, 75, 125}, {235.0, 319.0, 80, 135}, {714.5, 338.5, 100, 145},
                         {624.0, 82.0, 60, 155}, {627.0, 140.5, 30, 165}, {662.0, 133.0, 65, 175}, {691.5, 211.0, 45, 185},
                         {759.0, 236.0, 55, 120}, {785.5, 168.0, 55, 100}},
                        {{430, 358, 125}, {675, 306, 85, 100}, {692, 202, 78, 80}, {357, 71, 55, 90}, {275, 216, 85, 120}, 
                         {207, 382, 77, 110}},
                        {{452, 262, 130}, {136, 370, 60, 100}, {104, 315, 50, 80}, {273, 327, 30, 70}, {263, 263, 30, 40}, 
                         {120, 140, 50, 120}, {289, 145, 40, 105}, {298, 71, 60, 95}, {575, 326, 45, 80}, {741, 283, 30, 50}, 
                         {746, 162, 55, 20}, {599, 200, 30, 60}, {626, 104, 50, 50}}};
int effectInfo[][] = {{577, 180}, {583, 297}, {516, 344}, {581, 379}, {381, 348}, {423, 222}, {424,59}, {450, 250}};
//area[scene][area][i(0 = x1, 1 = x2, 2 = y1, 3= y2)], (x1 < x2 | y1 < y2)
//scene 0 = opening, 1 = ending, 2 = Howto , 3 = Ready
int handArea[][][] = {{{75,266,221,362},{605,708,23,126},{126,250,54,178}}
                      ,{{145,286,153,256}},{{195,336,341,482}}
                      ,{{405,508,271,412}}
                      ,{{75,266,221,362},{605,708,23,126}}};

                         
PImage backgroundImage;
PImage howtoImage;
PImage readyImage;
PImage SelectScene_start;
PImage SelectScene_exit;
PImage SelectScene_how;

void setup(){
  size(900,500);
  
  frameRate(60);
  rectMode(CENTER);
  imageMode(CENTER);
  noStroke();
  
  font = loadFont("AdobeGothicStd-Bold-48.vlw");
  textFont(font);
  
  for(int i = 1 ; i <= 7 ; i++){
    effectImage.add(loadImage("Opening_000" + i + ".png"));
  }
  effectImage.add(loadImage("Opening_background.png"));
  
  //setting sound
  //load Minim class
  minim = new Minim(this);

  bulletSound = minim.loadFile("shot.mp3");
  BGM1 = minim.loadFile("Opening.wav");
  BGM2 = minim.loadFile("Play1.wav");
  BGM3 = minim.loadFile("Play2.wav");
  
  SelectScene_start = loadImage("SelectScene_START.png");
  SelectScene_exit = loadImage("SelectScene_EXIT.png");
  SelectScene_how = loadImage("SelectScene_HOW.png");
  howtoImage = loadImage("HowtoPlay.png");
  
  //setting controller
  acont = new attackController(0, 0, 20);
  dcont = new defenceController(0, 0, 30);
  
  setupKinect();
}

void draw(){
  background(0);
  
  //step Controll
  switch(sceneFlag){
    case 0 :        //case SETTING
      
      //settingPosition
      //setting Player
      player = new Player(int(stageInfo[stageFlag][0][0]), int(stageInfo[stageFlag][0][1]), int(stageInfo[stageFlag][0][2]));
      
      //setting controller
      acont = new attackController(player.x, player.y, 20);
      dcont = new defenceController(player.x, player.y, 30);
      
      //setting Enemy
      for(int i = 1 ; i < stageInfo[stageFlag].length ; i++){
          enemy.add(new Enemy(int(stageInfo[stageFlag][i][0]), int(stageInfo[stageFlag][i][1]), int(stageInfo[stageFlag][i][2]), int(stageInfo[stageFlag][i][3])));
      }
        
      //settingImage
      //setting backgroundImage
      backgroundImage= loadImage("Map" + (stageFlag+1) + "_background.png");
      
      //setting playerImage
      player.image = loadImage("Map" + (stageFlag+1) + "_player.png");
      
      //setting enemyImage
      for(int i = enemy.size()-1 ; i >= 0 ; i--){
          Enemy temp = (Enemy) enemy.get(i);
          if(i < 9){
            print("Enemy" + i + " : Map" + stageFlag+1 + "_000" + (i+1) + ".png");
            temp.getImage("Map" + (stageFlag+1) + "_000" + (i+1) + ".png");
            temp.attackFlag = true;
          }else{
            print("Enemy" + i + " : Map" + stageFlag+1 + "_000" + (i+1) + ".png");
            temp.getImage("Map" + (stageFlag+1) + "_00" + (i+1) + ".png");
            temp.attackFlag = true;
          }
        }
      
      //setting attackFlag
      player.attackFlag = true;
      sceneFlag = 6;
      gameTimer = 0;
      //startBGM2
      BGM2.loop();
      
      //setting redayscene
      readyImage = loadImage("readyStage0" + (stageFlag+1) + ".png");
      
      break;
    case 1 :        //case PLAY
      //draw background
      image(backgroundImage, width/2, height/2);      
  
      //update Enemy
      for(int i = 0 ; i < (enemy.size()) ; i++){
        Enemy temp = (Enemy) enemy.get(i);
    
        if(temp.Update() == false){
           enemy.remove(i);
           
           if(enemy.size() <= 0){
             if(stageFlag < stageInfo.length-1){
               stageFlag += 2;
               gameScore[stageFlag] = gameTimer;
               sceneFlag = 0;
             }else{
               gameScore[stageFlag] = gameTimer;
               sceneFlag = 2;
             }
           }
         }
       }
       
      //update Palyer
      if(player.Update() == false){
        sceneFlag = 3;
      }
       
       //update Controller
       acont.Update();
       dcont.Update();
       
      //drawObjetct
      //draw player
      player.drawPlayer();
      //draw Enemy
      for(int i = 0 ; i < (enemy.size()) ; i++){
        Enemy temp = (Enemy) enemy.get(i);
        temp.drawEnemy();
      }
      //draw Bullet
      //draw player Bullet
      player.drawBullet();
      
      //draw enemy Bullet
      for(int i = 0 ; i < (enemy.size()) ; i++){
        Enemy temp = (Enemy) enemy.get(i);
        temp.drawBullet();
      }
      
      acont.drawController();
      dcont.drawController();
       
       //draw Text(Timer)
       fill(#FFFFFF);
       text(maxTime-gameTimer, 50, 50);
      
       //update Timer
       if(frameCount % 60 == 0){
         gameTimer++;
         
         if(gameTimer > maxTime){
           sceneFlag = 3;
         }
       }
       break;
     
     case 2 :        //case CLEAR
       
       int endingScore = 0;
       String endingMsg;
       
       for(int i = 0 ; i < stageInfo.length ; i++){
         endingScore += gameScore[i];
       }
         
       fill(#FFFFFF);
       text("CLEAR",width/2,height/2);
       if((endingScore/stageInfo.length) < 1 && (endingScore/stageInfo.length) >= 0){
         endingMsg = "F";
       }else if((endingScore/stageInfo.length) < 2 && (endingScore/stageInfo.length) >= 1){
         endingMsg = "D";
       }else if((endingScore/stageInfo.length) < 4 && (endingScore/stageInfo.length) >= 2){
         endingMsg = "C";
       }else if((endingScore/stageInfo.length) < 5 && (endingScore/stageInfo.length) >= 4){
         endingMsg = "B";
       }else if((endingScore/stageInfo.length) < 7 && (endingScore/stageInfo.length) >= 5){
         endingMsg = "A";
       }else if((endingScore/stageInfo.length) > 7){
         endingMsg = "S";
       }else{
         endingMsg = "Unkown";
       }
       text("Your grade : " + endingMsg,width/2,(height/2)+100);
       
       image(SelectScene_exit, ((handArea[1][0][0]+handArea[1][0][1])/2), (handArea[1][0][2]+handArea[1][0][3])/2);
       
       bulletSound.close();
       BGM1.close();
       BGM2.close();
       BGM3.close();

       
       //exit
       if(isHandInArea(handArea[1][0])){
            bulletSound = minim.loadFile("shot.mp3");
            BGM1 = minim.loadFile("Opening.wav");
            BGM2 = minim.loadFile("Play1.wav");
            BGM3 = minim.loadFile("Play2.wav");
            //start BGM1
            BGM1.loop();
            stageFlag = 0;
            sceneFlag = 4;
        }
       
       
       if(convertedRightHand != null && convertedLeftHand != null){
         //draw position
          drawHand();
        }
       break;
       
     case 3 :        //case LOSE
       fill(#FFFFFF);
       text("YOU LOSE",width/2,height/2);
       if(convertedRightHand != null && convertedLeftHand != null){
         //draw Position
         drawHand();
       }
       
       image(SelectScene_start, (handArea[0][0][0]+handArea[0][0][1])/2, (handArea[0][0][2]+handArea[0][0][3])/2);
       image(SelectScene_exit, (handArea[0][1][0]+handArea[0][1][1])/2, (handArea[0][1][2]+handArea[0][1][3])/2);
        
        if(isHandInArea(handArea[0][0])){
            gameTimer = 0;
            player.isAlive = true;
            player.health = player.size/3;
            sceneFlag = 1;
          }
          
          //exit
          if(isHandInArea(handArea[0][1])){
            print("GameisEnd");
            goExit();
          }
        
       break;
       
     case 4 :        //case OPENING
        for(int i = 7 ; i >= 0 ; i--){
          PImage temp = (PImage) effectImage.get(i);
          image(temp, effectInfo[i][0], effectInfo[i][1]);
        }
        
        
        //start BGM1
        switch(BgmFlag){
          case 0 : 
            startBGM(BGM1);
            BgmFlag = 1;
            break;
        }
        
        //if Kinect is on
        if(convertedRightHand != null && convertedLeftHand != null){
          //draw position
          print("OPENING : kinect is on ");
          drawHand();
        }
        
        image(SelectScene_how, (handArea[0][2][0]+handArea[0][2][1])/2, (handArea[0][2][2]+handArea[0][2][3])/2);
        image(SelectScene_start, (handArea[0][0][0]+handArea[0][0][1])/2, (handArea[0][0][2]+handArea[0][0][3])/2);
        image(SelectScene_exit, (handArea[0][1][0]+handArea[0][1][1])/2, (handArea[0][1][2]+handArea[0][1][3])/2);
                  //if both postion is crossed, go to next sceen
          
          if(isHandInArea(handArea[0][0])){
            sceneFlag = 0;
            BGM1.close();
            BgmFlag = 0;
          }
          
          //exit
          if(isHandInArea(handArea[0][1])){
            print("GameisEnd");
            goExit();
          }
          
          //exit
          if(isHandInArea(handArea[0][2])){
            print("howto");
            sceneFlag = 5;
          }
        break; 
     case 5 :        //case HOWTO
       //exit
       image(howtoImage, width/2, height/2);
       image(SelectScene_exit, (handArea[2][0][0]+handArea[2][0][1])/2, (handArea[2][0][2]+handArea[2][0][3])/2);
       
      if(convertedRightHand != null && convertedLeftHand != null){
         //draw Position
         drawHand();
       }
       
       if(isHandInArea(handArea[2][0])){
         print("menu");
         sceneFlag = 4;
       }
       break;
       
      case 6 :        //case ReadyStage
       //exit
       image(readyImage, width/2, height/2);
       image(SelectScene_start, (handArea[3][0][0]+handArea[3][0][1])/2, (handArea[3][0][2]+handArea[3][0][3])/2);
       
      if(convertedRightHand != null && convertedLeftHand != null){
         //draw Position
         drawHand();
       }
       
       if(isHandInArea(handArea[3][0])){
         print("GameStart");
         sceneFlag = 1;
       }
       break;
  }
  
  //update Kinect(update Postion of hand);
  updateKinect();
}

void drawHand(){
  if(convertedRightHand != null && convertedLeftHand != null){
    image(acont.image, mouseX, mouseY);
    image(dcont.image, mouseX, mouseY);
    
    //using can update hand position
    /*
    image(acont.image, convertedRightHand.x, convertedRightHand.y);
    image(dcont.image, convertedLeftHand.x, convertedLeftHand.y);
    */
  }
  
}

void exit(){
  //remove Enemy Arraylist, and remove bullet
  for(int i = 0 ; i < int(enemy.size()) ; i++){
    Enemy temp = (Enemy) enemy.get(i);
    
    if(temp.bullet.size() > 0){
      for(int j = 0 ; j < int(temp.bullet.size()) ; j++){
        temp.bullet.remove(i);
      }
    } 
    enemy.remove(i);
  }
  
  //remove sound
  bulletSound.close();
  BGM1.close();
  BGM2.close();
  BGM3.close();
  minim.stop();
}

void goExit(){
  super.exit();
}

boolean isHandInArea(int area[]){
  //LeftHand
  if(convertedRightHand != null && convertedLeftHand != null){
    if(convertedLeftHand.x > area[0] && convertedLeftHand.x < area[1] && convertedLeftHand.y > area[2] && convertedLeftHand.y < area[3]){
      //RightHand
      if(convertedRightHand.x > area[0] && convertedRightHand.x < area[1] && convertedRightHand.y > area[2] && convertedRightHand.y < area[3]){
        return true;
      }
    }
    
    if(mouseX > area[0] && mouseX < area[1] && mouseY > area[2] && mouseY < area[3]){
        return true;
    }
  }
  return false;
}

void startBGM(AudioPlayer bgm){
  bgm.loop();
}
