class Chart extends Widget {
  ArrayList<String> labels;
  ArrayList<Integer> values;
  int number;
  
  Chart(int x,int y, int width, int height, String label, color widgetColor, PFont widgetFont) {
    super(x,y,width,height,label,widgetColor,widgetFont);
  }
  
  void load(String number, ArrayList<String> labels, ArrayList<String> strValues) {
    this.number = Integer.parseInt(number);
    this.labels = labels;
    values = new ArrayList<Integer>();
    for (String value : strValues) {
      values.add(Integer.parseInt(value));
    }
    
  }
  
  void draw() {
    text(label, x, y - 15);
    int movingY = y;
    int maxValue = 0;
    for (int value : values) {
      if (value > maxValue) maxValue = value;
    }
    for (int count = 0; count < values.size(); count++) {
      int value = values.get(count);
      if (value > 0 && count < 10) {
        fill(widgetColor);
        float rectWidth = (1.0 * value / maxValue) * width;
        rect(x, movingY, rectWidth, 15);
        String valueLabel = labels.get(count);
        fill(0);
        text(valueLabel, x - valueLabel.length() - 25, movingY + 15);
        text(value, x + 5 + rectWidth, movingY + 15);
        movingY += 30;
      }
    }
  } 
}

class Sheet extends Widget {
  ArrayList<Flight> cells;
  PGraphics box;
  
  Sheet(int x,int y, int width, int height, String label, color widgetColor, PFont widgetFont) {
    super(x,y,width,height,label,widgetColor,widgetFont);
    box = createGraphics(width, height);
    cells = new ArrayList<Flight>();
  }
  
  void load(ArrayList<Flight> selected) {
    cells.addAll(selected);
  }
  
  void draw() {
    println("draw");
    textFont(tableFont);
    fill(200);
    rect(x,y,width,height);
    fill(0);
    int movingX = x + 5;
    int movingY = y + 15;
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
    for (int index = 0; index < columnNames.length; index++) {
      text(columnNames[index], movingX, movingY);
      movingX += columnWidths[index];
    }
    for (Flight cell : cells) {
      movingX = x + 5;
      if (movingY < y + height - 5) {
        movingY += 15;
        text(data.carrierCodeToName(cell.carrier), movingX, movingY);
        movingX += columnWidths[0];
        text(cell.origin, movingX, movingY);
        movingX += columnWidths[1];
        text(cell.origCity, movingX, movingY);
        movingX += columnWidths[2];
        text(cell.dest, movingX, movingY);
        movingX += columnWidths[3];
        text(cell.destCity, movingX, movingY);
        movingX += columnWidths[4];
        text(cell.actualDep, movingX, movingY);
        movingX += columnWidths[5];
        text(cell.actualArr, movingX, movingY);
      }
    }
  } 
}
