import java.util.Scanner;
import java.util.Arrays;
import java.io.*;

Screen home;
Screen results;
Table data;

void settings() {
  
}

void setup() {
  data = loadTable("flights_full.csv", "header");
}

void draw() {
  for (TableRow row : data.rows()) {
    String name = row.getString("ORIGIN");
    println("Name: " + name);
  }
}
