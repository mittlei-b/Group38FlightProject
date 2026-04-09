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
  Scrollbar bar;
  int sortHeight = 90;
  int[][] sortLimits = { {20,0,55},{20,55,115},{20,115,190},{20,190,270},{20,270,350},
                         {40,145,205},{40,205,250},{40,250,305},
                         {60,130,195},{60,195,240},{60,240,295} };
  int sortSelection;
  int boxDrawn;
  Flight selectedFlight;
  // Slider numResults?
  
  Sheet(int x,int y, int theWidth, int theHeight, String label, color widgetColor, PFont widgetFont) {
    super(x,y,theWidth,theHeight,label,widgetColor,widgetFont);
    sortSelection = 0;
    boxDrawn = 0;
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
    if(cells.size() > 0) selectedFlight = cells.get(0);
  }
  
  void drawBox(int the_x, int the_y) {
    if (boxDrawn == sortSelection) fill(0);
    else fill(0,0,0,0);
    rect(the_x,the_y,10,10);
    boxDrawn++;
  }
  
  // Sorts the results table based on the user-selected category
  // Used the resource below to learn how to create and sort Lists
  // https://www.w3schools.com/java/java_advanced_sorting.asp
  void sortSheet() {
    List flightList = new ArrayList<Flight>();
    flightList.addAll(cells);
    Collections.sort(flightList, new Comparator<Flight>() {
      @Override
      public int compare(Flight flight1, Flight flight2) {
        String option1 = "", option2 = "";
        switch (sortSelection) {
          // Sort by date
          case 0:
            // Splits dates into strings like "1/1/2022" or "1/31/2022"
            option1 = flight1.date.split(" 12:00:00 AM")[0];
            option2 = flight2.date.split(" 12:00:00 AM")[0];
            // Takes only the day of the month like "1" or "31"
            if (option1.length() == 8) option1 = option1.substring(2,3);
            else option1 = option1.substring(2,4);
            if (option2.length() == 8) option2 = option2.substring(2,3);
            else option2 = option2.substring(2,4);
            // Converts the day to an integer to compare the two
            int num1 = Integer.valueOf(option1), num2 = Integer.valueOf(option2);
            if (num1 > num2)
              { option1 = "a"; option2 = "b"; }
            else if (num1 < num2)
              { option1 = "b"; option2 = "a"; }
            else { option1 = "a"; option2 = "a"; }
            break;
          // Sort by airline
          case 1:
            option1 = flight1.carrier; option2 = flight2.carrier;
            break;
          // Sort by distance
          case 2:
            if (flight1.distance > flight2.distance)
              { option1 = "a"; option2 = "b"; }
            else if (flight1.distance < flight2.distance)
              { option1 = "b"; option2 = "a"; }
            else { option1 = "a"; option2 = "a"; }
            break;
          // Sort by cancellation
          case 3:
            if (flight1.cancelled) option1 = "a"; else option1 = "b";
            if (flight2.cancelled) option2 = "a"; else option2 = "b";
            break;
          // Sort by diversion
          case 4:
            if (flight1.diverted) option1 = "a"; else option1 = "b";
            if (flight2.diverted) option2 = "a"; else option2 = "b";
            break;
          // Sort by departure airport
          case 5:
            option1 = flight1.origin; option2 = flight2.origin;
            break;
          // Sort by departure city
          case 6:
            option1 = flight1.origCity; option2 = flight2.origCity;
            break;
          // Sort by departure time
          case 7:
            if (flight1.actualDep < flight2.actualDep)
              { option1 = "a"; option2 = "b"; }
            else if (flight1.actualDep > flight2.actualDep)
              { option1 = "b"; option2 = "a"; }
            else { option1 = "a"; option2 = "a"; }
            break;
          // Sort by arrival airport
          case 8:
            option1 = flight1.dest; option2 = flight2.dest;
            break;
          // Sort by arrival city
          case 9:
            option1 = flight1.destCity; option2 = flight2.destCity;
            break;
          // Sort by arrival time
          case 10:
            if (flight1.actualArr < flight2.actualArr)
              { option1 = "a"; option2 = "b"; }
            else if (flight1.actualArr > flight2.actualArr)
              { option1 = "b"; option2 = "a"; }
            else { option1 = "a"; option2 = "a"; }
            break;
        };
        int difference = option1.compareTo(option2);
        if (difference < 0) return -1;
        if (difference > 0) return 1;
        return 0;
      }
    });
    cells = new ArrayList<Flight>();
    cells.addAll(flightList);
  }
  
  void draw() {
    sortSheet();
    textAlign(LEFT, TOP);
    float startingX = x + 535;
    float movingX = startingX;
    float movingY = y - sortHeight;
    fill(headerColor);
    /*
    for (int[] sortOption : sortLimits) {
        int startX = x + 535 + sortOption[1];
        int endX = x + 535 + sortOption[2];
        int startY = (y - sortHeight) + sortOption[0];
        stroke(0);
        fill(255,0,0);
        rect(startX,startY,endX - startX,20);
        noStroke();
    }
    **/
    textFont(loadedFont);
    fill(0);
    text("Choose a Sorting Category",movingX + 60,movingY);
    textFont(tableFont);
    stroke(0);
    String[] topLine = {"Date","Airline","Distance","Cancelled", "Diverted"};
    String[] lowLine = {"Airport","City","Time"};
    int boxSpace = 5;
    int wordSpace = 10;
    boxDrawn = 0;
    movingX = startingX + 10;
    movingY += 25;
    for (String word : topLine) {
      drawBox((int)movingX,(int)movingY);
      movingX += 10 + boxSpace;
      fill(0);
      text(word, movingX, movingY);
      movingX += (textWidth(word) + wordSpace);
    }
    movingX = startingX + 30;
    movingY += 20;
    text("or Sort by Departure {", movingX, movingY);
    movingX += textWidth("or Sort by Departure {") + 5;
    for (String word : lowLine) {
      drawBox((int)movingX,(int)movingY);
      movingX += 10 + boxSpace;
      fill(0);
      text(word, movingX, movingY);
      movingX += textWidth(word) + wordSpace;
    }
    text("}", movingX - 5,movingY);
    movingX = startingX + 40;
    movingY += 20;
    text("or Sort by Arrival {", movingX, movingY);
    movingX += textWidth("or Sort by Arrival {") + 5;
    for (String word : lowLine) {
      drawBox((int)movingX,(int)movingY);
      movingX += 10 + boxSpace;
      fill(0);
      text(word, movingX, movingY);
      movingX += textWidth(word) + wordSpace;
    }
    text("}", movingX - 5,movingY);
    
    textAlign(LEFT, TOP);
    noStroke();
    textFont(tableFont);
    presentPage = (int)(totalPages * bar.getY());
    int[] columnWidths = {60,65,45,170,45,170,60,40,60,60,80};
    String[] columnNames = {"Date","Airline","Airport","City","Airport","City",
                            "Departure","Arrival","Cancelled","Diverted","Distance"};
    fill(headerColor);
    rect(x,y,theWidth,headerHeight);
    fill(0);
    movingX = x + 35;
    for (int index = 0; index < columnNames.length; index++) {
      text(columnNames[index], movingX, y + 7);
      movingX += columnWidths[index];
    }
    box.beginDraw();
    movingY = 0;
    int itemLimit = 25;
    for (int index = presentPage; index < (presentPage + itemLimit + 1); index++) {
      boolean isEmpty = (cells.size() <= index);
      boolean inFocus = (!isEmpty && x < mouseX && mouseX < x + theWidth
                         && y + headerHeight + movingY < mouseY
                         && mouseY < y + headerHeight + movingY + itemHeight);
      movingX = 35;
      if (isEmpty || index % 2 == 0) box.fill(255);
      else box.fill(color(210,230,245));
      box.noStroke();
      box.rect(0,movingY,theWidth,itemHeight);
      box.fill(headerColor);
      if (inFocus) {
        box.stroke(0);
        box.ellipse(15,movingY + itemHeight / 2, 10,10);
        box.noStroke();
        selectedFlight = cells.get(index);
      }
      box.fill(0);
      movingY += itemHeight - 3;
      if (!isEmpty) {
        Flight cell = cells.get((int)index);
        box.text(cell.date.split(" 12:00:00 AM")[0], movingX, movingY);
        movingX += columnWidths[0];
        box.text(data.carrierCodeToName(cell.carrier), movingX, movingY);
        movingX += columnWidths[1];
        box.text(cell.origin, movingX, movingY);
        movingX += columnWidths[2];
        box.text(cell.origCity, movingX, movingY);
        movingX += columnWidths[3];
        box.text(cell.dest, movingX, movingY);
        movingX += columnWidths[4];
        box.text(cell.destCity, movingX, movingY);
        movingX += columnWidths[5];
        box.text(cell.actualDep, movingX, movingY);
        movingX += columnWidths[6];
        box.text(cell.actualArr, movingX, movingY);
        movingX += columnWidths[7];
        box.text(cell.cancelled ? "Yes" : "No", movingX, movingY);
        movingX += columnWidths[8];
        box.text(cell.diverted ? "Yes" : "No", movingX, movingY);
        movingX += columnWidths[9];
        box.text(cell.distance, movingX, movingY);
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
  
  public boolean checkIfFlightClicked(int clicked_x, int clicked_y) {
     if (x <= clicked_x && clicked_x <= x + theWidth
        && y <= clicked_y && clicked_y <= y + theHeight) return true;
     else return false;
  }
  
  public void clicked() {
    if (bar.checkIfClicked()) bar.mouseOn();
    else if (checkIfFlightClicked(mouseX, mouseY)) {
      activateFlightInfo(selectedFlight);
    } else {
      for (int index = 0; index < sortLimits.length; index++) {
        int startX = x + 535 + sortLimits[index][1];
        int endX = x + 535 + sortLimits[index][2];
        int startY = (y - sortHeight) + sortLimits[index][0];
        int endY = (y - sortHeight) + startY + 20;
        if (startX < mouseX && mouseX < endX && startY < mouseY && mouseY < endY)
          sortSelection = index;
      }
    }
  }
  
  public void scrollBarRelease() {
    bar.mouseOff();
  }
  
}
