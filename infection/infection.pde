int NUM_PEOPLE = 10000;
int INFECTION_DISTANCE = 10;
int START_NUM_INFECTED = 5;
int START_NUM_IMMUNE = 5;
int PERSON_SIZE = 5;
float ITERATION_PER_SECOND = 5;
float INFECTION_PROBABILITY = 0.2;
boolean SHOW_INFECTION_RING = true;
int MAX_MOVEMENT_DISTANCE = 20;
int WIDTH = 350;
int HEIGHT = 350;
boolean VISUALISE = true;
Person[] people = new Person[NUM_PEOPLE];
int infectionCount = START_NUM_INFECTED;
// let counter;
// let jsonOP = {0: START_NUM_INFECTED};
int d = 0;
// let OP;

class Person {
  public int x;
  public int y;
  public boolean infected;
  public boolean immune;
  public int infectedDate;
  public int infectionPeriod;
}

int MIN_INFECTED_DAYS = 4;
int MAX_INFECTED_DAYS = 15;
int infectionCurve(float r) {
  return Math.round(map(r, 1, 1/INFECTION_PROBABILITY, MIN_INFECTED_DAYS, MAX_INFECTED_DAYS));
}

void setup() {
  if (VISUALISE) { surface.setSize(WIDTH, HEIGHT); }
  for (int i = 0; i < NUM_PEOPLE; i++) {
   people[i] = new Person();
   people[i].x = Math.round(random(0, WIDTH));
   people[i].y = Math.round(random(0, HEIGHT));
   people[i].infected = i < START_NUM_INFECTED;
   people[i].immune = i >= NUM_PEOPLE - START_NUM_IMMUNE;
   people[i].infectedDate = i < START_NUM_INFECTED ? 0 : 1000000000;
   people[i].infectionPeriod = infectionCurve(random(1, 1/INFECTION_PROBABILITY));
   println(people[i].infectedDate + people[i].infectionPeriod);
  }
  // counter = createDiv();
  // op = createDiv();
  frameRate(ITERATION_PER_SECOND);
}

void draw() {
  if (/*infectionCount != NUM_PEOPLE ||*/ infectionCount != 0) {
    runIter();
    if (VISUALISE) {
      background(220);
      for (int i = 0; i < NUM_PEOPLE; i++) {
        fill(255);
        if (people[i].immune) {
          fill(0,0,255);
        } else if (people[i].infected) {
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
  for (int i = 0; i < NUM_PEOPLE; i++) {
    people[i].x = Math.round(min(WIDTH, max(0, people[i].x + random(-1 * MAX_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE))));
    people[i].y = Math.round(min(HEIGHT, max(0, people[i].y + random(-1 * MAX_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE))));
  }
  for (int i = 0; i < NUM_PEOPLE; i++) {
   if (!people[i].immune) {
     if (people[i].infectedDate + people[i].infectionPeriod <= d) {
       people[i].immune = true;
       infectionCount -= 1;
     }
      for (int j = 0; j < NUM_PEOPLE; j++) {
        if (!people[j].immune) {
          if (i != j) {
            if (pow(people[i].x - people[j].x, 2) + pow(people[i].y - people[j].y, 2) - 2 * PERSON_SIZE <= pow(INFECTION_DISTANCE, 2)) {
              if ((people[i].infected || people[j].infected) && Math.round(random(1, 1/INFECTION_PROBABILITY)) == 1) {
                if (!people[i].infected) {
                  people[i].infected = true;
                  infectionCount += 1;
                  people[i].infectedDate = d;
                } else if (!people[i].infected) {
                  people[j].infected = true;
                  infectionCount += 1; 
                  people[j].infectedDate = d;
                }
              }
            }
          }
        }
      }
    }
  }
  d++;
  println(infectionCount);
}
