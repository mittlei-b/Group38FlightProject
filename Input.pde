public class Input {
  PGraphics box;
  PFont boxFont;
  int x, offsetX, y, width, height;
  String label, defaultText, userInput, content;
  boolean selected, entered;
  color border, fontColor;
  boolean dropdown;
  
  public Input(String label, int x_position, int y_position, int width, int height, String standIn, boolean isDropdown) {
    box = createGraphics(width, height);
    this.width = width;
    this.height = height;
    this.label = label;
    defaultText = standIn;
    userInput = "";
    content = defaultText;
    x = x_position;
    offsetX = 0;
    y = y_position;
    selected = false;
    entered = false;
    fontColor = color(200);
    dropdown = isDropdown;
    
  }
  
  public void loadDropdown() {
    println("Load dropdown");
  }
  
  public void draw() {
    box.beginDraw();
    box.background(255);
    box.fill(fontColor);
    box.textSize(18);
    box.text(content, 5 + offsetX, 0 + 6);
    box.fill(0,0,0,0);
    box.textAlign(LEFT, TOP);
    box.stroke(border);
    box.rect(1,2,width - 2,height - 4);
    box.endDraw();
    
    image(box,x,y);
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
    offsetX = 0;
    if (!entered) {
      fontColor = color(200);
      content = defaultText;
    } else {
      fontColor = color(0);
      content = userInput;
    }
  }
  
  public boolean isSelected() {
    return selected;
  }
  
  
  public void updateState() {
    boolean newSelectedState = selected;
    if (newSelectedState) { // if selected
      fontColor = color(0);
      content = userInput;
      offset();
    } else if (selected != newSelectedState) { // else if unselected
      deselect();
    }
    selected = newSelectedState;
  }
  
  public void updateInput(char letter) {
    if (selected) {
      if (letter == BACKSPACE && userInput.length() > 0) {
        userInput = userInput.substring(0,userInput.length() - 1);
        if (userInput.length() == 0) entered = false;
      } else if ((41 <= letter && letter <= 175) || letter == ' ') {
        entered = true;
        userInput += letter;
      }
      if (letter == ENTER || letter == RETURN) {
        if (userInput == "") entered = false;
        deselect();
      } else {
        content = userInput;
        offset();
      }
    }
  }

  public void offset() {
    int textWidth = (int)textWidth(content) + 5;
    if (textWidth > width) {
      offsetX = width - textWidth;
    } else offsetX = 0;
  }
  
  public String getText() {
    return content;
  }
  
  public boolean getState() {
    return selected;
  }
}
