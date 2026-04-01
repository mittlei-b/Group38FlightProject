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
  
  public int getX() {return x;}
  public int getY() {return y;}
  public String getOption() {return content;}
  
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
