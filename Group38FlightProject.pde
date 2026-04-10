import java.util.Scanner;
import java.util.Arrays;
import java.io.*;
import processing.sound.*;
import java.util.Collections;
import java.util.ArrayList;
import java.util.List;
import java.util.Comparator;

/**********
 DESIGN VARIABLES
 ***********/
String font = "ArialMT-18.vlw";
String smallFont = "ArialMT-12.vlw";
PFont tableFont;
PFont loadedFont;
PFont welcomeFont;
PImage welcomeBackground;
PImage homeIcon;
PImage musicIcon;
PImage musicMuteIcon;
PImage mapIcon;
PImage searchIcon;
PImage pieChart2;
PImage barChart2;
Widget musicButton;
SoundFile music;
int SCREEN_HEIGHT = 640;
int SCREEN_WIDTH = 960;
color blue = color(120,190,240);
Plane plane;

/**********
 SCREEN VARIABLES
 ***********/

// initalising all the screens we need here
Screen welcome = new Screen();
Screen search = new Screen();
Screen results = new Screen();
Screen flightInfo = new Screen();
Screen pieCharts1 = new Screen();
Screen pieCharts2 = new Screen();
Screen barCharts1 = new Screen();
Screen barCharts2 = new Screen();
Screen map = new Screen();

int currentEvent; 
int musicEvent;

/**********
 FlightInfo Variables
 ***********/
int destinationXPos = 0;
int destinationYPos = 0;
int departureXPos = 0;
int departureYPos = 0;

String destinationState;
String departureState;

String State;
int stateXPos;
int stateYPos;

int getDestination = 0;
int getDeparture = 0;

PImage mapImg;

/**********
 INPUT VARIABLES
 ***********/
ArrayList<Input> inputs;
ArrayList<Dropdown> dropdowns;
Dropdown departure;
Dropdown arrival;
Dropdown airline;
Filter depStartSlider, depEndSlider;
Filter arrStartSlider, arrEndSlider;
Filter calendar;
Filter lateTickbox, cancelledTickbox;
PImage tickedImg, untickedImg, calendarImg;
boolean dragStart = false, dragEnd = false;
Sheet resultTable;

/**********
 DATA VARIABLES
 ***********/
Data data;

