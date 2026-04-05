class Scrollbar {
  float startY, endY;
  int x, width, height;
  float y;
  color barColor;
  boolean selected;
  float markerDistance;
  int resultHeight;
  
  Scrollbar(int x, int y, int theWidth, int theHeight, color theColor, int resultHeight) {
    this.x = x; this.y = y; width = theWidth; height = theHeight;
    barColor = theColor;
    selected = false;
    startY = y;
    this.resultHeight = resultHeight;
    endY = startY + resultHeight;
    markerDistance = (resultHeight - height) / 14.0;
  }
  
  void draw(){
    if (selected) {
      //if (y + height < mouseY && y + height < endY - markerDistance) y += markerDistance;
      //else if (y > mouseY && y > startY) y -= markerDistance;
      float moveDistance = mouseY - (y + height / 2);
      if (moveDistance < 0) {
        if (y + moveDistance > startY)
          y += moveDistance;
        else y = startY;
      } else if (moveDistance > 0) {
        if (y + height < endY - moveDistance)
          y += moveDistance;
        else y = endY - height;
      }
    }
    fill(barColor);
    rect(x,y,width,height);
  }
  
  public boolean checkIfClicked() {
    return (x <= mouseX && mouseX <= x + width && y <= mouseY && y + height >= mouseY);
  }
  
  public void mouseOn() {
    selected = true;
  }
  
  public void mouseOff() {
    if (selected) selected = false;
  }
  
  public float getY() {
    return (y - startY) / (resultHeight - height);
  }
  
  public int getWidth() {
    return width;
  }
  
  public void setY(float scrollFraction) {
    y = scrollFraction * (resultHeight - height) + startY;
  }
}
