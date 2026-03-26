import java.util.Scanner;
import java.util.Arrays;
import java.io.*;


/**********
    DESIGN VARIABLES
  ***********/
String font = "ArialMT-18.vlw";
PFont loadedFont;
PFont welcomeFont;
PImage welcomeBackground;
PImage homeIcon;
int SCREEN_HEIGHT = 600;
int SCREEN_WIDTH = 600;

/**********
    SCREEN VARIABLES
  ***********/
Screen welcome = new Screen();
// initialising screens here because i get a null pointer exception later otherwise??
Screen home = new Screen();
Screen results = new Screen();
int currentEvent;

/**********
    INPUT VARIABLES
  ***********/
ArrayList<Input> inputs;
ArrayList<Dropdown> dropdowns;

/**********
    DATA VARIABLES
  ***********/
Data data;

ArrayList<Flight> flights;
int totalNumbOfFlights; // Total number of flights, used for comparison
int numbOfSelectedFlights; // Number of flights, now that data has been narrowed down based on a specific parameter





void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  /********** DESIGN
      All variables to do with design go first (font, colors, styling, etc.)
      Anything DRAWN (that needs setup) goes AFTER input boxes and data table.
  ***********/

  welcomeBackground = loadImage("skyBG.jpg");
  homeIcon = loadImage("Home_Icon.PNG");
  welcomeBackground.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  loadedFont = loadFont(font);
  textFont(loadedFont);
  welcomeFont = createFont("Arial", 40);
  background(255);
  fill(0);
  
  /********** INPUT BOXES
      To add new input boxes, copy the format in the comment below
      and paste it at the end of the other addNewInput() lines.
      ISDROPDOWN refers to whether the input is also a dropdown.
      addNewInput(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY, ISDROPDOWN)
  ***********/
  inputs = new ArrayList<Input>();
  newInput("Flight Number", 50, 120, 100, 25, "Flight No.", false);
  newInput("Departure State", 170, 120, 100, 25, "Dept. State", false);
  
  
  /********** WIDGETS
      making all widgets on each screen here + setting welcome to active so 
      it shows when program starts
  **********/
  welcome.active = true;
  
  welcome.addWidgetA(200, 200, 200, 50, "Welcome", color(180, 200, 255), welcomeFont);
  welcome.addWidgetB(220, 300, 160, 30, "Start searching", color(180, 200, 255), loadedFont, 1);
  home.addWidgetC(20, 540, 40, 40, homeIcon, 1);
  home.addWidgetA(60, 60, 100, 40, "Search...", color(150,150,250), loadedFont);
  
  
  /********** DATA TABLE
      Here is our data class. We're using the Processing class called Table:
      https://processing.org/reference/Table.html
  ***********/
  data = new Data("flights_full.csv");
  Table flightsTable = loadTable("flights_full.csv", "header");
  flights = new ArrayList<Flight>();
  for (TableRow row : flightsTable.rows()) {
    flights.add(new Flight(row.getString("FL_DATE"),
      row.getString("MKT_CARRIER"), row.getInt("MKT_CARRIER_FL_NUM"),
      row.getString("ORIGIN"), row.getString("ORIGIN_CITY_NAME"),
      row.getString("ORIGIN_STATE_ABR"), row.getInt("ORIGIN_WAC"),
      row.getString("DEST"), row.getString("DEST_CITY_NAME"),
      row.getString("DEST_STATE_ABR"), row.getInt("DEST_WAC"),
      row.getInt("CRS_DEP_TIME"), row.getInt("DEP_TIME"),
      row.getInt("CRS_ARR_TIME"), row.getInt("ARR_TIME"),
      row.getFloat("DISTANCE"), row.getInt("DIVERTED"),
      row.getInt("CANCELLED"))); // Creating another object of type flight and putting in the attributes taken directly from the csv file
    totalNumbOfFlights++; // Tallying up total number of flights for later comparison
  }
  
  /********** 
      SCREENS
  ***********/

  welcomeBackground = loadImage("skyBG.jpg");
  welcomeBackground.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  loadedFont = loadFont(font);
  textFont(loadedFont);
  welcomeFont = createFont("Arial", 40);
  background(255);
  fill(0);
  
  /********** INPUT / DROPDOWN BOXES
      To add new input / dropdown boxes, copy the correct format from below
      newInput(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY)
      newDropdown(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY, OPTION LIST)
  ***********/
  inputs = new ArrayList<Input>();
  dropdowns = new ArrayList<Dropdown>();
  //newInput("Flight Number", 200, 100, 100, 25, "123456");
  ArrayList<String> carrierNames = new ArrayList<String>();
  for (String code : data.carrierCodes(flights)) {
    String name = data.carrierCodeToName(code);
    carrierNames.add(name);
  }
  newDropdown("Airline", 200, 100, 300, 25, "Airline", carrierNames);
  
  
  /********** WIDGETS
      making all widgets on each screen here + setting welcome to active so 
      it shows when program starts
  **********/
  welcome.active = true;
  
  welcome.addWidgetA(200, 200, 200, 50, "Welcome", color(180, 200, 255), welcomeFont);
  welcome.addWidgetB(220, 300, 160, 30, "Start searching", color(180, 200, 255), loadedFont, 1);
  home.addWidgetB(20, 540, 40, 40, "home", color(180), loadedFont, 1);
  home.addWidgetA(60, 60, 100, 40, "Search...", color(150,150,250), loadedFont);
  
  
  
  
  
  /*
  
  // Sample application of this framework
  // Let's say this user wants only flights from Arizona
  String depState = "AZ"; // This is just hardcoded into the program here but it would be decided based on a scanner or sum
  
  
  ArrayList<String> stateCodes = new ArrayList<String>();
  ArrayList<Integer> numbFlightsTXtoX = new ArrayList<Integer>(); // BRYNNE TEMPORARY ADDITION
  
  
  ArrayList<Flight> flightSubList = new ArrayList<Flight>();
  for (Flight f : flights) {
    if ((f.origStateAbr).equals(depState)) {
      flightSubList.add(f);
      numbOfSelectedFlights++; // Tallying up the number of flights from Texas
    }
  }

  println("Total number of flights: " + totalNumbOfFlights);
  println("Number of selected flights: "+numbOfSelectedFlights);
  
  int flightsToTexas = numbFlightsFromHereToThere("TX", flightSubList);
  
  for (String s : stateCodes){
    int flightsToHere = numbFlightsFromHereToThere(s, flightSubList);
    numbFlightsTXtoX.add(flightsToHere);
    println(flightsToHere + " flights were made from Texas to " + s + ".");
  }
  
  println("Total flights from Arizona to Texas: " + flightsToTexas);

  float percentDiverted = getPercentage("DIVERTED", flightSubList);
  float pDivertedRounded = (float(round(percentDiverted*100)))/100;
  
  double meanDistance = getMean("DISTANCE", flightSubList);
  float meanDistRounded = float(round((float)(meanDistance*100)))/100;

  println("Mean distance of selected flights in km: " + meanDistRounded);
  println("Percentage of selected flights that were diverted: " + pDivertedRounded + "%");

  **/
}