ArrayList<Flight> flights;
ArrayList<Flight> selectedFlights;
int totalNumbOfFlights; // Total number of flights, used for comparison
int numbOfSelectedFlights; // Number of flights, now that data has been narrowed down based on a specific parameter

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  tableFont = loadFont(smallFont);
  resultTable = new Sheet(40, 130, SCREEN_WIDTH - 80, 420, "Results", blue, loadedFont);
  /********** DESIGN
   All variables to do with design go first (font, colors, styling, etc.)
   Anything DRAWN (that needs setup) goes AFTER input boxes and data table.
   ***********/

  welcomeBackground = loadImage("backgroundImage.jpg");
  homeIcon = loadImage("Home_Icon.PNG");
  musicIcon = loadImage("MusicIcon.PNG");
  musicMuteIcon = loadImage("MusicMutedIcon.PNG");
  mapIcon = loadImage("MapIcon.PNG");
  untickedImg = loadImage("unticked.jpg");
  tickedImg = loadImage("ticked.jpg");
  calendarImg = loadImage("januaryCalendar.jpg");
  searchIcon = loadImage("Search-Icon.png");
  pieChart2 = loadImage("Piechart-Icon.png");
  barChart2 = loadImage("Barchart-Icon.png");
  calendarImg.resize(200, 200);
  welcomeBackground.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  loadedFont = loadFont(font);
  textFont(loadedFont);
  welcomeFont = createFont("Arial", 40);
  background(255);
  fill(0);
  
  plane = new Plane(800,60);

  music = new SoundFile(this, "data/lofiSong.mp3");
  // Music track: gingersweet by massobeats
  //Source: https://freetouse.com/music
  //Free Vlog Music Without Copyright
  music.loop();
  musicButton = new Widget(20, SCREEN_HEIGHT-60, 40, 40, musicIcon, 5);

  /********** WIDGETS
   making all widgets on each screen here + setting welcome to active so
   it shows when program starts
   **********/
  welcome.active = true;
  

  // each pressable widget has a unique (per screen) event number to determine which was pressed
  welcome.addWidgetA((SCREEN_WIDTH/2 - 100), 200, 200, 50, "Welcome", color(140, 240, 255), welcomeFont);
  welcome.addWidgetB(SCREEN_WIDTH/2 - 80, 300, 160, 30, "Start searching", color(140, 240, 255), loadedFont, 1);
  welcome.addWidgetA(SCREEN_WIDTH/2 - 185, 380, 370, 30, "By Emily Eulitz, Shane Jones, Autumn Kaiser,", color(140, 240, 255), loadedFont);
  welcome.addWidgetA(SCREEN_WIDTH/2 - 160, 410, 320, 30, "Brynne Mittleider, Lauren McGaughey", color(140, 240, 255), loadedFont);
  welcome.addWidgetA(SCREEN_WIDTH/2 - 90, 440, 180, 30, "and Ethan Ó Mórdha", color(140, 240, 255), loadedFont);

  search.addWidgetC(80, SCREEN_HEIGHT-60, 40, 40, homeIcon, 1);
  search.addWidgetA(60, 60, 150, 40, "Enter queries...", color(140, 240, 250), loadedFont);
  search.addWidgetB(780, 560, 150, 50, "Search", color(140, 240, 255), loadedFont, 2);

  results.addWidgetC(80, SCREEN_HEIGHT-60, 40, 40, homeIcon, 1);
  results.addWidgetC(140, SCREEN_HEIGHT-60, 40, 40, pieChart2, 2);
  results.addWidgetC(200, SCREEN_HEIGHT-60, 40, 40, barChart2, 3);
  results.addWidgetC(260, SCREEN_HEIGHT-60, 40, 40, searchIcon, 5);

  flightInfo.addWidgetB(100, 580, 100, 40, "Back", color(100, 180, 255), loadedFont, 2);
  mapImg = loadImage("USA.png");

  pieCharts1.addWidgetB(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-60, 80, 40, "Back", color(140, 240, 255), loadedFont, 2);

  barCharts1.addWidgetB(SCREEN_WIDTH/2-40, SCREEN_HEIGHT-60, 80, 40, "Back", color(140, 240, 255), loadedFont, 2);


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
  
  // Future list of flights within input criteria
  selectedFlights = new ArrayList<Flight>();

  // ArrayList of all carrier names
  ArrayList<String> carrierNames = new ArrayList<String>();
  for (String code : data.carrierCodes(flights)) {
    String name = data.carrierCodeToName(code);
    carrierNames.add(name);
  }

  // ArrayList of all locations
  ArrayList<String> locations = new ArrayList<String>();
  for (String code : data.stateCodes(flights)) {
    String locale = data.stateCodeToName(code);
    if (locale.equals("Unknown")) println(code);
    locations.add(locale);
  }


  /********** USER INPUT
   To add new input boxes or dropdowns, copy the format in the comment below
   newInput(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY)
   newDropdown(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY, OPTION LIST)
   ***********/
  inputs = new ArrayList<Input>();
  dropdowns = new ArrayList<Dropdown>();
  airline = newDropdown("Airline", 50, 140, 130, 25, "Airline", carrierNames);
  departure = newDropdown("Departure", 200, 140, 130, 25, "Departure", locations);
  arrival = newDropdown("Arrival", 350, 140, 130, 25, "Arrival", locations);

  calendar = new Filter("calendar", 50, 330, calendarImg.width - 20, calendarImg.height - 20, calendarImg);
  depStartSlider = new Filter("slider", "start", 520, 150, 10, 0, 200, 0, 175, 5);
  depEndSlider = new Filter("slider", "end", 695, 150, 10, 0, 200, 24, 175, 5);
  arrStartSlider = new Filter("slider", "start", 745, 150, 10, 0, 200, 0, 175, 5);
  arrEndSlider = new Filter("slider", "end", 920, 150, 10, 0, 200, 24, 175, 5);
  lateTickbox = new Filter("tickbox", 340, 330, 25, untickedImg, tickedImg);
  cancelledTickbox = new Filter("tickbox", 490, 330, 25, untickedImg, tickedImg);
  
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
  /*println("Welcome: " + welcome.active);
  println("Search: " + search.active);
  println("Results: " + results.active);
  println("Flight Info: " + flightInfo.active);
  println("Pie Charts 1: " + pieCharts1.active);
  println("Pie Charts 2: " + pieCharts2.active);
  println("Bar Charts 1: " + barCharts1.active);
  println("BAR Charts 2: " + barCharts2.active);**/

  /********** 
            Background 
   ***********/
  image(welcomeBackground, 0, 0);
  
  if(welcome.active) {
    plane.move();
    plane.drawPlane();
  }

  if (search.active) {
    textFont(loadedFont);
    drawInputsAndDropdowns();

    depStartSlider.drawRect();
    arrStartSlider.drawRect();

    calendar.draw();
    depStartSlider.draw();
    depEndSlider.draw();
    arrStartSlider.draw();
    arrEndSlider.draw();
    lateTickbox.draw();
    cancelledTickbox.draw();

    if (depStartSlider.dragged())
    {
      depStartSlider.move(mouseX, depEndSlider.getNumber(), depEndSlider.xpos);
    } else if (depEndSlider.dragged())
    {
      depEndSlider.move(mouseX, depStartSlider.getNumber(), depStartSlider.xpos);
    } else if (arrStartSlider.dragged())
    {
      arrStartSlider.move(mouseX, arrEndSlider.getNumber(), arrEndSlider.xpos);
    } else if (arrEndSlider.dragged())
    {
      arrEndSlider.move(mouseX, arrStartSlider.getNumber(), arrStartSlider.xpos);
    }

    stroke(0);
    textAlign(CENTER, CENTER);
    text("Airline:", 80, 130);
    text("Departure State:", 266, 130);
    text("Arrival State:", 401, 130);
    
    textAlign(LEFT);

    int chosenDate = calendar.getDate();
    if (chosenDate < 1)
    {
      text("Date of flight: ", 52, 317);
    } else
    {
      if (chosenDate == 1)
      {
        text("Date of flight: " + chosenDate + "st Jan", 52, 317);
      } else if (chosenDate == 2)
      {
        text("Date of flight: " + chosenDate + "nd Jan", 52, 317);
      } else if (chosenDate == 3)
      {
        text("Date of flight: " + chosenDate + "rd Jan", 52, 317);
      } else
      {
        text("Date of flight: " + chosenDate + "th Jan", 52, 317);
      }
    }

   textAlign(CENTER, CENTER);

    int chosenDepTime1 = depStartSlider.getNumber();
    int chosenDepTime2 = depEndSlider.getNumber();

    text("Departure Time: " + chosenDepTime1 + ":00-" + chosenDepTime2 + ":00", 602, 130);

    int chosenArrTime1 = arrStartSlider.getNumber();
    int chosenArrTime2 = arrEndSlider.getNumber();

    text("Arrival Time: " + chosenArrTime1 + ":00-" + chosenArrTime2 + ":00", 823, 130);

    text("Late", 354, 317);
    text("Cancelled", 502, 317);
  }

  if (results.active) {
    textAlign(LEFT,TOP);
    noStroke();
    fill(140, 240, 250);
    float totalWidth = textWidth("Select a flight to learn more individual details.");
    float titleWidth = textWidth(numbOfSelectedFlights + " Matching Flights");
    float boxWidth = titleWidth + 30;
    rect(40+(totalWidth - boxWidth)/2, 50, boxWidth, 40);
    fill(0);
    text(numbOfSelectedFlights + " Matching Flights", 40+(totalWidth - titleWidth)/2, 64);
    text("Select a flight to learn more individual details.", 40, 100);
    resultTable.draw();
    textAlign(CENTER, CENTER);
  }

