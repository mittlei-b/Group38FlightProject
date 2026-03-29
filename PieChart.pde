class PieChart {
  
  void drawPieChart(float x, float y, float diameter, int[] angleArray) {
    ellipse(x, y, diameter, diameter);
    fill(0);
    float startPoint = 0;
    for(int i = 0; i < angleArray.length; i++) {
      float grey = map(i, 0, angleArray.length, 0, 255);
      fill(grey);
      arc(x, y, diameter, diameter, startPoint, startPoint + radians(angleArray[i]));
      startPoint += radians(angleArray[i]);
    }
  }
}
