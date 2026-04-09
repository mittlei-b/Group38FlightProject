class PieChart extends Widget {
  
  ArrayList<String> labels;
  ArrayList<Integer> values;
  int number;
  
  
  PieChart(int x,int y, int theWidth, int theHeight, String label, color widgetColor, PFont widgetFont) {
    super(x,y,theWidth,theHeight,label,widgetColor,widgetFont);
  }
  
  void draw() {
    textAlign(LEFT, TOP);
    text(label, x-30, y - 20);
    ellipseMode(CORNER);
    ellipse(x, y, theWidth, theWidth);
    float total = 0;
    for (int v : values) {
      total += v;
    }
    float startPoint = 0;
    color[] chartColors= {#001219, #005f73, #0a9396, #94d2bd, #e9d8a6, 
    #ee9b00, #ca6702, #bb3e03, #ae2012, #9b2226};
    for(int i = 0; i < values.size(); i++) {
      fill(chartColors[i]);
      float angle = map(values.get(i), 0, total, 0, TWO_PI);
      arc(x, y, theWidth, theWidth, startPoint, startPoint + angle);
      startPoint += angle;
      //println(angle);
      //float percentage = data.roundToTwoDecimals(angle/TWO_PI * 100);
      //println(labels.get(i) + " " + percentage);
      
      rect(x, y + theWidth + 15*i + 10, 8, 8);
      fill(0);
      textSize(15);
      text((labels.get(i) + " - " + values.get(i) + " flights"), x + 20, y + theWidth + 15*i + 10);
    }
  }
  
  //float valueToAngle(int numbOfThisType, String type, ArrayList<Flight> subset){
  //  float percentOfTotal1 = data.getPercentage(type, subset);
  //  return 0.0;
    
  //}
  
  void load(ArrayList<String> labels, ArrayList<String> strValues) {
    this.labels = labels;
    values = new ArrayList<Integer>();
    for (String value : strValues) {
      values.add(Integer.parseInt(value));
    }
  }

void loadDataWithType(String type, ArrayList<Flight> listFiltered, PieChart theChart) {
    ArrayList<String> stateOrCarrierCodes = new ArrayList<String>();
    switch (type) {
    case "orig":
    case "dest":
      ArrayList<String> stateCodes= data.stateCodes(listFiltered);
      stateOrCarrierCodes = (ArrayList)stateCodes.clone();
      break;
    case "carrier":
      ArrayList<String> carrierCodes = data.carrierCodes(listFiltered);
      stateOrCarrierCodes = (ArrayList)carrierCodes.clone();
      break;
    }
    ArrayList<String> origValues = new ArrayList<String>();
    for (String stateOrCarrierCode : stateOrCarrierCodes) { // Produces an arraylist of the number of flights per airline/orig/dest
      ArrayList<Flight> flightsLikeThis = new ArrayList<Flight>();
      flightsLikeThis.addAll(data.flightsWhichMatchThisCriterion(type, stateOrCarrierCode, listFiltered));
      origValues.add(String.valueOf(flightsLikeThis.size()));
    }
    String[][] stateAmounts = new String[stateOrCarrierCodes.size()][2];
    // Produces a 2d array of the number of flights per airline/orig/dest paired with its label
    for (int i = 0; i<stateOrCarrierCodes.size(); i++) { 
      stateAmounts[i][0] = stateOrCarrierCodes.get(i);
      stateAmounts[i][1] = origValues.get(i);
    }
    int[] values= new int[stateOrCarrierCodes.size()];
    // Sorts array with most common values at the end of the list
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

    // Sorts 2d array in order of most common values, taking only highest ten (in case where total number of airlines is greater than 10)
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
    theChart.load(chartStateCodes, chartValues);
  }
}
