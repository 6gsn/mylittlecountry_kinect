class Player {
  float x, y;
  int size;
  int health;
  int skillGage = 0;
  int bulletSpeed;
  boolean isAlive;
  boolean attackFlag = false;
  boolean skillFlag = false;
  
  PImage image;
  
  ArrayList bullet = new ArrayList();
  
  Player (int tx, int ty, int tsize){
    x = tx;
    y = ty;
    size = tsize;
    health = size/3;
    bulletSpeed = 10;
    isAlive = true;
  }
  
  void isHit(){
    health = health - 1;
    
    if(health <= 0){
      isAlive = false;
    }
  }
  
  boolean Update() {
    if(isAlive == false) {
      return false;
    }
    
    //make Bullet(controll by frameCount)  
    if(frameCount % bulletSpeed == 0 && attackFlag == true){
      if(skillFlag){
        for (int i = 0; i < 360; i+= 20) { 
          float rad = radians(i);
          bullet.add(new playerBullet(x, y, 10, bulletSpeed * 2, cos(rad), sin(rad)));
        }
        bulletSound.rewind();
        bulletSound.play();
        
        skillGage -= 2;
        if(skillGage <= 0){
          skillFlag = false;
        }
      } else{
        bullet.add(new playerBullet(acont.x, acont.y, 10, bulletSpeed * 2));
        bulletSound.rewind();
        bulletSound.play();
      }
    }
    
    for(int i = 0 ; i < (bullet.size() - 1) ; i++){
      playerBullet temp = (playerBullet) bullet.get(i);
        
      if(temp.Update() == false){
        bullet.remove(i);
      }
    }
    
    return true;
  }
  
  void drawBullet(){
    for(int i = 0 ; i < (bullet.size() - 1) ; i++){
      playerBullet temp = (playerBullet) bullet.get(i);
      temp.draw();
    }
  }
  
  void drawPlayer(){
    //draw Palyer
    if(image != null){
      float convertedHealth = map(health, 0, size/10, 0, 255);
      float convertedHealthBar = map(health, 0, size/10, 0, 100);
      
      tint(255, convertedHealth);
      image(image, x, y);
      
      fill(#ff0000);
      rect(x,y,convertedHealthBar,20);
      
      noTint();
    }
    
    //draw skillGage
    fill(#FF0000);
    float convertedGage = map(skillGage, 0, 10, 0, 0);
    rect(x, y, convertedGage, 10);
  }
}
