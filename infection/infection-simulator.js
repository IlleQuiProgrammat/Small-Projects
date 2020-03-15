const NUM_PEOPLE = 100;
const INFECTION_DISTANCE = 10;
const START_NUM_INFECTED = 5;
const PERSON_SIZE = 5;
const ITERATIONS_PER_CLICK = 5;
const ITERATION_PER_SECOND = 5;
const INFECTION_PROBABILITY = 0.2;
const SHOW_INFECTION_RING = true;
const MAX_MOVEMENT_DISTANCE = 20;
const VISUALISE = true;
let people = [];
let infectionCount = START_NUM_INFECTED;
let counter;
let jsonOP = {0: START_NUM_INFECTED};
let d = 0;
let OP;

function setup() {
  createCanvas(400, 400);
  for (let i = 0; i < NUM_PEOPLE; i++) {
   people.push({
     x: random(0, width),
     y: random(0, height),
     infected: i < START_NUM_INFECTED
   });
  }
  people[0].infected = true;
  counter = createDiv();
  op = createDiv();
  frameRate(ITERATION_PER_SECOND);
}

function draw() {
  if (infectionCount != NUM_PEOPLE) {
    runIter();
    if (VISUALISE) {
      background(220);
      for (let i = 0; i < NUM_PEOPLE; i++) {
        fill(255)
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
  counter.html("<h1>" + infectionCount + "</h1>");
  op.html("<textarea>" + JSON.stringify(jsonOP) + "</textarea>");
}

function runIter() {
  for (let k = 0; k < ITERATIONS_PER_CLICK; k++) {
    for (let i = 0; i < NUM_PEOPLE; i++) {
      people[i].x = min(width, max(0, people[i].x + random(-1 * MAX_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE)));
      people[i].y = min(height, max(0, people[i].y + random(-1 * MAX_MOVEMENT_DISTANCE, MAX_MOVEMENT_DISTANCE)));
    }
    for (let i = 0; i < NUM_PEOPLE; i++) {
      for (let j = 0; j < NUM_PEOPLE; j++) {
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
  jsonOP[++d] = infectionCount;
}