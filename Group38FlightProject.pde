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
int SCREEN_HEIGHT = 600;
int SCREEN_WIDTH = 600;

/**********
    SCREEN VARIABLES
  ***********/
Screen welcome = new Screen(); // initialising screens here because i get a null pointer exception later otherwise??
Screen home = new Screen();
Screen results = new Screen();
int currentEvent;

/**********
    INPUT VARIABLES
  ***********/
ArrayList<Input> inputs;

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
  newInput("Flight Number", 200, 380, 100, 25, "123456", false);
  
  
  /********** WIDGETS
      making all widgets on each screen here + setting welcome to active so 
      it shows when program starts
  **********/
  welcome.active = true;
  
  welcome.addWidgetA(200, 200, 200, 50, "Welcome", color(180, 200, 255), welcomeFont);
  welcome.addWidgetB(220, 300, 160, 30, "Start searching", color(180, 200, 255), loadedFont, 1);
  home.addWidgetB(20, 540, 40, 40, "home", color(180), loadedFont, 1);
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
  
  /*
  
  // Sample application of this framework
  // Let's say this user wants only flights from Arizona
  String depState = "AZ"; // This is just hardcoded into the program here but it would be decided based on a scanner or sum
  
  
  ArrayList<String> stateCodes = new ArrayList<String>();
  ArrayList<Integer> numbFlightsTXtoX = new ArrayList<Integer>(); // BRYNNE TEMPORARY ADDITION
  
  for (Flight f : flights){ //Creates an ArrayList of all state abbreviations that exist
    String stateCode = f.origStateAbr;
    boolean recordedAlready = false;
    for (String s : stateCodes){
      if (s.equals(stateCode)) recordedAlready = true;
    }
    if (!recordedAlready) stateCodes.add(stateCode);
  }
  
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

  /**********
      Rest of code goes here
  ***********/
}

void draw() {
  /********** Background Color
              and Input Boxes at the top
  ***********/
 // if(welcome.active) background(welcomeBackground);
 // else background(255);
  
  if(home.active) drawInputs();
    
  welcome.draw();
  home.draw();
  results.draw();
  
  
  
  /**********
      Rest of code goes here.
  ***********/
  fill(0);
  
  /********** Frame Counter
      Keep at bottom of draw so nothing gets drawn over it.
  ***********/
  stroke(0);
  frameCounter();
}

public int numbFlightsFromHereToThere(String dest, ArrayList<Flight> sublist){
  int flightsWithThisDest = 0;
  for (Flight f : sublist){
    if (f.destStateAbr.equals(dest)) flightsWithThisDest++;
  }
  return flightsWithThisDest;
}

public double getMean(String column, ArrayList<Flight> subset) {
  switch (column) {
  case "DISTANCE":
    double totalFlightKms = 0;
    double totalFlightsThisType = 0;
    for (Flight f : subset) {
      totalFlightsThisType++;
      totalFlightKms += f.distance;
    }
    double meanDistance = totalFlightKms/totalFlightsThisType;
    return meanDistance;
  default :
    println("Something's gone wrong brother");
    return 0;
  }
}

public float getPercentage(String column, ArrayList<Flight> subset) {
  int totalFlightsThisType = 0;

  switch (column) {
  case "CANCELLED":
    int cancelledFlights = 0;
    float totalFlights;
    for (Flight f : subset) {
      totalFlightsThisType++;
      if (f.cancelled) cancelledFlights++;
    }
    float cancelled = (float)cancelledFlights;
    totalFlights = (float)totalFlightsThisType;

    float percentCancelled = cancelled/totalFlights * 100;
    return percentCancelled;

  case "DIVERTED":
    int divertedFlights = 0;
    for (Flight f : subset) {
      totalFlightsThisType++;
      if (f.diverted) divertedFlights++;
    }
    float diverted = (float)divertedFlights;
    totalFlights = (float)totalFlightsThisType;

    float percentDiverted = diverted/totalFlights * 100;
    return percentDiverted;

  default:
    println("something's gone wrong brother");
    return 0;
  }
}

/********** INPUT FUNCTIONS
    Main functions needed to make input boxes work.
***********/

void newInput(String label, int x_position, int y_position, int width, int height, String standIn, boolean isDropdown) {
  Input box = new Input(label, x_position, y_position, width, height, standIn, isDropdown);
  inputs.add(box);
}

void drawInputs() {
  for (Input box : inputs) {
    box.draw();
  }
}

void mousePressed() {
  // Check if an input was selected and update if so
  for (Input box : inputs) {
    box.checkIfClicked();
    box.updateState();
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


void keyPressed() {
  // If input entered, print it in its input box
  for (Input box : inputs) {
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
