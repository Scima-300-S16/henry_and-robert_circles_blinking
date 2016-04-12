// Be sure to put locations.tsv and names.tsv
// from b_getting_locations into your current data folder!

//in this version i am also adding names.tsv and 
// grabbing the text, plugging it into the text function

//introduce variables and objects
Circle[] myCircles;
int numOfMyCircles = 50;
int currentCircle = 0;

PImage mapImage;
PImage steak;

Table locationTable; //this is using the Table object
Table amountsTable; //this is using the Table object
Table namesTable;
Table landTTable;
int rowCount;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;

//global variables assigned values in drawData()
float closestDist;
String closestText;
float closestTextX;
float closestTextY;

int previousMillis =0;
int interval = 100;

int currentColor=10;

int counter = 0;


void setup() {
  size(640, 400);
  mapImage = loadImage("san franciso map.jpg");
  steak = loadImage("Cheese-Steak.jpg");
  
  //assign tables to object
  locationTable = new Table("locations.tsv");  
  amountsTable = new Table("amounts.tsv");
   namesTable = new Table("names.tsv");
  landTTable = new Table ("tandl.tsv");
  
  // get number of rows and store in a variable called rowCount
  rowCount = locationTable.getRowCount();
  //count through rows to find max and min values in random.tsv and store values in variables
  for (int row = 0; row< rowCount; row++) {
    //get the value of the second field in each row (1)
    float value = amountsTable.getFloat(row, 1);
    //if the highest # in the table is higher than what is stored in the 
    //dataMax variable, set value = dataMax
    if (value>dataMax) {
      dataMax = value;
    }
    //same for dataMin
    if (value<dataMin) {
      dataMin = value;
  }
  noStroke();}
    myCircles = new Circle[numOfMyCircles];
  for(int i = 0; i<myCircles.length; i++){
   myCircles[i] = new Circle(); 
  }
}

void draw() {
  background(255);
  image(mapImage, 0, 0);

  closestDist = MAX_FLOAT;

//count through rows of location table, 
  for (int row = 0; row<rowCount; row++) {
    //assign id values to variable called id
    String id = amountsTable.getRowName(row);
    //get the 2nd and 3rd fields and assign them to
    float x = locationTable.getFloat(id, 1);
    float y = locationTable.getFloat(id, 2);
    //use the drawData function (written below) to position and visualize
    drawData(x, y, id);

  }

//if the closestDist variable does not equal the maximum float variable....
  if (closestDist != MAX_FLOAT) {
    
    //making labels here.
    rectMode(CENTER);
    //getting the length of the current string and storing it in
    // a variable called tw
    float tw = textWidth(closestText);
    fill(200,150,200);
    
    //using tw for the width of my rect label
    //closestTextX and Y variables are generated below in drawData
    rect(closestTextX, closestTextY-4, tw+10, 20);
    fill(50);
    textAlign(CENTER);
    text(closestText, closestTextX, closestTextY);
    
  }
}

//we write this function to visualize our data 
// it takes 3 arguments: x, y and id
void drawData(float x, float y, String id) {
//value variable equals second field in row
  float value = amountsTable.getFloat(id, 1);
  float radius = 0;
//if the value variable holds a float greater than or equal to 0
  if (value>=0) {
    //remap the value to a range between 1.5 and 15
    radius = map(value, 0, dataMax, 1.5, 15); 
    //and make it this color
    fill(1,50,250);
  } else {
    //otherwise, if the number is negative, make it this color.
    radius = map(value, 0, dataMin, 1.5, 15);
     fill(10);

  }


float currentColor = color (50);
int currentMillis = millis();
  
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;
    // do stuff
    fill(currentColor);
    println("counter:", counter);
    counter++;
   if (counter% 1 ==1){
      image(steak,0,0);
            }else{
      ;
    }
  }
  //make a circle at the x and y locations using the radius values assigned above
  ellipseMode(RADIUS);
  ellipse(x, y, radius, radius);

  float d = dist(x, y, mouseX, mouseY);

//if the mouse is hovering over circle, show information as text
  if ((d<radius+2) && (d<closestDist)) {
    closestDist = d;
    //String name = amountsTable.getString(id, 1);
    String nameofLocation = namesTable.getString(id, 1);
    closestText = nameofLocation;
    closestTextX = x;
    closestTextY = y-radius-4;
  }
  }

void mousePressed(){
  myCircles[currentCircle].begin(mouseX,mouseY);
  currentCircle++;
  if(currentCircle>=numOfMyCircles){
   currentCircle = 0; 
  }
}