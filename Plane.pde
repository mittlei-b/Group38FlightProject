class Plane {
  float x, y;
  float speed = 2;
  int direction = -1;
  PImage leftPlane;
  PImage rightPlane;
  
  Plane(float x, float y) {
  this.x = x;
  this.y = y;
  leftPlane = loadImage("LeftFacingPlane.PNG");
  leftPlane.resize(300, 0);
  rightPlane= loadImage("RightFacingPlane.PNG");
  rightPlane.resize(300, 0);
  }
  
  void move() {
    x += speed*direction;
    
    if(x <= -leftPlane.width) {
      direction = 1;
      y = 400;
    }
    else if(x >= SCREEN_WIDTH) {
      direction = -1;
      y = 60;
    }
    
  }
  
  void drawPlane() {
      if(direction == -1) {
        image(leftPlane, x, y);
      }
      else if(direction == 1) {
        image(rightPlane, x, y);
      }
  }
}
