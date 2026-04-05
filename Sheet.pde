class Sheet extends Widget {
  ArrayList<Flight> cells;
  PGraphics box;
  int boxX; int boxY;
  float itemHeight;
  int headerHeight;
  int totalPerPage;
  int totalPages;
  int presentPage;
  int resultHeight;
  int barHeight;
  color headerColor = color(120,190,240);
  color barColor = color(100,170,220);
  Scrollbar bar;
  
  Sheet(int x,int y, int theWidth, int theHeight, String label, color widgetColor, PFont widgetFont) {
    super(x,y,theWidth,theHeight,label,widgetColor,widgetFont);
  }
  
  void load(ArrayList<Flight> selected) {
    cells = selected;
    presentPage = 0;
    totalPerPage = 25;
    totalPages = cells.size() - totalPerPage;
    if (totalPages < 1) totalPages = 1;
    presentPage = 0;
    headerHeight = 20;
    resultHeight = theHeight - headerHeight;
    itemHeight = resultHeight / (float)totalPerPage;
    box = createGraphics(theWidth, resultHeight);
    barHeight = resultHeight * 700 / (int)(totalPages + 699);
    if (barHeight < 10) barHeight = 10;
    if (barHeight > resultHeight) barHeight = resultHeight;
    bar = new Scrollbar(x + theWidth - 10, y + headerHeight, 10, barHeight, headerColor, resultHeight);
  }
  
  void draw() {
    presentPage = (int)(totalPages * bar.getY());
    textFont(tableFont);
    noStroke();
    float movingX = x + 5;
    textAlign(LEFT, TOP);
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
    fill(headerColor);
    rect(x,y,theWidth,headerHeight);
    fill(0);
    for (int index = 0; index < columnNames.length; index++) {
      text(columnNames[index], movingX, y + 7);
      movingX += columnWidths[index];
    }
    box.beginDraw();
    box.noStroke();
    float movingY = 0;
    int itemLimit = 25;
    for (int index = presentPage; index < (presentPage + itemLimit + 1); index++) {
      boolean isEmpty = (cells.size() <= index);
      movingX = 5;
      if (isEmpty || index % 2 == 0) box.fill(255);
      else box.fill(color(210,230,245));
      box.rect(0,movingY,theWidth,itemHeight);
      box.fill(0);
      movingY += itemHeight - 3;
      if (!isEmpty) {
        Flight cell = cells.get((int)index);
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
      movingY += 3;
    }
    box.endDraw();
    image(box,x,y + headerHeight);
    stroke(0);
    fill(255);
    rect(x + theWidth - bar.getWidth(),y + headerHeight, bar.getWidth(),resultHeight);
    fill(0,0,0,0);
    rect(x,y,theWidth,theHeight);
    rect(x,y,theWidth,headerHeight);
    bar.draw();
  }
  
  public void checkIfScrolled(int direction) {
    if (x <= mouseX && mouseX <= x + theWidth
        && y <= mouseY && mouseY <= y + theHeight) {
      if ((direction > 0 && presentPage < totalPages) || (direction < 0 && presentPage > 0)) {
          presentPage += direction;
          if (presentPage < 0) presentPage = 0;
          if (presentPage > totalPages) presentPage = totalPages;
          bar.setY((float)presentPage / totalPages);
      }
    }
  }
  
  public void scrollBarClick() {
    if (bar.checkIfClicked()) bar.mouseOn();
  }
  
  public void scrollBarRelease() {
    bar.mouseOff();
  }
}
