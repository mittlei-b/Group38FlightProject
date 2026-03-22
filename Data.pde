public class Data {
  Table data;
  
  public Data(String fileName) {
    data = loadTable(fileName, "header");
  }
  
  public void printAllRows() {
    fill(0);
    int height = 15;
    int width = 5;
    /********** CSV FILE VARIABLE ORDER
      Date, Carrier, Carrier Number, Origin, Departure City/State, Departure State
      Departure Code, Destination, Arrival City/State, Arrival State, Arrival Code
      Planned Departure Time, Actual Departure Time, Planned Arrival Time, Actual
      Arrival Time, Is/Isn't Cancelled, Is/Isn't Diverted
    ***********/
    int[] variableWidths = {140,50,60,50,180,70,70,70,180,70,70,80,80,70,70,50,50,50};
    String[] columnNames = {"Date","Carrier","Carrier #","Origin","Dep. City",
                            "Dep. State", "Dep. Code", "Destination", "Arr. City",
                            "Arr. State", "Arr. Code", "Planned Dep.", "Actual Dep.",
                            "Planned Arr.", "Actual Arr.", "Cancelled","Diverted",
                            "Cancelled"};
    String[] columnIDs = {"FL_DATE","MKT_CARRIER","MKT_CARRIER_FL_NUM","ORIGIN",
                          "ORIGIN_CITY_NAME","ORIGIN_STATE_ABR","ORIGIN_WAC",
                          "DEST","DEST_CITY_NAME","DEST_STATE_ABR","DEST_WAC",
                          "CRS_DEP_TIME","DEP_TIME","CRS_ARR_TIME","ARR_TIME",
                          "CANCELLED","DIVERTED","DISTANCE"};
    String[] columnTypes = {"String","String","Int","String","String","String",
                            "Int","String","String","String","Int","Int","Int",
                            "Int","Int","Int","Int","Float"};
    for (int index = 0; index < columnNames.length; index++) {
      text(columnNames[index], width, height);
      width += variableWidths[index];
    }
    for (TableRow row : data.rows()) {
      width = 5;
      if (height < SCREEN_HEIGHT - 20) {
        height += 15;
        for (int index = 0; index < columnIDs.length; index++) {
          if (columnTypes[index] == "String")
            text(row.getString(columnIDs[index]), width, height);
          else if (columnTypes[index] == "Int") {
            text(row.getInt(columnIDs[index]), width, height);
          } else if (columnTypes[index] == "Float")
            text(row.getFloat(columnIDs[index]), width, height);
          width += variableWidths[index];
        }
      }
    }
  }


public float getAvgDistance(ArrayList<Flight> flightList) {
  float totalFlightKms = 0;
  float totalFlightsThisType = 0;
  for (Flight f : flightList) {
    totalFlightsThisType++;
    totalFlightKms += f.distance;
  }
  float meanDistance = totalFlightKms/totalFlightsThisType;
  return meanDistance;
}

public ArrayList<Flight> flightsWhichMatchThisCriterion(String type, String value, ArrayList<Flight> flightList) {
  ArrayList<Flight> flightSubList = new ArrayList<Flight>();
  switch (type) {
    case ("late"):
    for (Flight f : flightList) {
      if (f.actualArr > f.plannedArr) {
        flightSubList.add(f);
      }
    }
    return flightSubList;
    case ("diverted"):
    for (Flight f : flightList) {
      if (f.diverted) {
        flightSubList.add(f);
      }
    }
    return flightSubList;
    case ("cancelled"):
    for (Flight f : flightList) {
      if (f.cancelled) {
        flightSubList.add(f);
      }
    }
    return flightSubList;
    case ("carrier"):
    for (Flight f : flightList) {
      if ((f.carrier).equals(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;
    case ("orig"):
    for (Flight f : flightList) {
      if ((f.origStateAbr).equals(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;
    case ("dest"):
    for (Flight f : flightList) {
      if ((f.destStateAbr).equals(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;
    case ("accDepTimeMinimum"):
    for (Flight f : flightList) {
      if ((f.actualDep) > Integer.parseInt(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;

    case ("accDepTimeMaximum"):
    for (Flight f : flightList) {
      if ((f.actualDep) < Integer.parseInt(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;

    case ("accArrTimeMinimum"):
    for (Flight f : flightList) {
      if ((f.actualArr) > Integer.parseInt(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;

    case ("accArrTimeMaximum"):
    for (Flight f : flightList) {
      if ((f.actualArr) < Integer.parseInt(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;

    case ("dateMinimum"):
    for (Flight f : flightList) {
      Scanner date = new Scanner(f.date);
      date.useDelimiter("/");
      String month = date.next();
      String dateDay = date.next();
      date.close();
      int dateDayInt = Integer.parseInt(dateDay);
      if ((dateDayInt) > Integer.parseInt(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;
    
    case ("dateMaximum"):
    for (Flight f : flightList) {
      Scanner date = new Scanner(f.date);
      date.useDelimiter("/");
      String month = date.next();
      String dateDay = date.next();
      date.close();
      int dateDayInt = Integer.parseInt(dateDay);
      if ((dateDayInt) < Integer.parseInt(value)) {
        flightSubList.add(f);
      }
    }
    return flightSubList;

  default:
    return flightSubList;
  }
}

public ArrayList<Flight> inThisTimeRange(String type, String min, String max, ArrayList<Flight> flightList) {
  ArrayList<Flight> flightSubList = new ArrayList<Flight>();

  switch (type) {
  case "depTimes":
    ArrayList<Flight> flightFilteredByMinDept = flightsWhichMatchThisCriterion("accDepTimeMinimum", min, flightList);
    flightSubList = flightsWhichMatchThisCriterion("accDepTimeMaximum", max, flightFilteredByMinDept);
    return flightSubList;
  case "arrTimes":
    ArrayList<Flight> flightFilteredByMinArr = flightsWhichMatchThisCriterion("accArrTimeMinimum", min, flightList);
    flightSubList = flightsWhichMatchThisCriterion("accArrTimeMaximum", max, flightFilteredByMinArr);
    return flightSubList;
  case "dates":
    ArrayList<Flight> flightFilteredByMinDate = flightsWhichMatchThisCriterion("dateMinimum", min, flightList);
    flightSubList = flightsWhichMatchThisCriterion("dateMaximum", max, flightFilteredByMinDate);
    return flightSubList;
  default:
    return flightSubList;
  }
}

public float percentWhichMatchThisCriterion(String type, String value, ArrayList<Flight> flightList) {
  int totalFlights = flightList.size();
  int numbThatMatchThisCriterion = flightsWhichMatchThisCriterion(type, value, flightList).size();
  float percent = ((float(numbThatMatchThisCriterion)) / (float(totalFlights) ) ) *100;
  float percentRounded = roundToTwoDecimals(percent);
  return percentRounded;
}

public float percentInThisTimeRange(String type, String min, String max, ArrayList<Flight> flightList){
  int totalFlights = flightList.size();
  int numbInThisTimeRange = inThisTimeRange(type, min, max, flightList).size();
  float percent = ((float(numbInThisTimeRange)) / (float(totalFlights) ) ) *100;
  float percentRounded = roundToTwoDecimals(percent);
  return percentRounded;
}


public float roundToTwoDecimals(float numb) {
  return (float(round(numb*100)))/100;
}

public String mostPopValue(String type, ArrayList<Flight> flightList) {
  String mostPop = "";
  int amtOfMostPop = 0;
  switch (type) {
  case "dest":
    for (String s : stateCodes(flightList)) {
      int flightsToHere = flightsWhichMatchThisCriterion("dest", s, flightList).size();
      if (flightsToHere > amtOfMostPop) {
        amtOfMostPop = flightsToHere;
        mostPop = s;
      }
    }
    return mostPop;

  case "orig":
    for (String s : stateCodes(flightList)) {
      int flightsFromHere = flightsWhichMatchThisCriterion("orig", s, flightList).size();
      if (flightsFromHere > amtOfMostPop) {
        amtOfMostPop = flightsFromHere;
        mostPop = s;
      }
    }
    return mostPop;

  case "carrier":
    for (String s : carrierCodes(flightList)) {
      int flightsToHere = flightsWhichMatchThisCriterion("dest", s, flightList).size();
      if (flightsToHere > amtOfMostPop) {
        amtOfMostPop = flightsToHere;
        mostPop = s;
      }
    }
    return mostPop;

  default:
    return "";
  }
}

public ArrayList<String> stateCodes(ArrayList<Flight> flights) {
  ArrayList<String> stateCodes = new ArrayList<String>();

  for (Flight f : flights) { //Creates an ArrayList of all state abbreviations that exist
    String stateCode = f.origStateAbr;
    boolean recordedAlready = false;
    for (String s : stateCodes) {
      if (s.equals(stateCode)) recordedAlready = true;
    }
    if (!recordedAlready) stateCodes.add(stateCode);
  }
  return stateCodes;
}

public ArrayList<String> carrierCodes(ArrayList<Flight> flights) {
  ArrayList<String> carrierCodes = new ArrayList<String>();

  for (Flight f : flights) { //Creates an ArrayList of all carrier abbreviations that exist
    String carrierCode = f.carrier;
    boolean recordedAlready = false;
    for (String s : carrierCodes) {
      if (s.equals(carrierCode)) recordedAlready = true;
    }
    if (!recordedAlready) carrierCodes.add(carrierCode);
  }
  return carrierCodes;
}
}
