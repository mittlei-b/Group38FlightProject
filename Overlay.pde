public class Overlay {
  ArrayList<Input> inputs;
  color backgroundColor;
  
  public Overlay(ArrayList<Input> boxes, color background) {
    inputs = boxes;
    backgroundColor = background;
  }
  
  public void draw() {
    fill(backgroundColor);
    noStroke();
    int startX = 0;
    int scanX = 0;
    int startY = 0;
    int scanY = 0;
    int hitBoxDirection = 0;
    while (scanX < SCREEN_WIDTH) {
      scanX++;
      if (scanX == SCREEN_WIDTH) {
        startY = 0;
        scanY = 0;
        while (scanY < SCREEN_HEIGHT) {
          scanY++;
          for (Input box : inputs) {
            if (box.isHitting(scanX, scanY)) {
              rect(startX, startY, scanX - startX, scanY - startY);
              startY = scanY + box.getHeight() + 1;
              scanY = startY + 1;
            }
          }
        }
        rect(startX, startY, scanX - startX, scanY - startY);
      }
      for (Input box : inputs) {
        if (box.getX() == scanX)
          hitBoxDirection = -1;
        if (box.getX() + box.getWidth() == scanX)
          hitBoxDirection = 1;
        if (hitBoxDirection != 0) { // if we hit a box
          scanX += hitBoxDirection;
          startY = 0;
          scanY = 0;
          while (scanY < SCREEN_HEIGHT) {
            scanY++;
            for (Input otherBox : inputs) {
              if (otherBox.isHitting(scanX, scanY)
                  || (box.getY() == scanY && hitBoxDirection == 1)) {
                rect(startX,startY, scanX - hitBoxDirection - startX, scanY - startY);
                startY = scanY + otherBox.getHeight() + 1;
                scanY = startY + 1;
              }
            }
          }
          scanX -= hitBoxDirection;
          hitBoxDirection = 0;
          rect(startX, startY, scanX - startX, scanY - startY);
          startX = scanX;
        }
      }
    }
  }
}
