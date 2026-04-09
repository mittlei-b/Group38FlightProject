class filter {
  // initialising all of the variables the filters will need
  String type, status;
  int xpos, ypos;
  int xMargin;
  int rectWidth, rectHeight, rectX;
  int size, calendarWidth, calendarHeight;
  int number;
  int numX, numY;
  int date = 0;
  PImage untickedImg, tickedImg, calendarImg;
  boolean ticked = false;
  boolean dragged = false;
  color circleColour, rectColour;
  
  // array of dates that correspond to the calendar squares
  int[][] dateArray = {{0, 0, 0, 0, 0, 0, 1},
                       {2, 3, 4, 5, 6, 7, 8},
                       {9, 10, 11, 12, 13, 14, 15},
                       {16, 17, 18, 19, 20, 21, 22},
                       {23, 24, 25, 26, 27, 28, 29},
                       {30, 31, 0, 0, 0, 0, 0}};
  
  // constructor for sliders
  filter(String type, String status, int xpos, int ypos, int size, color circleColour, color rectColour, int number, int rectWidth, int rectHeight) {
    this.type = type;
    this.status = status;
    this.xMargin = xpos;
    this.xpos = xpos;
    this.ypos = ypos;
    rectX = xpos;
    this.size = size;
    this.circleColour = circleColour;
    this.rectColour = rectColour;
    this.number = number;
    this.rectWidth = rectWidth;
    this.rectHeight = rectHeight;
  }
  
  // constructor for the calendar
  filter(String type, int xpos, int ypos, int calendarWidth, int calendarHeight, PImage calendarImg) {
    this.type = type;
    this.xpos = xpos;
    this.ypos = ypos;
    this.calendarWidth = calendarWidth;
    this.calendarHeight = calendarHeight;
    this.calendarImg = calendarImg;
  }
  
  // constructor for the late and cancelled tickboxes
  filter(String type, int xpos, int ypos, int size, PImage untickedImg, PImage tickedImg) {
    this.type = type;
    this.xpos = xpos;
    this.ypos = ypos;
    this.size = size;
    this.untickedImg = untickedImg;
    this.tickedImg = tickedImg;
  }
 
 // returns the type of filter (slider, calendar, tickbox)
  String type() {
    return type;
  }
 
  // returns whether or not the checkbox is ticked for data filtration
  boolean isTicked() {
    return ticked;
  }

  // called when the user clicks the mouse
  void click() {
    
    // if the mouse clicks a slider, dragged is set to true
    if (type.equals("slider"))
    {
      dragged = true;
    }
    
    // if the mouse clicks inside the calendar image calendar, the actualDate function changes the date variable to the one the user clicked on
    else if (type.equals("calendar"))
    {
      if (mouseX > xpos && mouseX < xpos + calendarWidth &&
          mouseY > ypos + (calendarHeight / 3.5) && mouseY < ypos + calendarHeight)
      {
        actualDate();
      }
    }
    
    // if the mouse clicks on a tickbox, the boolean ticked is inverted
    else if (type.equals("tickbox"))
    {
      if (mouseX > xpos && mouseX < xpos + size &&
          mouseY > ypos && mouseY < ypos + size)
      {
        ticked = !ticked;
      }
    }
  }
  
  // when the user releases the mouse, dragged is set to false
  void release() {
    if (type.equals("slider"))
    {
      dragged = false;
    }
  }
  
  // returns whether or not the user is dragging the mouse on the slider
  boolean dragged() {
    return dragged;
  }
  
  // divides the slider into sections and returns the section (time) the slider circle is currently on from 0 to 24
  int getNumber() {
    int num = -1;
    if (type.equals("slider"))
    {
      if (status.equals("start"))  // if the dragged circle is the start time of the time range
      {
        int distance = xpos - rectX;
        float step = rectWidth / 24.0;
        num = (int)(distance / step);
        
        if (num > 24) {
          num = 24;
        }
      }
      else  // if the dragged circle is the end time of the time range
      {
        int distance = xpos - (rectX - rectWidth);
        float step = rectWidth / 24.0;
        num = (int)(distance / step);
        
        if (num > 24) {
          num = 24;
        }
      }
      
      return num;
    }
    return -1;
  }
  
  
  // returns the most recent date the user clicked on
  int getDate() {
    if (type.equals("calendar"))
    {
       return date;
    }
    return 0;
  }
  
  // uses the dateArray to calculate the date the user clicked on
  void actualDate() {
    if (type.equals("calendar"))
    {
       dateX();
       dateY();
       if (numX <= 6 && numY <= 6) date = dateArray[numX][numY];
    }
  }
  
  // calculates which row of the calendar the user clicked on
  void dateX() {
    int mousePos = mouseY;
    int distance = mousePos - (ypos + (int)(calendarHeight / 3.25));
    int step = (int)((calendarHeight - ((calendarHeight / 3.25))) / 6);
    numX = round(distance / step);
  }
    
  // calculates which column of the calendar the user clicked on
  void dateY() {
    int mousePos = mouseX;
    int distance = mousePos - xpos;
    int step = calendarWidth / 7;
    numY = round(distance / step);
  }


  void move(int mouseXpos, int otherNumber, int otherXpos) {
    if (type.equals("slider"))  // the slider circles get moved from position to position on the slider
    {
      int distance = rectWidth / 24;
      int number = (mouseXpos - xMargin) / distance;
      
      xpos = xMargin + (distance * number);
      
      if (status.equals("start"))
      {
        if (xpos > rectX + rectWidth)
        {
          xpos = rectX + rectWidth;
        }
        else if (xpos < rectX)
        {
          xpos = rectX;
        }
        
        if (number > otherNumber)
        {
          number = otherNumber;
        }
        
        if (xpos > otherXpos)
        {
          xpos = otherXpos;
        }
      }
      else 
      {
        if (xpos > rectX)
        {
          xpos = rectX;
        }
        else if (xpos < rectX - rectWidth)
        {
          xpos = rectX - rectWidth;
        }
        
        if (number < otherNumber)
        {
          number = otherNumber;
        }
        
        if (xpos < otherXpos)
        {
          xpos = otherXpos;
        }
      }
    }
  }
  
  // draws the rectangle for the slider circles to slide along
  void drawRect() {
    int rectYpos = ypos - (size / 4);
    fill(rectColour);
    rect(rectX, rectYpos, rectWidth, rectHeight);
  }
  
  void draw() {
    if (type.equals("slider"))  // the slider circles are drawn
    {
      fill(circleColour);
      circle(xpos, ypos, size);
    }
    else if (type.equals("calendar"))  // the calendar is drawn
    {
      image(calendarImg, xpos, ypos, calendarWidth, calendarHeight);
    }
    else if (type.equals("tickbox"))  // the tickbox is drawn using the picture corresponds to the value of the boolean ticked
    {
      if (ticked)
      {
        image(tickedImg, xpos, ypos, size, size);
      }
      else
      {
        image(untickedImg, xpos, ypos, size, size);
      }
    }
  }
}
