class Screen {
  ArrayList<Widget> widgetList;                  //array list of widgets on each screen
  boolean active = false;                        //true = this is the current screen                  
  
  Screen() {
    widgetList = new ArrayList<Widget>();
  }
  
  
  void draw() {
    if(active) {
      for(Widget w : widgetList) {                //draw each widget when this screen is active
        w.draw();
      }
    }
  }
                                                  //add a non-button widget
  void addWidgetA(int x, int y, int w, int h, String label, color wColor, PFont wFont) {
    widgetList.add(new Widget(x, y, w, h, label, wColor, wFont));    
  }
                                                  //add a button to the array list
  void addWidgetB(int x, int y, int w, int h, String label, color wColor, PFont wFont, int wEvent) {
    widgetList.add(new Widget(x, y, w, h, label, wColor, wFont, wEvent));    
  }
                                                  //when mouse is pressed, find which widget is pressed based on mouse position
  int getEvent(int mX, int mY) {
    for(Widget w : widgetList) {
      if(mX>w.x && mX < w.x+w.width && mY >w.y && mY <w.y+w.height) {
        return w.event;
      }
    }
    return 0;
  }
}
