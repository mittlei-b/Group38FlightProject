class Player
{
  int x_position;
  int y_position;
  color paddle_color = color(50);
  PImage ship_img = loadImage("spaceship.gif");
  PImage ship_state;
  int width;
  int height;
  
  Player(int screen_x, int screen_y, int width, int height)
  {
    x_position = screen_x / 2;
    y_position = screen_y;
    this.width = width;
    this.height = height;
  }
  
  void move(int x)
  {
    if (x > SCREEN_WIDTH - width)
      x_position = SCREEN_WIDTH - width;
    else
      x_position = x;
  }
  
  int x_position() {
    return x_position;
  }
  
  int y_position() {
    return y_position;
  }
  
  void draw()
  {
    fill(100);
    rect(x_position, y_position, width, height);
  }
  
  void powerUp(int type) {
    if (type == 1) {
      changePower("Double Trouble");
      change_bullet_number(2);
      change_bullet_size(5);
      change_bullet_speed(8);
    } else if (type == 2) {
      changePower("Mega Bullet");
      change_bullet_number(1);
      change_bullet_size(8);
      change_bullet_speed(8);
    } else {
      changePower("Zoomies");
      change_bullet_number(1);
      change_bullet_size(5);
      change_bullet_speed(12);
    }
  }
}
