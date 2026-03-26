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
