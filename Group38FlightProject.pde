import java.util.Scanner;
import java.util.Arrays;
import java.io.*;


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
PImage pieChartIcon;
PImage barChartIcon;
PImage mapIcon;
Widget musicButton;
SoundFile music;
int SCREEN_HEIGHT = 640;
int SCREEN_WIDTH = 960;

/**********
 SCREEN VARIABLES
 ***********/
Screen welcome = new Screen();
// initialising screens here because i get a null pointer exception later otherwise??
Screen search = new Screen();
Screen results = new Screen();
Screen flightInfo = new Screen();
Screen pieCharts1 = new Screen();
Screen pieCharts2 = new Screen();
Screen barCharts1 = new Screen();
Screen barCharts2 = new Screen();

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
PImage starsAndStripes;

/**********
 INPUT VARIABLES
 ***********/
ArrayList<Input> inputs;
ArrayList<Dropdown> dropdowns;
Dropdown departure;
Dropdown arrival;
Dropdown airline;
filter depStartSlider, depEndSlider;
filter arrStartSlider, arrEndSlider;
filter calendar;
filter lateTickbox, cancelledTickbox;
PImage tickedImg, untickedImg, calendarImg;
boolean dragStart = false, dragEnd = false;
boolean showTable;
Sheet resultTable;

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
  tableFont = loadFont(smallFont);
  showTable = false;
  resultTable = new Sheet(SCREEN_WIDTH/2 - 245, SCREEN_HEIGHT/2-100, 490, 360, "Results", color(100, 100, 255), loadedFont);
  /********** DESIGN
   All variables to do with design go first (font, colors, styling, etc.)
   Anything DRAWN (that needs setup) goes AFTER input boxes and data table.
   ***********/

  welcomeBackground = loadImage("backgroundImage.jpg");
  homeIcon = loadImage("Home_Icon.PNG");
  musicIcon = loadImage("MusicIcon.PNG");
  musicMuteIcon = loadImage("MusicMutedIcon.PNG");
  pieChartIcon = loadImage("PieChartIcon.PNG");
  barChartIcon = loadImage("BarChartIcon.PNG");
  mapIcon = loadImage("MapIcon.PNG");
  untickedImg = loadImage("unticked.jpg");
  tickedImg = loadImage("ticked.jpg");
  calendarImg = loadImage("januaryCalendar.jpg");
  calendarImg.resize(200, 200);
  welcomeBackground.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  loadedFont = loadFont(font);
  textFont(loadedFont);
  welcomeFont = createFont("Arial", 40);
  background(255);
  fill(0);

  music = new SoundFile(this, "data/lofiSong.mp3");
  // Music track: gingersweet by massobeats
  //Source: https://freetouse.com/music
  //Free Vlog Music Without Copyright
  music.loop();

  /********** WIDGETS
   making all widgets on each screen here + setting welcome to active so
   it shows when program starts
   **********/
  welcome.active = true;

  welcome.addWidgetA((SCREEN_WIDTH/2 - 100), 200, 200, 50, "Welcome", color(180, 200, 255), welcomeFont);
  welcome.addWidgetB(SCREEN_WIDTH/2 - 80, 300, 160, 30, "Start searching", color(180, 200, 255), loadedFont, 1);
  welcome.addWidgetA(SCREEN_WIDTH/2 - 185, 380, 370, 30, "By Emily Eulitz, Shane Jones, Autumn Kaiser,", color(2, 176, 207), loadedFont);
  welcome.addWidgetA(SCREEN_WIDTH/2 - 160, 410, 320, 30, "Brynne Mittleider, Lauren McGaughey", color(2, 176, 207), loadedFont);
  welcome.addWidgetA(SCREEN_WIDTH/2 - 90, 440, 180, 30, "and Ethan Ó Mórdha", color(2, 176, 207), loadedFont);

  search.addWidgetC(80, SCREEN_HEIGHT-60, 40, 40, homeIcon, 1);
  search.addWidgetA(60, 60, 150, 40, "Enter queries...", color(140, 240, 250), loadedFont);
  search.addWidgetB(780, 560, 150, 50, "Search", color(140, 240, 255), loadedFont, 2);

  results.addWidgetA(SCREEN_WIDTH/2-75, 60, 150, 40, "Matching Results", color(150, 150, 250), loadedFont);
  results.addWidgetC(80, SCREEN_HEIGHT-60, 40, 40, homeIcon, 1);
  results.addWidgetC(140, SCREEN_HEIGHT-60, 40, 40, homeIcon, 2);
  results.addWidgetC(200, SCREEN_HEIGHT-60, 40, 40, homeIcon, 3);
  results.addWidgetC(260,  SCREEN_HEIGHT-60, 40, 40, mapIcon, 4);

  flightInfo.addWidgetB(100, 780, 100, 40, "Back", color(100, 180, 255), loadedFont, 2);
  mapImg = loadImage("USA.png");
  starsAndStripes = loadImage("Stars_And_Stripes.png");
  //starsAndStripes.resize(960, 640);

  pieCharts1.addWidgetB(SCREEN_WIDTH-120, SCREEN_HEIGHT-60, 100, 40, "Next", color(200, 200, 200), loadedFont, 1);
  pieCharts1.addWidgetB(80, SCREEN_HEIGHT-60, 80, 40, "Back", color(100, 180, 155), loadedFont, 2);

  pieCharts2.addWidgetB(80, SCREEN_HEIGHT-60, 80, 40, "Back", color(100, 180, 155), loadedFont, 1);

  barCharts1.addWidgetB(SCREEN_WIDTH-120, SCREEN_HEIGHT-60, 100, 40, "Next", color(200, 200, 200), loadedFont, 1);
  barCharts1.addWidgetB(80, SCREEN_HEIGHT-60, 80, 40, "Back", color(100, 180, 155), loadedFont, 2);

  barCharts1.addWidgetB(80, SCREEN_HEIGHT-60, 80, 40, "Back", color(100, 180, 155), loadedFont, 1);


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

  // ArrayList of all carrier names
  ArrayList<String> carrierNames = new ArrayList<String>();
  for (String code : data.carrierCodes(flights)) {
    String name = data.carrierCodeToName(code);
    carrierNames.add(name);
  }

  // ArrayList of all departure locations
  ArrayList<String> locations = new ArrayList<String>();
  for (String locale : data.stateCodes(flights)) {
    locations.add(locale);
  }


  /********** INPUT BOXES AND DROPDOWNS
   To add new input boxes or dropdowns, copy the format in the comment below
   newInput(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY)
   newDropdown(LABEL, X, Y, WIDTH, HEIGHT, DEFAULT TEXT WHEN EMPTY, OPTION LIST)
   ***********/
  inputs = new ArrayList<Input>();
  dropdowns = new ArrayList<Dropdown>();
  airline = newDropdown("Airline", 50, 140, 130, 25, "Airline", carrierNames);
  departure = newDropdown("Departure", 200, 140, 130, 25, "Departure", locations);
  arrival = newDropdown("Arrival", 350, 140, 130, 25, "Arrival", locations);

  calendar = new filter("calendar", 50, 330, calendarImg.width - 20, calendarImg.height - 20, calendarImg);
  depStartSlider = new filter("slider", "start", 520, 150, 10, 0, 200, 0, 175, 5);
  depEndSlider = new filter("slider", "end", 695, 150, 10, 0, 200, 24, 175, 5);
  arrStartSlider = new filter("slider", "start", 745, 150, 10, 0, 200, 0, 175, 5);
  arrEndSlider = new filter("slider", "end", 920, 150, 10, 0, 200, 24, 175, 5);
  lateTickbox = new filter("tickbox", 340, 330, 25, untickedImg, tickedImg);
  cancelledTickbox = new filter("tickbox", 490, 330, 25, untickedImg, tickedImg);

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


  /********** Background Color
   and Input Boxes at the top
   ***********/
  if (welcome.active) image(welcomeBackground, 0, 0);
  else background(255);

  if (search.active) {
    textFont(loadedFont);
    drawInputsAndDropdowns();
  }

  if (search.active) {
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
    text(filteredData().size() + " flights match your criteria", width/2, 150);
    if (showTable) resultTable.draw();
  }

  welcome.draw();
  search.draw();
  results.draw();
  flightInfo.draw();
  pieCharts1.draw();
  pieCharts2.draw();
  barCharts1.draw();
  barCharts2.draw();
  
  if (flightInfo.active) {
    image(starsAndStripes, 0, 0);
    image(mapImg, 0, 0);

    // if (getDeparture < 1) {
    // State = departureState;
    // getPositions();
    // departureXPos = stateXPos;
    // departureYPos = stateYPos;
    // getDeparture = 1;
    // }

    // if (getDestination < 1) {
    //  State = destinationState;
    //  getPositions();
    //  destinationXPos = stateXPos;
    //  destinationYPos = stateYPos;
    //  getDestination = 1;
    // }

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

/********** INPUT / DROPDOWN FUNCTIONS
 Main functions needed to make input boxes work.
 ***********/

Input newInput(String label, int x_position, int y_position, int width, int height, String standIn) {
  Input box = new Input(label, x_position, y_position, width, height, standIn);
  inputs.add(box);
  return box;
}

Dropdown newDropdown(String label, int x_position, int y_position, int width, int height, String standIn, ArrayList<String> list) {
  Dropdown box = new Dropdown(label, x_position, y_position, width, height, standIn, list);
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

ArrayList<Flight> filteredData() {
  //Chart graph = new Chart(100,100, 300,300,"Departed Flights on Specific Airlines",color(0,0,200),loadedFont);
  ArrayList<String> departureChoice = departure.getSelection();
  //println("Departing from: " + departureChoice.toString());
  ArrayList<String> arrivalChoice = arrival.getSelection();
  //println("Arriving from: " + arrivalChoice.toString());
  ArrayList<String> airlineChoice = airline.getSelection();
  //println("On: " + airlineChoice.toString());
  ArrayList<Flight> flightsByOrigin = new ArrayList<Flight>();
  if (departureChoice.size() != 0) {
    for (String choice : departureChoice) {
      flightsByOrigin.addAll(data.flightsWhichMatchThisCriterion("orig", choice, flights));
    }
  } else {
    flightsByOrigin.addAll(flights);
  }

  ArrayList<Flight> flightsByOriginCarrier = new ArrayList<Flight>();
  if (airlineChoice.size() != 0) {
    for (String choice : airlineChoice) {
      choice = data.carrierNameToCode(choice);
      flightsByOriginCarrier.addAll(data.flightsWhichMatchThisCriterion("carrier", choice, flightsByOrigin));
    }
  } else {
    flightsByOriginCarrier.addAll(flightsByOrigin);
  }

  ArrayList<Flight> flightsByOriginCarrierDest = new ArrayList<Flight>();
  if (arrivalChoice.size() != 0) {
    for (String choice : arrivalChoice) {
      flightsByOriginCarrierDest.addAll(data.flightsWhichMatchThisCriterion("dest", choice, flightsByOriginCarrier));
    }
  } else {
    flightsByOriginCarrierDest.addAll(flightsByOriginCarrier);
  }

  int chosenDepTime1 = depStartSlider.getNumber();
  int chosenDepTime2 = depEndSlider.getNumber();

  int chosenArrTime1 = arrStartSlider.getNumber();
  int chosenArrTime2 = arrEndSlider.getNumber();

  ArrayList<Flight> flightsByDepTime = new ArrayList<Flight>();
  flightsByDepTime.addAll(data.inThisTimeRange("depTimes", String.valueOf(chosenDepTime1), String.valueOf(chosenDepTime2), flightsByOriginCarrierDest));

  ArrayList<Flight> flightsByArrTime = new ArrayList<Flight>();
  flightsByArrTime.addAll(data.inThisTimeRange("arrTimes", String.valueOf(chosenArrTime1), String.valueOf(chosenArrTime2), flightsByDepTime));
   
  ArrayList<Flight> flightsByCancelled = new ArrayList<Flight>();
  if (cancelledTickbox.ticked) {
    flightsByCancelled.addAll(data.flightsWhichMatchThisCriterion("cancelled", "", flightsByArrTime));
  } else {
    flightsByCancelled.addAll(flightsByArrTime);
  }
  
  ArrayList<Flight> flightsByLate = new ArrayList<Flight>();
  if (lateTickbox.ticked) {
    flightsByLate.addAll(data.flightsWhichMatchThisCriterion("late", "", flightsByCancelled));
  } else {
    flightsByLate.addAll(flightsByCancelled);
  }

  //Flights Filtered By Date
  ArrayList<Flight> finalFilteredList = new ArrayList<Flight>();
  int date = calendar.getDate();
  if (date >= 0 && date <= 31) {
    String dateAsString = String.valueOf(date);
    finalFilteredList.addAll(data.inThisTimeRange("dates", dateAsString, dateAsString, flightsByLate));
  }
  else {
    finalFilteredList.addAll(flightsByLate);
  }

  return finalFilteredList;
}

void loadChart(){
  ArrayList<Flight> filteredFlights = filteredData();
  resultTable.load(filteredFlights);
  showTable = true;
  
  // Now have an ArrayList of flights of CARRIER, DEST, ORIGIN
  
  //  Flights departed from
  //graph.load(numberChoice, departureChoice, airlineChoice);
  //chart.load(stateCodes, numbFlightsTXtoX);
}

void mouseReleased() {
  depStartSlider.release();
  depEndSlider.release();
  arrStartSlider.release();
  arrEndSlider.release();
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

  // Check if an input was selected and update if so
  for (Input box : inputs) {
    box.checkIfClicked();
    box.updateState();
  }
  for (Dropdown box : dropdowns) {
    box.checkIfClicked();
  }

if(mouseX > musicButton.x && mouseX < musicButton.x + 40 && mouseY > musicButton.y && mouseY < musicButton.y + height);
  musicEvent = musicButton.getEvent(mouseX, mouseY);
  if(musicEvent == 5) {
    if(musicButton.icon == musicIcon) {
      music.pause();
      musicButton.changeIcon(musicMuteIcon);
    }
    else {
      music.loop();
      musicButton.changeIcon(musicIcon);
    }
  }

  if (welcome.active) {
    currentEvent = welcome.getEvent(mouseX, mouseY);
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
      results.active = true;


      // code to update what data appears goes here?
    }
  }

  if(results.active) {
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
  }

  if(pieCharts1.active) {
    currentEvent = pieCharts1.getEvent(mouseX, mouseY);
    if(currentEvent == 1) {
      pieCharts1.active = false;
      pieCharts2.active = true;
    }
    else if(currentEvent == 2) {
      pieCharts1.active = false;
      results.active = true;
    }
  }

  if(pieCharts2.active) {
    currentEvent = pieCharts2.getEvent(mouseX, mouseY);
    if(currentEvent == 1) {
      pieCharts2.active = false;
      pieCharts1.active = true;
    }
  }

  if(barCharts1.active) {
    currentEvent = barCharts1.getEvent(mouseX, mouseY);
    if(currentEvent == 1) {
      barCharts1.active = false;
      barCharts2.active = true;
    }
    else if(currentEvent == 2) {
      barCharts1.active = false;
      results.active = true;
    }
  }

  if(barCharts2.active) {
    currentEvent = barCharts2.getEvent(mouseX, mouseY);
    if(currentEvent == 1) {
      barCharts2.active = false;
      barCharts1.active = true;
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
    stateXPos = 0;
    stateYPos = 0;
  }
}

/**********
 FRAME COUNTER
 ***********/
void frameCounter() {
  fill(255);
  rect(0, 0, 30, 20);
  float fps = frameRate;
  int framesPerSecond = round(fps);
  fill(0);
  text(" " + framesPerSecond, 15, 10);
}
