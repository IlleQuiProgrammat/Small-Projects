int NUM_PEOPLE = 1000;
int INFECTION_DISTANCE = 10;
int START_NUM_INFECTED = 5;
int PERSON_SIZE = 5;
int ITERATIONS_PER_CLICK = 5;
int ITERATION_PER_SECOND = 5;
float INFECTION_PROBABILITY = 0.2;
boolean SHOW_INFECTION_RING = true;
int MAX_MOVEMENT_DISTANCE = 20;
boolean VISUALISE = true;
Person[] people = new Person[NUM_PEOPLE];
int infectionCount = START_NUM_INFECTED;
// let counter;
// let jsonOP = {0: START_NUM_INFECTED};
// let d = 0;
// let OP;

class Person {
  public int x;
  public int y;
  public boolean infected;
}

void setup() {
  size(1280, 720);
  for (int i = 0; i < NUM_PEOPLE; i++) {
   people[i] = new Person();
   people[i].x = Math.round(random(0, width));
   people[i].y = Math.round(random(0, height));
   people[i].infected = i < START_NUM_INFECTED;
  }
  // counter = createDiv();
  // op = createDiv();
  frameRate(ITERATION_PER_SECOND);
}

void draw() {
  if (infectionCount != NUM_PEOPLE) {
    runIter();
    if (VISUALISE) {
      background(220);
      for (int i = 0; i < NUM_PEOPLE; i++) {
        fill(255);
        if (people[i].infected) {
          if (SHOW_INFECTION_RING) {
            fill(0,0,0,0);
            circle(people[i].x, people[i].y, INFECTION_DISTANCE + PERSON_SIZE);
          }
          fill(255,0,0);
        }
        circle(people[i].x, people[i].y, PERSON_SIZE);
      }
    }
  }
  // counter.html("<h1>" + infectionCount + "</h1>");
  // op.html("<textarea>" + JSON.stringify(jsonOP) + "</textarea>");
}

void runIter() {
  for (int k = 0; k < ITERATIONS_PER_CLICK; k++) {
    for (int i = 0; i < NUM_PEOPLE; i++) {
      people[i].x = Math.round(min(width, max(0, people[i].x + random(-1 * MAX_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE))));
      people[i].y = Math.round(min(height, max(0, people[i].y + random(-1 * MAX_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE))));
    }
    for (int i = 0; i < NUM_PEOPLE; i++) {
      for (int j = 0; j < NUM_PEOPLE; j++) {
        if (i != j) {
          if (pow(people[i].x - people[j].x, 2) + pow(people[i].y - people[j].y, 2) - 2 * PERSON_SIZE <= pow(INFECTION_DISTANCE, 2)) {
            if ((people[i].infected || people[j].infected) && Math.round(random(1, 1/INFECTION_PROBABILITY)) == 1) {
              if (! (people[i].infected && people[j].infected)) {
                infectionCount += 1;             
              }
              people[i].infected = true;
              people[j].infected = true;
            }
          }
        }
      }
    }
  }
  //jsonOP[++d] = infectionCount;
  println(infectionCount);
}
