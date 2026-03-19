public class Input {
  int x, y, width, height;
  String label;
  boolean selected;
  color border;
  boolean dropdown;
  
  public Input(String label, int x_position, int y_position, int width, int height, boolean isDropdown) {
    this.label = label;
    x = x_position;
    y = y_position;
    this.width = width;
    this.height = height; 
    border = color(0);
    selected = false;
    border = color(0);
    dropdown = isDropdown;
  }
  
  public void loadDropdown() {
    println("Load dropdown");
  }
  
  public void draw() {
    //fill(80,220,120);
    fill(255);
    stroke(border);
    rect(x, y, width, height);
    fill(0);
    text("", x + 10, y + 22);
  }
  
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
  
  public int getWidth() {
    return width;
  }
  
  public int getHeight() {
    return height;
  }
  
  public boolean isHitting(int scannerX, int scannerY) {
    if (x <= scannerX && scannerX <= x + width
        && y <= scannerY && y + height >= scannerY)
        return true;
    else return false;
  }
  
  public void checkIfClicked() {
    if (x <= mouseX && mouseX <= x + width
        && y <= mouseY && y + height >= mouseY) {
      selected = true;
      border = color(255,100,100);
    } else deselect();
  }
  
  public void deselect() {
    selected = false;
    border = color(0);
  }
  
  public boolean isSelected() {
    return selected;
  }
}
