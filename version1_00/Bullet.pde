class Bullet {
  float x,y;
  int size;
  float xSpeed,ySpeed;
  
  PImage image;
    
  Bullet(float tx, float ty, int tsize, int tspeed){
    x = tx;
    y = ty;
    size = tsize;
    xSpeed = tspeed/2;
    ySpeed = tspeed/2;
  }
  
  void draw(){
    image(image, x, y);
  }
}

//enemyBullet control by defenceControl
class enemyBullet extends Bullet {
  
  enemyBullet(float tx, float ty, int tsize, int tspeed){
    
    super(tx, ty, tsize, tspeed);
    
    float rot = atan2(player.y-y, player.x-x);
    
    xSpeed = (int) xSpeed * cos(rot);
    ySpeed = (int) ySpeed * sin(rot);
    
    image = loadImage("enemyBullet.png");
  }
  
   boolean Update(){
   if(y > height || y < 0 || x > width || x < 0) {
     return false;
    }
    
    if(dist(x, y, player.x, player.y) < size + (player.size/2)) {
     player.isHit();
     return false;
    }
    
     if(dist(x, y, dcont.x, dcont.y) < size + dcont.size) {
     dcont.isHit();
     return false;
    }
    
    x = x + xSpeed;
    y = y + ySpeed;

    return true;
   }
       
   
 }
 
 //playerBullet control by Enemy
 class playerBullet extends Bullet {
  
  playerBullet(float tx, float ty, int tsize, int tspeed){
    
    super(tx, ty, tsize, tspeed);
    
    xSpeed = (int) xSpeed * cos(acont.rot);
    ySpeed = (int) ySpeed * sin(acont.rot);
    
    image = loadImage("playerBullet.png");
  }  

  playerBullet(float tx, float ty, int tsize, int tspeed, float cos_radi, float sin_radi){
    
    super(tx, ty, tsize, tspeed);
    
    xSpeed = (int) xSpeed * cos_radi;
    ySpeed = (int) ySpeed * sin_radi;
    
    image = loadImage("playerBullet.png");
  }
  
   boolean Update(){
   if(y > height || y < 0 || x > width || x < 0) {
     return false;
    }
    
    //Update enemy or remove
    for(int i = 0 ; i < (enemy.size()) ; i++){
      Enemy temp = (Enemy) enemy.get(i);
      

      if(dist(x, y, temp.x, temp.y) < size + temp.size) {
        temp.isHit();
        return false;
      }
   }
    
    x = x + xSpeed;
    y = y + ySpeed;

    return true;
  
   }
}