if (barCharts1.active) {
    if (selectedFlights.size() > 0) {
      Chart origBarChart = new Chart(50, 20, 300, 300, "Most Common Origins for Specified Flights", color(100, 50, 200), loadedFont);
      origBarChart.loadDataWithType("2", "orig", selectedFlights, origBarChart);
      origBarChart.draw();
      
      Chart destBarChart = new Chart(500, 20, 300, 300, "Most Common Destinations for Specified Flights", color(100, 50, 200), loadedFont);
      destBarChart.loadDataWithType("2", "dest", selectedFlights, destBarChart);
      destBarChart.draw();
      
      Chart carrBarChart = new Chart(250, 350, 300, 300, "Most Common Carrier/Airline for Specified Flights", color(100, 50, 200), loadedFont);
      carrBarChart.loadDataWithType("2", "carrier", selectedFlights, carrBarChart);
      carrBarChart.draw();
    }
  }

if (pieCharts1.active){
  if (selectedFlights.size() > 0){
    PieChart origPieChart = new PieChart(50, 50, 200, 200, "Most Common Origins for Specified Flights", color(100, 50, 200), loadedFont);
    origPieChart.loadDataWithType("orig", selectedFlights, origPieChart);
    origPieChart.draw();
    
    PieChart destPieChart = new PieChart(330, 100, 200, 200, "Most Common Destinations for Specified Flights", color(100, 50, 200), loadedFont);
    destPieChart.loadDataWithType("dest", selectedFlights, destPieChart);
    destPieChart.draw();
    
    PieChart carrierPieChart = new PieChart(650, 50, 200, 200, "Most Common Carriers for Specified Flights", color(100, 50, 200), loadedFont);
    carrierPieChart.loadDataWithType("carrier", selectedFlights, carrierPieChart);
    carrierPieChart.draw();
  }
  
}
  welcome.draw();
  search.draw();
  results.draw();
  flightInfo.draw();
  pieCharts1.draw();
  barCharts1.draw();
  musicButton.draw();
  
  if (flightInfo.active) {
    image(mapImg, 0, 0);

     if (getDeparture < 1) {
     State = departureState;
     getPositions();
     departureXPos = stateXPos;
     departureYPos = stateYPos;
     getDeparture = 1;
     }

     if (getDestination < 1) {
      State = destinationState;
      getPositions();
      destinationXPos = stateXPos;
      destinationYPos = stateYPos;
      getDestination = 1;
     }

    //detDestination and getDeparture need to be reset to 0 when user exits the flightInfo screen

    fill(0, 255, 0);
    strokeWeight(4);
    line(departureXPos, departureYPos, destinationXPos, destinationYPos);
    strokeWeight(2);
    circle(destinationXPos, destinationYPos, 10);
    circle(departureXPos, departureYPos, 10);
  }


  fill(0);
  textFont(loadedFont);

  /********** Frame Counter
   Keep at bottom of draw so nothing gets drawn over it.
   ***********/
  stroke(0);
  frameCounter();
}

