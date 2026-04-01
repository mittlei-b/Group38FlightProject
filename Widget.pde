class Widget {
  int x, y, theWidth, theHeight;                      //rect() arguments
  String label; int event;                      //label of widget, int value returned when widget pressed
  PImage icon;
  color widgetColor, labelColor;
  PFont widgetFont;
  boolean button;
  boolean isIcon;
  
  Widget(int x,int y, int theWidth, int theHeight, String label,     // constructor for a button
  color widgetColor, PFont widgetFont, int event){
    this.x=x; this.y=y; this.theWidth = theWidth; this.theHeight= theHeight;
    this.label=label; this.event=event;
    this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor= color(0);
    button = true;
    isIcon = false;
  }
  Widget(int x, int y, int theWidth, int theHeight, String text,     // constructor for a non-pressable widget
  color widgetColor, PFont widgetFont){
    this.x=x; this.y=y; this.theWidth=theWidth; this.theHeight=theHeight;
    this.label=text; this.widgetColor=widgetColor; this.widgetFont=widgetFont;
    labelColor=color(0);
    button = false;
    isIcon = false;
  }
  Widget(int x, int y, int theWidth, int theHeight, PImage icon, int event) {  // constructor for button with image instead of text 
    this.x=x; this.y=y; this.theWidth=theWidth; this.theHeight=theHeight;
    this.icon=icon; this.event=event;
    button = true;
    isIcon = true;
  }
  
  void draw(){                                 //if mouse is hovering widget, white outline       
    if(mouseX>x && mouseX < x+theWidth && mouseY >y && mouseY <y+theHeight && button && !isIcon) stroke(255);
    else stroke(0);
    if(!button) noStroke();
    if(isIcon) image(icon, x, y, theWidth, theHeight);
    else {
      fill(widgetColor);
      rect(x,y,theWidth,theHeight);
      fill(labelColor);
      textFont(widgetFont);
      text(label, x+10, y+theHeight-10 );
    }
  }
    
}
