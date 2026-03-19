import java.util.Scanner;
import java.util.Arrays;
import java.io.*;


/**********
    DESIGN VARIABLES
  ***********/
String font = "ArialMT-18.vlw";
PFont myFont;
PImage welcomeBackground;
int SCREEN_HEIGHT = 600;
int SCREEN_WIDTH = 600;

/**********
    SCREEN VARIABLES
  ***********/
Screen welcome;
Screen home;
Screen results;

/**********
    INPUT VARIABLES
  ***********/
ArrayList<Input> inputs;
ArrayList<InputText> inputTexts;
Overlay textErase;

/**********
    DATA VARIABLES
  ***********/
Data data;

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  /********** DESIGN
      All variables to do with design go first (font, colors, styling, etc.)
      Anything DRAWN (that needs setup) goes AFTER input boxes and data table.
  ***********/
  PFont loadedFont = loadFont(font);
  textFont(loadedFont);
  background(255);
  fill(0);
  
  /********** INPUT BOXES
      All input boxes go on top!!!!!
      To add new input boxes, copy the format in the comment below
      and paste it at the end of the other addNewInput() lines.
      addNewInput(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY)
  ***********/
  inputs = new ArrayList<Input>();
  inputTexts = new ArrayList<InputText>();
  addNewInput("Flight Number", 120, 120, 100, 25, "123456", false);
  // Next input box could go here.
  textErase = new Overlay(inputs, color(255));
  
  /********** DATA TABLE
      Here is our data class. We're using the Processing class called Table:
      https://processing.org/reference/Table.html
  ***********/
  data = new Data("flights_full.csv");
  
  /**********
      Rest of code goes here
  ***********/
}

void draw() {
  /********** Background Color
              and Input Boxes at the top
  ***********/
  background(255);
  drawInputs();
  
  /**********
      Rest of code goes here.
  ***********/
  
  /********** Frame Counter
      Keep at bottom of draw so nothing gets drawn over it.
  ***********/
  frameCounter();
}

/********** INPUT FUNCTIONS
    Main functions needed to make input boxes work.
***********/

void addNewInput(String label, int x_position, int y_position, int width, int height, String standIn, boolean isDropdown) {
  Input box = new Input(label, x_position, y_position, width, height, isDropdown);
  inputs.add(box);
  InputText boxText = new InputText(label, standIn, box);
  inputTexts.add(boxText);
}

void drawInputs() {
  for (Input box : inputs) {
    box.draw();
  }
  for (InputText text : inputTexts) {
    text.draw();
  }
  textErase.draw();
}

void mousePressed() {
  // Check if an input was selected
  for (Input box : inputs) {
    box.checkIfClicked();
  }
  // Check (and update) if any inputs need it
  for (InputText text : inputTexts) {
    text.updateState();
  }
}

void keyPressed() {
  // If input entered, print it in its input box
  for (InputText text : inputTexts) {
    text.updateInput(key);
  }
}

/********** 
    FRAME COUNTER
***********/

void frameCounter() {
  fill(255);
  rect(15, 5, 30, 10);
  float fps = frameRate;
  int framesPerSecond = round(fps);
  fill(0);
  text(" " + framesPerSecond, 5, 10);
}
