class Chart extends Widget {
  ArrayList<String> labels;
  ArrayList<Integer> values;
  int number;
  
  Chart(int x,int y, int theWidth, int theHeight, String label, color widgetColor, PFont widgetFont) {
    super(x,y,theWidth,theHeight,label,widgetColor,widgetFont);
  }
  
  void load(String number, ArrayList<String> labels, ArrayList<String> strValues) {
    this.number = Integer.parseInt(number);
    this.labels = labels;
    values = new ArrayList<Integer>();
    for (String value : strValues) {
      values.add(Integer.parseInt(value));
    }
    
  }

void loadDataWithType(String number, String type, ArrayList<Flight> listFiltered, Chart theChart) {
    ArrayList<String> stateCodes = data.stateCodes(listFiltered);
    //println(stateCodes);
    ArrayList<String> origValues = new ArrayList<String>();
    for (String stateCode : stateCodes) {
      ArrayList<Flight> originFlights = new ArrayList<Flight>();
      originFlights.addAll(data.flightsWhichMatchThisCriterion(type, stateCode, listFiltered));
      origValues.add(String.valueOf(originFlights.size()));
    }
    String[][] stateAmounts = new String[stateCodes.size()][2];
    for (int i = 0; i<stateCodes.size(); i++) {
      stateAmounts[i][0] = stateCodes.get(i);
      stateAmounts[i][1] = origValues.get(i);
    }
    int[] values= new int[stateCodes.size()];
    for (int i=0; i<origValues.size(); i++) {
      values[i] = Integer.parseInt(origValues.get(i));
    }
    Arrays.sort(values);

    //reverses list
    for (int i = 0; i < values.length / 2; i++)
    {
      int temp = values[i];
      values[i] = values[values.length - i - 1];
      values[values.length - i - 1] = temp;
    }
    ArrayList<String> chartStateCodes = new ArrayList<String>();
    ArrayList<String> chartValues = new ArrayList<String>();

    if (values.length >= 10) {

      for (int i = 0; i < 10; i++) {
        chartValues.add(String.valueOf(values[i]));
      }

      for (String value : chartValues) {
        String correctStateCode = "";
        for (int i = 0; i< stateAmounts.length; i++) {
          if (chartStateCodes.indexOf(stateAmounts[i][0]) == -1) {
            if (value.equals(stateAmounts[i][1])) {
              correctStateCode = stateAmounts[i][0];
            }
          }
        }
        chartStateCodes.add(correctStateCode);
      }
    } else {
      for (int i = 0; i < values.length; i++) {
        chartValues.add(String.valueOf(values[i]));
      }

      for (String value : chartValues) {
        String correctStateCode = "";
        for (int i = 0; i< stateAmounts.length; i++) {
          if (chartStateCodes.indexOf(stateAmounts[i][0]) == -1) {
            if (value.equals(stateAmounts[i][1])) {
              correctStateCode = stateAmounts[i][0];
            }
          }
        }
        chartStateCodes.add(correctStateCode);
      }
    }
    theChart.load(number, chartStateCodes, chartValues);
  }
  
  void draw() {
    textAlign(LEFT, TOP);
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
        float rectWidth = (1.0 * value / maxValue) * theWidth;
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
