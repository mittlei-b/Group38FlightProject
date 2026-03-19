class Widget {
  int x, y, width, height;                      //rect() arguments
  String label; int event;                      //label of widget, int value returned when widget pressed
  color widgetColor, labelColor;
  PFont widgetFont;
  boolean button;
  Widget(int x,int y, int width, int height, String label,
  color widgetColor, PFont widgetFont, int event){
    this.x=x; this.y=y; this.width = width; this.height= height;
    this.label=label; this.event=event;
    this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor= color(0);
    button = true;
  }
  Widget(int x, int y, int width, int height, String text,
  color widgetColor, PFont widgetFont){
    this.x=x; this.y=y; this.width=width; this.height=height;
    this.label=text; this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor=color(0);
    button = false;
  }
  void draw(){                                 //if mouse is hovering widget, white outline       
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