// Function to display information about an individual flight
void activateFlightInfo(Flight chosenFlight) {
  results.active = false;
  flightInfo.active = true;
}

/********** INPUT / DROPDOWN FUNCTIONS
 Main functions needed to make input boxes work.
 ***********/

Input newInput(String label, int x_position, int y_position, int width, int height, String standIn) {
  Input box = new Input(label, x_position, y_position, width, height, standIn, false);
  inputs.add(box);
  return box;
}

Dropdown newDropdown(String label, int x_position, int y_position, int width, int height, String standIn, ArrayList<String> list) {
  Dropdown box = new Dropdown(label, x_position, y_position, width, height, standIn, list, true);
  dropdowns.add(box);
  return box;
}

void drawInputsAndDropdowns() {
  for (Input box : inputs) {
    box.draw();
  }
  for (Dropdown box : dropdowns) {
    box.draw();
  }
}

// Returns an ArrayList of all flights that match the user-selected filters
ArrayList<Flight> filteredData() {
  // matchingFlights is an ArrayList<Flight> of all filtered flights, starting out holding ALL flights
  ArrayList<Flight> matchingFlights = new ArrayList<Flight>();
  matchingFlights.addAll(flights);
  
  // Select from matchingFlights only the ones matching dropdowns (or leave untouched if none selected)
  Dropdown[] dropdownOrder = {airline, departure, arrival};
  String[] dropdownCodes = {"carrier","orig","dest"};
  for (int index = 0; index < 3; index++) {
    ArrayList<String> choices = dropdownOrder[index].getSelection();
    if (choices.size() != 0) {
      ArrayList<Flight> flightsOfAllChoices = new ArrayList<Flight>();
      for (String choice : choices) {
        String code = dropdownCodes[index];
        if (code.equals("carrier"))
            choice = data.carrierNameToCode(choice);
        else choice = data.stateNameToCode(choice);
        flightsOfAllChoices.addAll(data.flightsWhichMatchThisCriterion(dropdownCodes[index], choice, matchingFlights));
      }
      matchingFlights = flightsOfAllChoices;
    }
  }
  
  // Select from matchingFlights only the ones matching time inputs
  String[] depTimes = {String.valueOf(depStartSlider.getNumber()), String.valueOf(depEndSlider.getNumber())};
  String[] arrTimes = {String.valueOf(arrStartSlider.getNumber()), String.valueOf(arrEndSlider.getNumber())};
  matchingFlights = data.inThisTimeRange("depTimes", depTimes[0], depTimes[1], matchingFlights);
  matchingFlights = data.inThisTimeRange("arrTimes", arrTimes[0], arrTimes[1], matchingFlights);
  
  // Select from matchingFlights only the ones cancelled
  if (cancelledTickbox.isTicked()) {
    matchingFlights = data.flightsWhichMatchThisCriterion("cancelled", "", matchingFlights);
  }
  
  // Select from matchingFlights only the ones late
  if (lateTickbox.isTicked()) {
    matchingFlights = data.flightsWhichMatchThisCriterion("late", "", matchingFlights);
  }

  // Select from matchingFlights only the ones in the date range;
  int date = calendar.getDate();
  if (date >= 0 && date <= 31) {
    String dateAsString = String.valueOf(date);
    matchingFlights = data.inThisTimeRange("dates", dateAsString, dateAsString, matchingFlights);
  }
  
  numbOfSelectedFlights = matchingFlights.size();
  return matchingFlights;
}

