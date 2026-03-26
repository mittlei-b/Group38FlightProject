class Widget {
  int x, y, width, height;                      //rect() arguments
  String label; int event;                      //label of widget, int value returned when widget pressed
  PImage icon;
  color widgetColor, labelColor;
  PFont widgetFont;
  boolean button;
  boolean isIcon;
  
  Widget(int x,int y, int width, int height, String label,     // constructor for a button
  color widgetColor, PFont widgetFont, int event){
    this.x=x; this.y=y; this.width = width; this.height= height;
    this.label=label; this.event=event;
    this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor= color(0);
    button = true;
    isIcon = false;
  }
  Widget(int x, int y, int width, int height, String text,     // constructor for a non-pressable widget
  color widgetColor, PFont widgetFont){
    this.x=x; this.y=y; this.width=width; this.height=height;
    this.label=text; this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor=color(0);
    button = false;
    isIcon = false;
  }
  Widget(int x, int y, int width, int height, PImage icon, int event) {  // constructor for button with image instead of text 
    this.x=x; this.y=y; this.width=width; this.height=height;
    this.icon=icon; this.event=event;
    button = true;
    isIcon = true;
  }
  
  void draw(){                                 //if mouse is hovering widget, white outline       
    if(mouseX>x && mouseX < x+width && mouseY >y && mouseY <y+height && button && !isIcon) stroke(255);
    else stroke(0);
    if(!button) noStroke();
    if(isIcon) image(icon, x, y, width, height);
    else {
      fill(widgetColor);
      rect(x,y,width,height);
      fill(labelColor);
      textFont(widgetFont);
      text(label, x+10, y+height-10 );
    }
  }
    
}
