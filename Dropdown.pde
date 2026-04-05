public class Dropdown extends Input {
  ArrayList<DropdownItem> itemList;
  ArrayList<String> wordList;
  ArrayList<String> chosenWordsList;
  PGraphics container;
  boolean showDropdown;
  int listHeight = 120;
  int offsetY = 0;
  
  public Dropdown(String label, int x_position, int y_position, int theWidth, int theHeight, String standIn, ArrayList<String> list) {
    super(label, x_position, y_position, theWidth, theHeight, standIn);
    itemList = new ArrayList<DropdownItem>();
    wordList = list;
    chosenWordsList = new ArrayList<String>();
    int movingY = 0;
    container = createGraphics(theWidth, listHeight);
    for (String item : wordList) {
      DropdownItem itemBox = new DropdownItem(item, 0, movingY, theWidth, theHeight);
      itemList.add(itemBox);
      movingY += theHeight;
    }
    showDropdown = false;
  }
  
  public void draw() {
    box.beginDraw();
    box.textAlign(LEFT, TOP);
    box.background(255);
    box.fill(fontColor);
    box.textSize(18);
    box.text(content, 5 + offsetX, 5);
    box.fill(0,0,0,0);
    box.stroke(border);
    box.strokeWeight(2);
    box.rect(0,0,theWidth,theHeight - 1);
    box.endDraw();
    image(box,x,y);
   
    if (selected) {
      container.beginDraw();
      for (DropdownItem item : itemList) {
        container.image(item.drawnBox(), item.getX(), item.getY() - offsetY);
      }
      container.fill(0,0,0,0);
      container.stroke(150);
      container.strokeWeight(2);
      container.rect(0,0,theWidth - 1,listHeight - 1);
      container.endDraw();
      image(container,x,y + theHeight);
    }
  }
  
  public void confirmInput() {
    boolean goodInput = false;
    for (String word : wordList) {
      if (userInput.equalsIgnoreCase(word)) goodInput = true;
    }
    for (String word : chosenWordsList) {
      if (userInput.equalsIgnoreCase(word)) goodInput = false;
    }
    if (goodInput) {
      for (int index = 0; index < itemList.size(); index++) {
        DropdownItem option = itemList.get(index);
        String optionName = option.getOption();
        if (optionName.equalsIgnoreCase(userInput)) {
          chosenWordsList.add(optionName);
          option.updateState();
        }
      }
      entered = true;
    }
    userInput = "";
  }
  
  public void checkEnterPressed(char letter) {
    if (letter == ENTER || letter == RETURN) {
      if (content == "") entered = false;
      deselect();
    } else if (letter == ',') {
      userInput = userInput.substring(0,userInput.length() - 1);
      confirmInput();
      addInput();
    } else {
      addInput();
    }
  }
  
  public void deselect() {
    confirmInput();
    selected = false;
    border = color(0);
    offsetX = 0;
    if (!entered) {
      fontColor = color(200);
      content = defaultText;
    } else {
      fontColor = color(0);
      content = getOptionString();
    }
  }
  
  public String getOptionString() {
    if (chosenWordsList.size() > 0) {
      String optionString = chosenWordsList.toString();
      return optionString.substring(1,optionString.length() - 1);
    } else return "";
  }
  
  public void addInput() {
    String chosenOptions = getOptionString();
    if (chosenOptions.equals("")) content = userInput;
    else content = getOptionString() + ", " + userInput;
    offset();
  }
  
  public void deleteOnEmpty() {
    int listSize = chosenWordsList.size();
    if (listSize > 0) {
      String lastItem = chosenWordsList.get(listSize - 1);
      userInput = lastItem;
      chosenWordsList.remove(lastItem);
      addInput();
      for (int index = 0; index < itemList.size(); index++) {
        DropdownItem option = itemList.get(index);
        if (option.getOption().equals(lastItem)) option.updateState();
      }
      
    }
    if (chosenWordsList.size() == 0) entered = false; else addInput();
  }
  
  public void checkIfClicked(int mouseX, int mouseY) {
    if (x <= mouseX && mouseX <= x + theWidth
        && y <= mouseY && y + theHeight >= mouseY) {
      selected = true;
      border = color(255,100,100);
      fontColor = color(0);
      addInput();
    } else if (selected && x <= mouseX && mouseX <= x + theWidth
               && y + theHeight <= mouseY && y + theHeight + listHeight >= mouseY) {
      int newMouseY = mouseY - y - theHeight + offsetY;
      int index = newMouseY / theHeight;
      DropdownItem option = itemList.get(index);
      boolean itemSelected = option.updateState();
      if (itemSelected) {
        chosenWordsList.add(option.getOption());
        entered = true;
      } else {
        chosenWordsList.remove(option.getOption());
        if (chosenWordsList.size() == 0) entered = true;
      }
      confirmInput();
      addInput();
    } else {
      offsetY = 0;
      deselect();
    }
  }
  
  public void checkIfScrolled(int direction) {
    if (x <= mouseX && mouseX <= x + theWidth
        && y + theHeight <= mouseY && y + theHeight + listHeight >= mouseY) {
      int maxOffset = itemList.size() * theHeight - listHeight;
      if ((direction > 0 && offsetY < maxOffset) || (direction < 0 && offsetY > 0))
        offsetY += 10 * direction;
    }
  }
  
  public ArrayList<String> getSelection() {
    return chosenWordsList;
  }
}