void mouseReleased() {
  depStartSlider.release();
  depEndSlider.release();
  arrStartSlider.release();
  arrEndSlider.release();
  if (results.active) resultTable.scrollBarRelease();
}

void mousePressed() {
  calendar.click();
  lateTickbox.click();
  cancelledTickbox.click();

  if (Math.abs(mouseX - depStartSlider.xpos) < 20 && Math.abs(mouseY - depStartSlider.ypos) < 20)
  {
    depStartSlider.click();
  } else if (Math.abs(mouseX - depEndSlider.xpos) < 20 && Math.abs(mouseY - depEndSlider.ypos) < 20)
  {
    depEndSlider.click();
  }

  if (Math.abs(mouseX - arrStartSlider.xpos) < 20 && Math.abs(mouseY - arrStartSlider.ypos) < 20)
  {
    arrStartSlider.click();
  } else if (Math.abs(mouseX - arrEndSlider.xpos) < 20 && Math.abs(mouseY - arrEndSlider.ypos) < 20)
  {
    arrEndSlider.click();
  }
  

  if (mouseX > musicButton.x && mouseX < musicButton.x + 40 && mouseY > musicButton.y && mouseY < musicButton.y + height) {
    musicEvent = musicButton.getEvent(mouseX, mouseY);
    if (musicEvent == 5) {
      if(musicButton.icon == musicIcon) {
        music.pause();
        musicButton.changeIcon(musicMuteIcon);
      }
      else {
        music.loop();
        musicButton.changeIcon(musicIcon);
      }
    }
  }

                                                // checking if a button was pressed based on the current screen
  if (welcome.active) {
    currentEvent = welcome.getEvent(mouseX, mouseY); // seeing which button is pressed based on mouse position
    if (currentEvent == 1) {
      welcome.active = false;
      search.active = true;
    }
  }

  if (search.active) {
    currentEvent = search.getEvent(mouseX, mouseY);
    if (currentEvent == 1) {
      search.active = false;
      welcome.active = true;
    } else if (currentEvent == 2) {
      search.active = false;
      resultTable.load(filteredData());
      selectedFlights = filteredData();
      results.active = true;
    }
    // Check if an input was selected and update if so
    for (Input box : inputs) {
      box.checkIfClicked(mouseX, mouseY);
      box.updateState();
    }
    for (Dropdown box : dropdowns) {
      box.checkIfClicked(mouseX, mouseY);
    }
  }

  if(results.active) {
    resultTable.clicked();
    currentEvent = results.getEvent(mouseX, mouseY);
    if(currentEvent == 1) {
      results.active = false;
      welcome.active = true;
    }
    else if(currentEvent == 2) {
      results.active = false;
      pieCharts1.active = true;
    }
    else if(currentEvent == 3) {
      results.active = false;
      barCharts1.active = true;
    }
    else if (currentEvent == 5) {
      results.active = false;
      search.active = true;
    }
  }

  if(pieCharts1.active) {
    currentEvent = pieCharts1.getEvent(mouseX, mouseY);
    if(currentEvent == 2) {
      pieCharts1.active = false;
      results.active = true;
    }
  }

  if(barCharts1.active) {
    currentEvent = barCharts1.getEvent(mouseX, mouseY);
    if(currentEvent == 2) {
      barCharts1.active = false;
      results.active = true;
    }
  }
  
  if(flightInfo.active) {
    currentEvent = flightInfo.getEvent(mouseX, mouseY);
    if(currentEvent == 2) {
      flightInfo.active = false;
      results.active = true;
      getDestination = 0;
      getDeparture = 0;
    }
  }
}

