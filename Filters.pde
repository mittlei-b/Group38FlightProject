class filter {
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
  int[][] dateArray = {{0, 0, 0, 0, 0, 0, 1},
                       {2, 3, 4, 5, 6, 7, 8},
                       {9, 10, 11, 12, 13, 14, 15},
                       {16, 17, 18, 19, 20, 21, 22},
                       {23, 24, 25, 26, 27, 28, 29},
                       {30, 31, 0, 0, 0, 0, 0}};
  
  filter(String type, String status, int xMargin, int xpos, int ypos, int size, color circleColour, color rectColour, int number, int rectWidth, int rectHeight) {
    this.type = type;
    this.status = status;
    this.xMargin = xMargin;
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
  
  filter(String type, int xpos, int ypos, int calendarWidth, int calendarHeight, PImage calendarImg) {
    this.type = type;
    this.xpos = xpos;
    this.ypos = ypos;
    this.calendarWidth = calendarWidth;
    this.calendarHeight = calendarHeight;
    this.calendarImg = calendarImg;
  }
  
  filter(String type, int xpos, int ypos, int size, PImage untickedImg, PImage tickedImg) {
    this.type = type;
    this.xpos = xpos;
    this.ypos = ypos;
    this.size = size;
    this.untickedImg = untickedImg;
    this.tickedImg = tickedImg;
  }
  
  String type() {
    return type;
  }
  
  boolean isTicked() {
    return ticked;
  }

  void click() {
    if (type.equals("slider"))
    {
      dragged = true;
    }
    else if (type.equals("calendar"))
    {
      if (mouseX > xpos && mouseX < xpos + calendarWidth &&
          mouseY > ypos + (calendarHeight / 3.5) && mouseY < ypos + calendarHeight)
      {
        dateX();
        dateY();
        actualDate();
      }
    }
    else if (type.equals("tickbox"))
    {
      if (mouseX > xpos && mouseX < xpos + size &&
          mouseY > ypos && mouseY < ypos + size)
      {
        ticked = !ticked;
      }
    }
  }
  
  void release() {
    if (type.equals("slider"))
    {
      dragged = false;
    }
  }
  
  boolean dragged() {
    return dragged;
  }
  
  int getNumber() {
    int num = -1;
    if (type.equals("slider"))
    {
      if (status.equals("start"))
      {
        int distance = xpos - rectX;
        int step = rectWidth / 24;
        num = round(distance / step);
        
        if (num > 24) {
          num = 24;
        }
      }
      else
      {
        int distance = xpos - (rectX - rectWidth);
        int step = rectWidth / 24;
        num = round(distance / step);
        
        if (num > 24) {
          num = 24;
        }
      }
      
      return num;
    }
    return -1;
  }
  
  int getDate() {
    if (type.equals("calendar"))
    {
       return date;
    }
    return 0;
  }
  
  void actualDate() {
    if (type.equals("calendar"))
    {
       date = dateArray[numX][numY];
       println(date);
    }
  }
  
  void dateX() {
    int mousePos = mouseY;
    int distance = mousePos - (ypos + (int)(calendarHeight / 3.25));
    int step = (int)((calendarHeight - ((calendarHeight / 3.25))) / 6);
    numX = round(distance / step);
  }
    
  void dateY() {
    int mousePos = mouseX;
    int distance = mousePos - xpos;
    int step = calendarWidth / 7;
    numY = round(distance / step);
  }

  void move(int mouseXpos, int otherNumber, int otherXpos) {
    if (type.equals("slider"))
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
  
  void drawRect() {
    int rectYpos = ypos - (size / 4);
    fill(rectColour);
    rect(rectX, rectYpos, rectWidth, rectHeight);
  }
  
  void draw() {
    if (type.equals("slider"))
    {
      fill(circleColour);
      circle(xpos, ypos, size);
    }
    else if (type.equals("calendar"))
    {
      image(calendarImg, xpos, ypos, calendarWidth, calendarHeight);
    }
    else if (type.equals("tickbox"))
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
