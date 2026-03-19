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
}
