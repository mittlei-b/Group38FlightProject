public class Input {
  PGraphics box;
  PFont boxFont;
  int x, offsetX, y, theWidth, theHeight;
  String label, defaultText, userInput, content;
  boolean selected, entered;
  color border, fontColor;
  
  
  public Input(String label, int x_position, int y_position, int theWidth, int theHeight, String standIn) {
    box = createGraphics(theWidth, theHeight);
    this.theWidth = theWidth;
    this.theHeight = theHeight;
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
  }
  
  public void draw() {
    box.beginDraw();
    box.textAlign(LEFT, TOP);
    box.background(255);
    box.fill(fontColor);
    box.textSize(18);
    box.text(content, 5 + offsetX, 0 + 6);
    box.fill(0,0,0,0);
    box.stroke(border);
    box.strokeWeight(2);
    box.rect(0,0,theWidth,theHeight - 1);
    box.endDraw();
    
    image(box,x,y);
  }
  
  public void checkIfClicked() {
    if (x <= mouseX && mouseX <= x + theWidth
        && y <= mouseY && y + theHeight >= mouseY) {
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
  
  public void deleteOnEmpty() {} // This method is commandeered in Dropdown class
  
  public void checkEnterPressed(char letter) {
    if (letter == ENTER || letter == RETURN) {
      if (userInput == "") entered = false;
      deselect();
    } else {
      content = userInput;
      offset();
    }
  }
  
  public void updateInput(char letter) {
    if (selected) {
      if (letter == BACKSPACE && userInput.length() == 0) deleteOnEmpty();
      else if (letter == BACKSPACE && userInput.length() > 0) {
        userInput = userInput.substring(0,userInput.length() - 1);
        if (userInput.length() == 0) entered = false;
      } else if ((41 <= letter && letter <= 175) || letter == ' ') {
        entered = true;
        userInput += letter;
      }
      checkEnterPressed(letter);
    }
  }

  public void offset() {
    int textWidth = (int)box.textWidth(content) + 10;
    if (textWidth > theWidth) {
      offsetX = theWidth - textWidth;
    } else offsetX = 0;
  }
  
  public String getText() {
    return content;
  }
  
  public boolean getState() {
    return selected;
  }
}
