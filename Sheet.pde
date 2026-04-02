class Sheet extends Widget {
  ArrayList<Flight> cells;
  PGraphics box;
  int boxX; int boxY;
  int offsetY;
  
  Sheet(int x,int y, int theWidth, int theHeight, String label, color widgetColor, PFont widgetFont) {
    super(x,y,theWidth,theHeight,label,widgetColor,widgetFont);
    box = createGraphics(theWidth, theHeight - 15);
  }
  
  void load(ArrayList<Flight> selected) {
    cells = new ArrayList<Flight>();
    cells.addAll(selected);
    offsetY = 0;
  }
  
  void draw() {
    textFont(tableFont);
    noStroke();
    int movingX = x + 5;
    int movingY = y - offsetY;
    textAlign(LEFT, BASELINE);
    /*int[] variableWidths = {140,50,60,50,180,70,70,70,180,70,70,80,80,70,70,50,50,50};
    String[] columnNames = {"Date","Carrier","Carrier #","Origin","Dep. City",
                            "Dep. State", "Dep. Code", "Destination", "Arr. City",
                            "Arr. State", "Arr. Code", "Planned Dep.", "Actual Dep.",
                            "Planned Arr.", "Actual Arr.", "Cancelled","Diverted",
                            "Cancelled"};**/
    /* String date, carrier, origin, origCity, origStateAbr, dest, destCity,
    destStateAbr;
    int carrierNumb, originCode, destCode, plannedDep, actualDep,
      plannedArr, actualArr;
    float distance;
    boolean diverted, cancelled;**/
    int[] columnWidths = {60,45,110,45,110,60,60};
    String[] columnNames = {"Airline","Airport","City","Airport","City","Left At","Arrived At"};
    fill(200);
    //rect(x,y,theWidth,15);
    fill(0);
    for (int index = 0; index < columnNames.length; index++) {
      text(columnNames[index], movingX, y);
      movingX += columnWidths[index];
    }
    int colorChange = -10;
    movingY = 0 - offsetY;
    box.beginDraw();
    box.noStroke();
    for (Flight cell : cells) {
      movingX = 5;
      if (movingY < theHeight - 20) {
        box.fill(230 + (colorChange *= -1));
        box.rect(movingX - 5,movingY + 2,theWidth,15);
        box.fill(0);
        movingY += 15;
        box.text(data.carrierCodeToName(cell.carrier), movingX, movingY);
        movingX += columnWidths[0];
        box.text(cell.origin, movingX, movingY);
        movingX += columnWidths[1];
        box.text(cell.origCity, movingX, movingY);
        movingX += columnWidths[2];
        box.text(cell.dest, movingX, movingY);
        movingX += columnWidths[3];
        box.text(cell.destCity, movingX, movingY);
        movingX += columnWidths[4];
        box.text(cell.actualDep, movingX, movingY);
        movingX += columnWidths[5];
        box.text(cell.actualArr, movingX, movingY);
      }
    }
    box.endDraw();
    image(box,x,y + 15);
    fill(0,0,0,0);
    stroke(0);
    rect(x,y,theWidth,theHeight);
  }
  
  public void checkIfScrolled(int direction) {
    if (x <= mouseX && mouseX <= x + theWidth
        && y <= mouseY && mouseY <= y + theHeight) {
      int maxOffset = 2000; // itemList.size() * theHeight;
      if ((direction > 0 && offsetY < maxOffset) || (direction < 0 && offsetY > 0))
        offsetY += 10 * direction;
      println(offsetY);
    }
  }
}
