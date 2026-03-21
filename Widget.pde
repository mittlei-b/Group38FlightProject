class Widget {
  int x, y, width, height;                      //rect() arguments
  String label; int event;                      //label of widget, int value returned when widget pressed
  color widgetColor, labelColor;
  PFont widgetFont;
  boolean button;

  
  Widget(int x,int y, int width, int height, String label,                 //Constructor to make a button which returns an event
  color widgetColor, PFont widgetFont, int event){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.label = label;
    this.event = event;
    this.widgetColor = widgetColor;
    this.widgetFont = widgetFont;
    labelColor = color(0);
    button = true;
  }
  
  Widget(int x, int y, int width, int height, String text,                  //Constructor to display widget with no event returned when clicked
  color widgetColor, PFont widgetFont){
    this.x=x; this.y=y; this.width=width; this.height=height;
    this.label=text; this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor=color(0);
    button = false;
  }
  
  void draw(){                                 //if mouse is hovering widget, white outline (if it is pressable)
    if(mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height && button) stroke(255);
    else stroke(0);
    if(!button) noStroke();
    fill(widgetColor);
    rect(x,y,width,height);
    fill(labelColor);
    textFont(widgetFont);
    text(label, x+10, y+height-10 );
  }
}

class Chart extends Widget {
  ArrayList<String> labels;
  ArrayList<Integer> values;
  
  Chart(int x,int y, int width, int height, String label, color widgetColor, PFont widgetFont) {
    super(x,y,width,height,label,widgetColor,widgetFont);
  }
  
  void load(ArrayList<String> words, ArrayList<Integer> numbers) {
    labels = words;
    values = numbers;
  }
  
  void draw() {
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
        String label = labels.get(count);
        fill(0);
        text(label, x - label.length() - 25, movingY + 15);
        text(value, x + 5 + rectWidth, movingY + 15);
        movingY += 30;
      }
    }
  }
  
}