void mouseWheel(MouseEvent event) {
  int direction = (int)event.getCount();
  for (Dropdown box : dropdowns) {
    box.checkIfScrolled(direction);
  }
  if (results.active) resultTable.checkIfScrolled(direction);
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

void getPositions() {
  //Alabama
  if (State == "AL") {
    stateXPos = 665;
    stateYPos = 415;
  }
  //Alaska
  else if (State == "AK") {
    stateXPos = 115;
    stateYPos = 500;
  }
  //Arizona
  else if (State == "AZ") {
    stateXPos = 205;
    stateYPos = 370;
  }
  //Arkansas
  else if (State == "AR") {
    stateXPos = 555;
    stateYPos = 375;
  }
  //California
  else if (State == "CA") {
    stateXPos = 70;
    stateYPos = 285;
  }
  //Colorado
  else if (State == "CO") {
    stateXPos = 320;
    stateYPos = 275;
  }
  //Connecticut
  else if (State == "CT") {
    stateXPos = 875;
    stateYPos = 175;
  }
  //Delaware
  else if (State == "DE") {
    stateXPos = 850;
    stateYPos = 250;
  }
  //Florida
  else if (State == "FL") {
    stateXPos = 780;
    stateYPos = 510;
  }
  //Georgia
  else if (State == "GA") {
    stateXPos = 730;
    stateYPos = 410;
  }
  //Hawaii
  else if (State == "HI") {
    stateXPos = 335;
    stateYPos = 575;
  }
  //Idaho
  else if (State == "ID") {
    stateXPos = 190;
    stateYPos = 155;
  }
  //Illinois
  else if (State == "IL") {
    stateXPos = 610;
    stateYPos = 255;
  }
  //Indiana
  else if (State == "IN") {
    stateXPos = 655;
    stateYPos = 255;
  }
  //Iowa
  else if (State == "IA") {
    stateXPos = 530;
    stateYPos = 220;
  }
  //Kansas
  else if (State == "KS") {
    stateXPos = 450;
    stateYPos = 295;
  }
  //Kentucky
  else if (State == "KY") {
    stateXPos = 685;
    stateYPos = 305;
  }
  //Louisiana
  else if (State == "LA") {
    stateXPos = 565;
    stateYPos = 465;
  }
  //Maine
  else if (State == "ME") {
    stateXPos = 905;
    stateYPos = 75;
  }
  //Maryland
  else if (State == "MD") {
    stateXPos = 825;
    stateYPos = 245;
  }
  //Massachusetts
  else if (State == "MA") {
    stateXPos = 885;
    stateYPos = 155;
  }
  //Michigan
  else if (State == "MI") {
    stateXPos = 670;
    stateYPos = 175;
  }
  //Minnesota
  else if (State == "MN") {
    stateXPos = 510;
    stateYPos = 120;
  }
  //Mississippi
  else if (State == "MS") {
    stateXPos = 610;
    stateYPos = 420;
  }
  //Missouri
  else if (State == "MO") {
    stateXPos = 555;
    stateYPos = 300;
  }
  //Montana
  else if (State == "MT") {
    stateXPos = 275;
    stateYPos = 90;
  }
  //Nebraska
  else if (State == "NE") {
    stateXPos = 425;
    stateYPos = 230;
  }
  //Nevada
  else if (State == "NV") {
    stateXPos = 135;
    stateYPos = 235;
  }
  //New Hampshire
  else if (State == "NH") {
    stateXPos = 880;
    stateYPos = 130;
  }
  //New Jersey
  else if (State == "NJ") {
    stateXPos = 855;
    stateYPos = 215;
  }
  //New Mexico
  else if (State == "NM") {
    stateXPos = 310;
    stateYPos = 375;
  }
  //New York
  else if (State == "NY") {
    stateXPos = 835;
    stateYPos = 155;
  }
  //North Carolina
  else if (State == "NC") {
    stateXPos = 800;
    stateYPos = 335;
  }
  //North Dakota
  else if (State == "ND") {
    stateXPos = 420;
    stateYPos = 90;
  }
  //Ohio
  else if (State == "OH") {
    stateXPos = 715;
    stateYPos = 240;
  }
  //Oklahoma
  else if (State == "OK") {
    stateXPos = 470;
    stateYPos = 365;
  }
  //Oregon
  else if (State == "OR") {
    stateXPos = 90;
    stateYPos = 125;
  }
  //Pennsylvania
  else if (State == "PA") {
    stateXPos = 800;
    stateYPos = 210;
  }
  //Rhode Island
  else if (State == "RI") {
    stateXPos = 895;
    stateYPos = 170;
  }
  //South Carolina
  else if (State == "SC") {
    stateXPos = 775;
    stateYPos = 375;
  }
  //South Dakota
  else if (State == "SD") {
    stateXPos = 420;
    stateYPos = 160;
  }
  //Tennessee
  else if (State == "TN") {
    stateXPos = 665;
    stateYPos = 350;
  }
  //Texas
  else if (State == "TX") {
    stateXPos = 435;
    stateYPos = 465;
  }
  //Utah
  else if (State == "UT") {
    stateXPos = 220;
    stateYPos = 260;
  }
  //Vermont
  else if (State == "VT") {
    stateXPos = 860;
    stateYPos = 120;
  }
  //Virginia
  else if (State == "VA") {
    stateXPos = 800;
    stateYPos = 285;
  }
  //Washington
  else if (State == "WA") {
    stateXPos = 115;
    stateYPos = 55;
  }
  //West Virginia
  else if (State == "WV") {
    stateXPos = 755;
    stateYPos = 275;
  }
  //Wisconsin
  else if (State == "WI") {
    stateXPos = 590;
    stateYPos = 155;
  }
  //Wyoming
  else if (State == "WY") {
    stateXPos = 300;
    stateYPos = 185;
  } 
  //Puerto Rico
  else if (State == "PR") {
    stateXPos = 950;
    stateYPos = 630;
  } 
  //US Virgin Islands
  else if (State == "VI") {
    stateXPos = 0;
    stateYPos = 320;
  } 
else {
//Incase we get a weird code, be it a typo or an unexpected departure/destination. Having it set to the top left guarantees that the error is noticed
    stateXPos = 0;
    stateYPos = 0;
  }
}

/**********
 FRAME COUNTER
 ***********/
//Gives us an idea of where slowdown occurs and lets us see if changes improve/worsen any issues
void frameCounter() {
  fill(255);
  rect(0, 0, 30, 20);
  float fps = frameRate;
  int framesPerSecond = round(fps);
  fill(0);
  text(" " + framesPerSecond, 15, 10);
}
