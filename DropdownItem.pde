/*  Class to create a DropdownItem to support the Dropdown class.
    A DropdownItem serves as one of the options in the Dropdown
    that the user can select, or that is automatically selected if the
    user types the item in.
**/
public class DropdownItem {
  PGraphics box;
  PFont boxFont;
  String content;
  boolean selected;
  color border, fontColor;
  boolean dropdown;
  int x,y,offsetY,theWidth,theHeight;
  
  public DropdownItem(String content, int x_position, int y_position, int theWidth, int theHeight) {
    box = createGraphics(theWidth, theHeight);
    this.theWidth = theWidth;
    this.theHeight = theHeight;
    this.content = content;
    x = x_position;
    y = y_position;
    selected = false;
    fontColor = color(0);
    border = color(200);
  }
  
  // Accessors that help Dropdown know which option that user has selected
  public int getX() {return x;}
  public int getY() {return y;}
  
  // A function that returns the String version of the option
  public String getOption() {return content;}
  
  // A function that returns the PGraphics visual for the class
  public PGraphics drawnBox() {
    box.beginDraw();
    box.textAlign(LEFT, TOP);
    box.background(255);
    box.fill(fontColor);
    box.textSize(18);
    box.text(content, 5, 5);
    box.fill(0,0,0,0);
    box.stroke(border);
    box.strokeWeight(1);
    box.rect(0,0,theWidth,theHeight - 1);
    box.endDraw();
    return box;
  }
  
  // A functions that updates the item if it is selected or unselected
  public boolean updateState() {
    if (selected) {
      fontColor = color(0);
    } else {
      fontColor = color(200,0,0);
    }
    selected = !selected;
    return selected;
  }
}
