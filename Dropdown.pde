/*  Class to create a Dropdown version of the Input class,
    where the user can selected from a list of DropdownItems
    or type in an input selection that is equal to an item 
    in the DropdownItem list.
**/
public class Dropdown extends Input {
  ArrayList<DropdownItem> itemList;
  ArrayList<String> wordList;
  ArrayList<String> chosenWordsList;
  PGraphics container;
  boolean showDropdown;
  int listHeight = 120;
  int offsetY = 0;
  boolean takesInput;
  
  public Dropdown(String label, int x_position, int y_position, int theWidth, int theHeight, String standIn, ArrayList<String> list, boolean takesInput) {
    super(label, x_position, y_position, theWidth, theHeight, standIn, false);
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
    this.takesInput = takesInput;
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
  
  // A function that typically runs when the user presses enter
  // while the dropdown is in focus (aka selected). The function
  // determines whether the input matches an option in the dropdown
  // or if it is faulty input. The input is confirmed in the former
  // and erased in the latter.
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
  
  // A function that lets the dropdown widget know when the
  // ENTER key or the COMMA key are pressed (both serve the
  // same function of entering input)
  public void checkEnterPressed(char letter) {
    if (takesInput) {
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
  }
  
  // A function to take the widget out of focus (unselected)
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
  
  // A function to get the String value of a dropdown option
  public String getOptionString() {
    if (chosenWordsList.size() > 0) {
      String optionString = chosenWordsList.toString();
      return optionString.substring(1,optionString.length() - 1);
    } else return "";
  }
  
  // A function to add the new input to the printed selection
  public void addInput() {
    String chosenOptions = getOptionString();
    if (chosenOptions.equals("")) content = userInput;
    else content = getOptionString() + ", " + userInput;
    offset();
  }
  
  // A function to delete the last selected choice if the
  // user is pressing delete and no new input is available
  // to erase
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
  
  // A function to let the program know if it is clicked and where (and why)
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
  
  // A function to check if the dropdown options where scrolled
  public void checkIfScrolled(int direction) {
    if (x <= mouseX && mouseX <= x + theWidth
        && y + theHeight <= mouseY && y + theHeight + listHeight >= mouseY) {
      int maxOffset = itemList.size() * theHeight - listHeight;
      if ((direction > 0 && offsetY < maxOffset) || (direction < 0 && offsetY > 0))
        offsetY += 5 * direction;
    }
  }
  
  // A function that returns an ArrayList<String> of the chosen option selection
  public ArrayList<String> getSelection() {
    return chosenWordsList;
  }
}
