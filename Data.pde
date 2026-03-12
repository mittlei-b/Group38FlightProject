public class Data {
  Table data;
  //hi
  
  public Data(String fileName) {
    data = loadTable(fileName, "header");
  }
  
  public void printAllRows() {
    int height = 15;
    int width = 5;
    int dateW = 140;
    int carrierW = 50;
    int carrierNumW = 60;
    int originW = 50;
    int depCityW = 180;
    int depStateW = 70;
    int depCodeW = 70;
    int destW = 70;
    int arrCityW = 180;
    int arrStateW = 70;
    int arrCodeW = 70;
    int plaDepW = 80;
    int actDepW = 80;
    int plaArrW = 70;
    int actArrW = 70;
    int cancelledW = 65;
    int divertedW = 55;
    text("Date", width, height);
    width += dateW;
    text("Carrier", width, height);
    width += carrierW;
    text("Carrier #", width, height);
    width += carrierNumW;
    text("Origin", width, height);
    width += originW;
    text("Dep. City", width, height);
    width += depCityW;
    text("Dep. State", width, height);
    width += depStateW;
    text("Dep. Code", width, height);
    width += depCodeW;
    text("Destination", width, height);
    width += destW;
    text("Arr. City", width, height);
    width += arrCityW;
    text("Arr. State", width, height);
    width += arrStateW;
    text("Arr. Code", width, height);
    width += arrCodeW;
    text("Planned Dep.", width, height);
    width += plaDepW;
    text("Actual Dep.", width, height);
    width += actDepW;
    text("Planned Arr.", width, height);
    width += plaArrW;
    text("Actual Arr.", width, height);
    width += actArrW;
    text("Cancelled", width, height);
    width += cancelledW;
    text("Diverted", width, height);
    width += divertedW;
    text("Distance", width, height);
    for (TableRow row : data.rows()) {
      int chance = (int)random(0,1000);
      if (chance == 4) {
        width = 5;
        if (height < SCREEN_HEIGHT - 20) {
          height += 15;
          text(row.getString("FL_DATE") + "\t", width, height);
          width += dateW;
          text(row.getString("MKT_CARRIER") + "\t", width, height);
          width += carrierW;
          text(row.getInt("MKT_CARRIER_FL_NUM") + "\t", width, height);
          width += carrierNumW;
          text(row.getString("ORIGIN") + "\t", width, height);
          width += originW;
          text(row.getString("ORIGIN_CITY_NAME") + "\t", width, height);
          width += depCityW;
          text(row.getString("ORIGIN_STATE_ABR") + "\t", width, height);
          width += depStateW;
          text(row.getInt("ORIGIN_WAC") + "\t", width, height);
          width += depCodeW;
          text(row.getString("DEST") + "\t", width, height);
          width += destW;
          text(row.getString("DEST_CITY_NAME") + "\t", width, height);
          width += arrCityW;
          text(row.getString("DEST_STATE_ABR") + "\t", width, height);
          width += arrStateW;
          text(row.getInt("DEST_WAC") + "\t", width, height);
          width += arrCodeW;
          text(row.getInt("CRS_DEP_TIME") + "\t", width, height);
          width += plaDepW;
          text(row.getInt("DEP_TIME") + "\t", width, height);
          width += actDepW;
          print(row.getInt("CRS_ARR_TIME") + "\t");
          width += plaArrW;
          text(row.getInt("ARR_TIME") + "\t", width, height);
          width += actArrW;
          text(row.getInt("CANCELLED") + "\t", width, height);
          width += cancelledW;
          text(row.getInt("DIVERTED") + "\t", width, height);
          width += divertedW;
          text(row.getFloat("DISTANCE") + "\t", width, height);
        }
      }
    }
  }
}
