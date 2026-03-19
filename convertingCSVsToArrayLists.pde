// In this program, I show how CSV files might be analysed as ArrayLists for ease of analysis and reference

int totalNumbOfFlights; // Total number of flights, used for comparison
int numbOfSelectedFlights; // Number of flights, now that data has been narrowed down based on a specific parameter

// I treat each flight as its own object wherein each of the columns
// (e.g. departure city, cancelled/not cancelled, etc.) are treated as attributes
// of that particular object. I think this will make referencing and checking
// these values a bit simpler

class Flight {
  String date, carrier, origin, origCity, origStateAbr, dest, destCity,
    destStateAbr;
  int carrierNumb, originCode, destCode, plannedDep, ActualDep,
    plannedArr, actualArr;
  float distance;
  boolean diverted, cancelled;

  Flight(String tDate, String tCarrier, int tCarrierNumb,
    String tOrigin, String tOrigCity, String tOrigStateAbr,
    int tOriginCode, String tDest, String tDestCity,
    String tDestStateAbr, int tDestCode, int tPlannedDep,
    int tActualDep, int tPlannedArr, int tActualArr, float tDistance,
    int tDiverted, int tCancelled) { // Constructor for creating the flight object taking in all relevant fields

    // storing these values in the relevant attributes
    date = tDate;
    carrier = tCarrier;
    origin = tOrigin;
    origCity = tOrigCity;
    origStateAbr = tOrigStateAbr;
    dest = tDest;
    destCity = tDestCity;
    destStateAbr = tDestStateAbr;
    carrierNumb = tCarrierNumb;
    originCode = tOriginCode;
    destCode = tDestCode;
    plannedDep = tPlannedDep;
    ActualDep = tActualDep;
    plannedArr = tPlannedArr;
    actualArr = tActualArr;
    distance = tDistance;
    if (tDiverted == 1) {
      diverted = true;
    } else diverted = false;
    if (tCancelled == 1) { // I think it makes much more sense to store diverted and cancelled as boolean values, just for simplicity when coding
      cancelled = true;   // I think they map a bit better to natural language this way(e.g. "if (cancelled)" rather than "if(cancelled == 1)" )
    } else cancelled = false;
  }
}

ArrayList<Flight> flights = new ArrayList<Flight>();

void setup() {
  Table flightsTable = loadTable("flights_full.csv", "header");
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
  // Sample application of this framework
  // Let's say this user wants only flights from Arizona
  String depState = "AZ"; // This is just hardcoded into the program here but it would be decided based on a scanner or sum
  
  
  ArrayList<String> stateCodes = new ArrayList<String>();
  
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
    println(flightsToHere + " flights were made from Texas to " + s + ".");
  }
  
  println("Total flights from Arizona to Texas: " + flightsToTexas);

  float percentDiverted = getPercentage("DIVERTED", flightSubList);
  float pDivertedRounded = (float(round(percentDiverted*100)))/100;
  
  double meanDistance = getMean("DISTANCE", flightSubList);
  float meanDistRounded = float(round((float)(meanDistance*100)))/100;

  println("Mean distance of selected flights in km: " + meanDistRounded);
  println("Percentage of selected flights that were diverted: " + pDivertedRounded + "%");
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

// Here I just use the framework to find the number of flights come from
// Texas relative to the flights overall, as well as the percentage of
// flights which were diverted or cancelled for a given subset of flights.
// However I think that it could also be useful for filtering data for
// other purposes, like finding the mean departure time
// of a subset of flights, or any number of other things.

// I think that this could be adapted / put into the main code by adding
// multiple variables to the if statement at the end by default. So like if
// I wanted flights from Michigan that were cancelled, I would have to
// specify multiple variables at once. idk if I'm explaining myself very well
// I'll try to explain one of the days in person lol
