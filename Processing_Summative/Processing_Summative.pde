/**
 Frank Chen
 25OCT18
 Processing Summative
 
 Click on the TUTORIALS button on the top right corner for tips and tricks. 
 
 List of elements / shapes / colors used in this program:
 1. button, white, mouse over turns it gray
 2. ground / grass, green during the day, dark green at night
 3. path, changing color depending on the time
 4. balls, with all of the following factors taken into account
 a) position
 b) velocity
 c) acceleration
 d) gravity
 e) mass
 f) air resistance
 g) kinetic friction (on the ground)
 h) bouncing with energy loss
 
 The balls are generated with random positions and velocities upon startup
 The balls can be dragged, dropped, and thrown with the mouse. 
 MOVE THE BALLS WITH CARE
 Balls being thrown effect is done by calculating the instantaneous velocity of the cursor upon releasing the ball. 
 Collision effect is achieved by swapping the balls' velocities, with ball overlap prevention. 
 
 5. Clouds, changing color depending on the time of day
 6. Moon, with moon color
 7. flying bird over the screen
 8. automatic time advancement
 9. stars at night
 **/

// import
import static javax.swing.JOptionPane.*;

// declarations
int timeOfTheDay = 0;
PImage imgBall;
PImage imgBird;
int numberOfBalls = 3;
color btnInfoColor = (255);
float mouseX0 = 0;
float mouseY0 = 0;
float VinstX = 0;
float VinstY = 0;
int currentFrame = 0;

// create balls in a array
Ball[] balls = new Ball[numberOfBalls];

void setup() {
  size(1000, 500); // set initial size of the canvas
  noCursor(); // hide the default cursor
  // initialize the balls
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }
  //frameRate(10000);
  // setup the image
  imgBall = loadImage("Basketball.png");
  imgBird = loadImage("bird.gif");
}

