// In this program, I show how CSV files might be analysed as ArrayLists for ease of analysis and reference

// I treat each flight as its own object wherein each of the columns
// (e.g. departure city, cancelled/not cancelled, etc.) are treated as attributes
// of that particular object. I think this will make referencing and checking
// these values a bit simpler

class Flight {
  String date, carrier, origin, origCity, origStateAbr, dest, destCity,
    destStateAbr;
  int carrierNumb, originCode, destCode, plannedDep, actualDep,
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
    plannedDep = tPlannedDep/100;
    actualDep = tActualDep/100;
    plannedArr = tPlannedArr/100;
    actualArr = tActualArr/100;
    distance = tDistance;
    if (tDiverted == 1) {
      diverted = true;
    } else diverted = false;
    if (tCancelled == 1) { // I think it makes much more sense to store diverted and cancelled as boolean values, just for simplicity when coding
      cancelled = true;   // I think they map a bit better to natural language this way(e.g. "if (cancelled)" rather than "if(cancelled == 1)" )
    } else cancelled = false;
  }
}