void draw() {
  /*if(welcome.active) background(welcomeBackground);
  else background(255);**/
  // Testing inputs
  image(welcomeBackground,0,0);
  
  if(home.active) drawInputsAndDropdowns();
    
  welcome.draw();
  home.draw();
  results.draw();
  
  
  /********** Background Color
              and Input Boxes at the top
  ***********/
  if(welcome.active) background(welcomeBackground);
  else background(255);
  
  if(home.active) drawInputs();
  
  
  /**********
      Rest of code goes here.
  ***********/
  
  welcome.draw();
  home.draw();
  results.draw();

  fill(0);
  
  /********** Frame Counter
      Keep at bottom of draw so nothing gets drawn over it.
  ***********/
  stroke(0);
  frameCounter();
}

/********** INPUT / DROPDOWN FUNCTIONS
    Main functions needed to make input boxes work.
***********/

void newInput(String label, int x_position, int y_position, int width, int height, String standIn) {
  Input box = new Input(label, x_position, y_position, width, height, standIn);
  inputs.add(box);
}

void newDropdown(String label, int x_position, int y_position, int width, int height, String standIn, ArrayList<String> list) {
  Dropdown box = new Dropdown(label, x_position, y_position, width, height, standIn, list);
  dropdowns.add(box);
}

void drawInputsAndDropdowns() {
  for (Input box : inputs) {
    box.draw();
  }
  for (Dropdown box : dropdowns) {
    box.draw();
  }
}

void mousePressed() {
  // Check if an input was selected and update if so
  for (Input box : inputs) {
    box.checkIfClicked();
    box.updateState();
  }
  for (Dropdown box : dropdowns) {
    box.checkIfClicked();
  }
  
  if(welcome.active) {
    currentEvent = welcome.getEvent(mouseX, mouseY);
    if(currentEvent == 1){
      welcome.active = false;
      home.active = true;
    }
  }
  if(home.active) {
    currentEvent = home.getEvent(mouseX, mouseY);
    if(currentEvent == 1) {
      home.active = false;
      welcome.active = true;
    }
  }
}

void mouseWheel(MouseEvent event) {
  int direction = (int)event.getCount();
  for (Dropdown box : dropdowns) {
    box.checkIfScrolled(direction);
  }
}


void keyPressed() {
  // If input entered, print it in its input box
  for (Input box : inputs) {
    box.updateInput(key);
  }
  for (Dropdown box : dropdowns) {
    box.updateInput(key);
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
