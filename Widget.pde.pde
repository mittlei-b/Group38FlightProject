class Widget {
  int x, y, width, height;                      //rect() arguments
  String label; int event;                      //label of widget, int value returned when widget pressed
  color widgetColor, labelColor;
  PFont widgetFont;
  Widget(int x,int y, int width, int height, String label,
  color widgetColor, PFont widgetFont, int event){
    this.x=x; this.y=y; this.width = width; this.height= height;
    this.label=label; this.event=event;
    this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor= color(0);
  }
  void draw(){                                 //if mouse is hovering widget, white outline       
    if(mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height) stroke(255);
    else stroke(0);
    fill(widgetColor);
    rect(x,y,width,height);
    fill(labelColor);
    textFont(widgetFont);
    text(label, x+10, y+height-10 );
  }
}
