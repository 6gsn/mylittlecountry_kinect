class Enemy {
  float x, y;
  int size;
  int health;
  int bulletSpeed = 30;
  boolean attackFlag = false;
  boolean isAlive;
  
  PImage image;
  
  ArrayList bullet = new ArrayList();
  
  Enemy (int tx, int ty, int tsize, int tspeed){
    x = tx;
    y = ty;
    size = tsize;
    bulletSpeed = tspeed;
    health = tsize / 10;
    isAlive = true;
  }
  
  void isHit(){
    
    health = health - 1;
    
    if(health <= 0){
      isAlive = false;
    }
  }
  
  void getImage(String name){
    image = loadImage(name);
  }
  
  boolean Update(){
    if(isAlive == false){
      return false;
    }
    
    //draw HP
    /*
    fill(#FF0000);
    float convertedHealth = map(health, 0, 10, 0, 30);
    rect(x, y, convertedHealth, 5);
    */
    
       
    if(frameCount % bulletSpeed == 0 && attackFlag == true){
      bullet.add(new enemyBullet(x, y, 10, 10));
    }
      
    for(int i = 0 ; i < (bullet.size() - 1) ; i++){
      enemyBullet temp = (enemyBullet) bullet.get(i);
        
      if(temp.Update() == false){
        bullet.remove(i);
      }
    }
    
    return true;
  }
  
  void drawBullet(){
    for(int i = 0 ; i < (bullet.size() - 1) ; i++){
      enemyBullet temp = (enemyBullet) bullet.get(i);
      temp.draw();
      }
  }
  
  void drawEnemy(){
      if(image != null){
        float convertedHealth = map(health, 0, size/10, 0, 255);
      
        tint(255, convertedHealth);
        image(image, x, y);
        noTint();
      }
  }

  /*  
  boolean effectHit(){
     if(frameCount % 5 == 0){
       fill(#FFFFFF);
       rect(x + int(random(-10,10)), y + int(random(-10,10)), 10, 10);
       rect(x + int(random(-10,10)), y + int(random(-10,10)), 10, 10);
     }else{
       return false;
     }

     return true;
   }
   */
}

