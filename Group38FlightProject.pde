import java.util.Scanner;
import java.util.Arrays;
import java.io.*;

// Design variables
PFont myFont;
int SCREEN_HEIGHT = 600;
int SCREEN_WIDTH = 1500;

// Development (dev) variables
Screen welcome; // This is our welcome screen
Screen home; // This is our home screen
Screen results; // This is our results screen
Data data; // This is our class for storing flight data

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup() {
  // Design variables
  myFont = loadFont("ArialMT-12.vlw");
  textFont(myFont);
  background(255);
  fill(0);
  
  // Dev variables
  data = new Data("flights_full.csv");
  data.printAllRows();
}

void draw() {
}