void draw() {
  // draw the background
  // depending on the time of the day
  switch(timeOfTheDay) {
  case 0:
    // day
    backgroundDay();
    // draw sun
    fill(#FFFC95);
    ellipse(500, 80, 50, 50);
    drawGroundDay();
    break;
  case 1:
    // dusk
    backgroundDawnDusk();
    // draw sun
    fill(#FFB905);
    ellipse(850, 240, 50, 50);
    drawGroundNight();
    break;
  case 2:
    // night
    backgroundNight();
    // draw the moon
    fill(#FFF946);
    beginShape();
    vertex(500, 60);
    bezierVertex(580, 60, 580, 120, 500, 120);
    bezierVertex(550, 115, 550, 65, 500, 60);
    endShape();
    drawGroundNight();
    break;
  case 3:
    // dawn
    backgroundDawnDusk();
    // draw sun
    fill(#FFB905);
    ellipse(150, 280, 50, 50);
    drawGroundNight();
    drawGroundNight();
    break;
  }

  //println(int(millis() / 1000));

  // automatic time advancement
  if (frameCount % 500 == 0) {

    timeOfTheDay++;
    timeOfTheDay = (timeOfTheDay + 4) % 4;
  }


  // code
  Vinst();

  // objects start
  // layer bottom
  drawPath();
  // layer 1
  // draw the bird
  drawBird();

  // draw the balls
  for (int i = 0; i < balls.length; i++) {
    balls[i].update();
    // detect collision
    detectCollision();

    balls[i].show();
  }
  //ballPositionMonitor();


  // layer 2


  // layer 3


  // layer 4



  // layer top
  // info button
  btnInfo();

  // draw the cursor
  drawCustomCursor();
}

// mouseClicked detection
void mouseClicked() {
  // if it is on the tutorial button
  if ((mouseX > 900) && (mouseX < 1000) && (mouseY > 0) && (mouseY < 40)) {
    // display the tutorial
    showMessageDialog(null, "Tutorials\n1. Right/left arrow: change the current time.\nManual time change is not needed since the \ntime automatically advances every few \nseconds. \n2. Long press the left button of the mouse to \nenable dragging. Keep the left button pressed \nand put the cursor on a ball and experiment \nwith the effects. Move the balls with extreme \ncare. Fast change in the cursor's speed and/or \nvelocity may result in the ball unexpectedly \ndropping. Handling performance improves with \npractice.\n\n", "Tutorials", INFORMATION_MESSAGE);
  }
}

// key pressing detection
void keyPressed() {
  // right arrow makes the time go forward and the left arrow makes the time go back
  if (keyCode == RIGHT) {
    timeOfTheDay++;
    timeOfTheDay = timeOfTheDay % 4;
  } 
  else if (keyCode == LEFT) {
    timeOfTheDay--;
    timeOfTheDay = (timeOfTheDay + 4) % 4;
  }
}

// mouse dragging detection
void mouseDragged() {
  // loop through every ball
  // detect if the mouse is dragging the balls
  for (int i = 0; i < balls.length; i++) {
    if ((mouseX > balls[i].pos.x) &&  (mouseX < balls[i].pos.x + 30) && (mouseY > balls[i].pos.y) && (mouseY < balls[i].pos.y + 30)) {
      balls[i].pos = new PVector(mouseX - 15, mouseY - 15);
      // redetermine its velocity

      balls[i].vel = new PVector(VinstX, VinstY);
    }
  }
}

void Vinst() {
  // determine the (almost) instantaneous velocity of the mouse
  // the X component
  VinstX = (mouseX - mouseX0) / (frameCount - currentFrame);
  // the Y component
  VinstY = (mouseY - mouseY0) / (frameCount - currentFrame);
  // make these two variables store the current mouseX and mouseY coordinates
  mouseX0 = mouseX;
  mouseY0 = mouseY;
  // record the current frame
  currentFrame = frameCount;
  //println(VinstX, VinstY);
}

// draw a bird
void drawBird() {
  // draw the bird
  image(imgBird, (frameCount * 2) % 1000 - 40, 80, 80, 80);
}

// draw little path
void drawPath() {
  noStroke();
  // test if it is the day
  if (timeOfTheDay == 0) {
    fill(#FFD70D);// day mode
  } 
  else {
    fill(#815600); // night mode
  }

  // draw the path in the center of the field
  beginShape();
  vertex(400, 500);
  bezierVertex(600, 450, 330, 270, 500, 200);
  vertex(550, 205);
  bezierVertex(350, 240, 600, 450, 490, 500);
  vertex(400, 500);
  endShape();
}

// info button
void btnInfo() {
  // draw the button
  // test if the mouse is over the button
  if ((mouseX > 900) && (mouseX < 1000) && (mouseY > 0) && (mouseY < 40)) {
    btnInfoColor = (128); // gray
  } 
  else {
    btnInfoColor = (255); // white
  }
  fill(btnInfoColor);
  stroke(0);
  rect(900, 0, 100, 40);
  fill(0);
  textSize(20);
  // text on button
  text("Tutorials", 910, 27);
}

// custom cursor
void drawCustomCursor() {
  // magenta color cursor
  fill(#D1007E);
  stroke(#D1007E);
  // point in the middle
  ellipse(mouseX, mouseY, 1, 1);
  // for strokes forming an x shape
  line(mouseX - 4, mouseY - 4, mouseX - 30, mouseY - 22);
  line(mouseX - 4, mouseY + 4, mouseX - 30, mouseY + 22);
  line(mouseX + 4, mouseY - 4, mouseX + 30, mouseY - 22);
  line(mouseX + 4, mouseY + 4, mouseX + 30, mouseY + 22);
}

// daylight background
void backgroundDay() {
  for (int y = 0; y <= height; y++) {
    // blue to white gradient
    stroke(lerpColor(#2EB8FF, #FFFFFF, map(y, 0, height, 0, 1)));
    line(0, y, width, y);
  }

  // clouds
  fill(255);  // fill white
  drawCloud(50, 50);
  drawCloud(130, 110);
  drawCloud(300, 120);
  drawCloud(350, 20);
  drawCloud(500, 30);
  drawCloud(620, 100);
  drawCloud(810, 40);
  drawCloud(900, 125);
}

// dawn and dusk background
void backgroundDawnDusk() {
  for (int y = 0; y <= height; y++) {
    // dark blue to orange - yellow
    stroke(lerpColor(#0215D1, #FFC812, map(y, 0, height * 0.75, 0, 1)));
    line(0, y, width, y);
  }
  // clouds
  fill(128);  // fill gray
  drawCloud(50, 50);
  drawCloud(130, 110);
  drawCloud(300, 120);
  drawCloud(350, 20);
  drawCloud(500, 30);
  drawCloud(620, 100);
  drawCloud(810, 40);
  drawCloud(900, 125);
}


// night background
void backgroundNight() {
  // night sky
  background(0);
  // draw stars
  drawStars();

  noStroke();
  // clouds
  fill(40);  // fill dark gray
  drawCloud(50, 50);
  drawCloud(130, 110);

  drawCloud(350, 20);
  drawCloud(500, 30);

  drawCloud(810, 40);
  drawCloud(900, 125);
}


// ground
// day
void drawGroundDay() {
  // draw a curve along the screen as the horizon
  // fill and stroke green
  stroke(#0FFF21);
  fill(#0FFF21);
  curveTightness(-2);  // make the curve negatively tight / more smooth
  beginShape();
  vertex(0, 500);
  vertex(0, 300);
  curveVertex(250, 300);
  curveVertex(250, 300);
  curveVertex(500, 200);
  curveVertex(750, 250);
  vertex(1000, 250);
  vertex(1000, 500);
  endShape();
}

// draw stars
void drawStars() {
  // draw random white ellipses on the screen
  // loop through points at the upper part of the canvas
  noStroke();
  fill(255);
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (int(random(0, 10000)) == 0) {
        ellipse(i, j, 3, 3);
      }
    }
  }
}



// night
void drawGroundNight() {
  // draw a curve along the screen as the horizon
  // fill and stroke green
  stroke(#007108);
  fill(#007108);
  curveTightness(-2);  // make the curve negatively tight / more smooth
  beginShape();
  vertex(0, 500);
  vertex(0, 300);
  curveVertex(250, 300);
  curveVertex(250, 300);
  curveVertex(500, 200);
  curveVertex(750, 250);
  vertex(1000, 250);
  vertex(1000, 500);
  endShape();
}

// clouds
void drawCloud(int x, int y) {
  curveTightness(0);  // reset the tightness of the curve to 0
  noStroke();  // no stroke for the clouds
  beginShape();
  vertex(x, y);
  curveVertex(x, y);
  curveVertex(x + 5, y - 10);
  curveVertex(x + 20, y - 20);
  curveVertex(x + 35, y - 30);
  curveVertex(x + 50, y - 20);
  curveVertex(x + 60, y - 25);
  curveVertex(x + 80, y - 30);
  curveVertex(x + 100, y - 5);
  curveVertex(x + 100, y);
  curveVertex(x + 80, y + 10);
  curveVertex(x + 60, y + 12);
  curveVertex(x + 40, y + 20);
  curveVertex(x + 20, y + 10);
  curveVertex(x, y + 5);
  curveVertex(x, y);
  endShape();
}




// detect collision
void detectCollision() {
  for (int i = 0; i < balls.length - 1; i++) {
    for (int j = i + 1; j < balls.length; j++) {
      // print the distances between every two balls
      //println("Distance: ball #" + i + "and #" + j + ": " + dist(balls[i].pos.x, balls[i].pos.y, balls[j].pos.x, balls[j].pos.y));
      // detect collision

      // if the distance between the center of the balls is less than twice the radius
      // then flip both the horizontal component and the vertical component of their velocities
      if ((int(dist(balls[i].pos.x, balls[i].pos.y, balls[j].pos.x, balls[j].pos.y)) <= 30) && (int(dist(balls[i].pos.x, balls[i].pos.y, balls[j].pos.x, balls[j].pos.y)) >= 22)) {
        //println(frameCount);
        //balls[i].vel.x = - balls[i].vel.x;
        //balls[i].vel.y = - balls[i].vel.y;
        //balls[j].vel.x = - balls[j].vel.x;
        //balls[j].vel.y = - balls[j].vel.y;
        // transfer their energies to each other
        //println(balls[i].vel);
        //println(balls[j].vel);
        PVector temp;
        temp = balls[i].vel;
        balls[i].vel = balls[j].vel;
        balls[j].vel = temp;
        //println(balls[i].vel);
        //println(balls[j].vel);
      }
      // detect position validity
      // if their distance is less than 22
      if (int(dist(balls[i].pos.x, balls[i].pos.y, balls[j].pos.x, balls[j].pos.y)) < 22) {
        // make one of the balls higher
        balls[i].pos.y -= 10;
      }
    }
  }
}


// monitoring the positions of the balls
void ballPositionMonitor() {
  // go through every single ball
  for (int i = 0; i < balls.length; i++ ) {
    // print the balls' velocities and positions
    println("Position: ball #" + i + ": [" + balls[i].pos.x + ", " + balls[i].pos.y + "]");
    println("Velocity: ball #" + i + ": [" + balls[i].vel.x + ", " + balls[i].vel.y + "]");
  }
}

