public class InputText {
  String label;
  int x, y;
  int offsetX;
  boolean entered;
  boolean selected;
  Input myBox;
  String content;
  String userInput;
  String defaultText;
  color fontColor;
  color border;
  
  public InputText(String label, String standIn, Input box) {
    this.label = label;
    myBox = box;
    x = myBox.getX();
    offsetX = x;
    y = myBox.getY();
    selected = false;
    entered = false;
    defaultText = standIn;
    userInput = "";
    fontColor = color(200);
    content = defaultText;
  }
  
  public void draw() {
    fill(fontColor);
    text(content, offsetX + 5, y + 20);
  }
  
  public void updateState() {
    boolean newSelectedState = myBox.isSelected();
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
  
  public void deselect() {
    myBox.deselect();
    offsetX = x;
    if (!entered) {
      fontColor = color(200);
      content = defaultText;
    } else {
      fontColor = color(0);
      content = userInput;
    }
  }
  
  public void offset() {
    int width = (int)textWidth(content) + 10;
    if (width > myBox.getWidth()) {
      offsetX = x - (width - myBox.getWidth());
    } else offsetX = x;
  }
  
  public String getText() {
    return content;
  }
  
  public boolean getState() {
    return selected;
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
}
