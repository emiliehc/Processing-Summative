/**
Frank Chen
25OCT18
Processing Summative
**/

// autogen balls
class Ball {
  // declaration
  PVector pos; // position
  PVector vel; // velocity
  PVector acc; // acceleration
  PVector Fnet; // net force
  float m = 10; // mass, default 10
  PVector Fg = new PVector(0 * m, 0.1 * m); // gravitational force
  PVector Fair; // air resistance
  float Kair = 0.0002; // air resistance parameter in this simulation
  PVector Fk; // kinetic frition
  float muk = 0.02; // coefficient of kinetic friction
  PVector FN = new PVector(- Fg.x, - Fg.y); // normal force
  
  int count = 0;  // for dianostic purposes
  
  
  Ball () {
    // declaration
    pos = new PVector(random(0, 1000), random(100, 250));
    vel = new PVector(random(-10, 10), random(-7, 7));
    acc = new PVector(0, 0);
  }
  
  void update() {
    // debug
    //println(pos.x);
    if (pos.y > 300) {
      println("Warning");
      println("Below the horizon");
      println(pos.y);
    }
    
    // update the balls
    // determine their characteristics
    // bounce when touching the bottom
    if ((pos.y > 290) && (vel.y > 0)) {
      vel.y = - 0.95 * vel.y;
      pos.y = 290;
    }
    // Out of bound
    // right bound
    if ((pos.x > 1000) && (vel.x > 0)) {
      vel.x = -  0.8 * vel.x;
    }
    // left bound
    if ((pos.x < 0) && (vel.x < 0)) {
      vel.x = - 0.8 * vel.x;
    }
    // Air resistance
    Fair = new PVector(- Kair * pow(vel.x, 2) * sign(vel.x), - Kair * pow(vel.y, 2) * sign(vel.y));
    // kinetic friction -- while on the ground
    // detect if the ball is on the ground
    if (pos.y > 285) {
      // for diagnostic
      //count++;
      //println(count);
      // the direction of friction is opposite to the direction of the motion
      Fk = new PVector(sign(vel.x) * muk * FN.y, 0);
    } else {
      Fk = new PVector(0, 0);
    }
    
    // determine the net force
    Fnet = new PVector(Fg.x + Fair.x + Fk.x, Fg.y + Fair.y + Fk.y);
    
    acc = new PVector(Fnet.x / m, Fnet.y / m);   // Using Newton's second law to determine the acceleration
    vel.add(acc); // add the acceleration to the velocity
    pos.add(vel); // add the velocity to the position
    
  }
  
  void show() {
    // draw the balls
    noStroke();
    fill(0);
    image(imgBall, pos.x, pos.y, 30, 30);
  }
}

// determine the sign of a number
int sign(float num) {
  if (num != 0) {
    // if the number is not 0
    return int(num / abs(num));
  } else {
    // return 0 if the number is 0
    return 0;
  }
}


