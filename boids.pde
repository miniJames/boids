ArrayList<car> cars;
ArrayList<obstacle> obstacles;

int radius = 2;

void setup() {
  cars =new ArrayList<car>();
  size(1000, 1000, P2D);
  //fullScreen(P2D);
  for (int i = 0; i < 1000; i++) {
    car c;
    c = new car(random(radius, width - radius), random(radius, height - 10), radius);
    // c.vel = createVector(random(-c.maxSpeed, c.maxSpeed), random(-c.maxSpeed, c.maxSpeed))
    cars.add(c);
  }
  obstacles =new ArrayList<obstacle>();

  for (int i=0; i<10; i++) {
    obstacles.add(new obstacle(floor(random(width)), floor(random(height))));
  }
}
void mouseClicked() {
  car c;
  for(int n = 0 ; n < 10;n++){
    c = new car(mouseX + random(-5,5), mouseY + random(-5,5), radius);    
 
  
  cars.add(c); }
}
void draw() {
  background(0);
  noStroke();
  for (obstacle o : obstacles) {
    o.show();
    fill(0);
    circle(o.loc.x, o.loc.y, 3);
  }
  for (car c : cars) {
    c.show();
    for (obstacle o : obstacles) {
      //if(!c.done){
      if (c.loc.dist(o.loc) < (o.r + c.w) + 30) {
      //  c.vel.mult(-1);
      //  c.col=color(255, 0, 0); 
      //  println("HIT:");
      //  //if(c.vel.x == 0 && c.vel.y == 0){
      //  //  c.vel= PVector.random2D();
      //  //}
      //  c.done = true;
      //} else if (c.loc.dist(o.loc) < (o.r + c.w) + 30) {
      //  println("Close:");
      //  c.col=color(255, 0, 0);  
        c.applyForce(c.repel(new PVector(o.loc.x, o.loc.y)));
        c.applyForce(c.repel(new PVector(o.loc.x, o.loc.y)));
        c.applyForce(c.repel(new PVector(o.loc.x, o.loc.y)));
        c.applyForce(c.repel(new PVector(o.loc.x, o.loc.y)));
        c.applyForce(c.repel(new PVector(o.loc.x, o.loc.y)));
        c.done = true;
      } else {
      //  c.col=color(0, 255, 0);
        c.done = false;
      }
    }
  //}
    PVector heading = new PVector();
    PVector position = new PVector();
    float r=0, g=0, b=0;



    // Repel each other.
    int locals = 0;
    for (int i = 0; i < cars.size(); i++) {
      //if (!c.done) {
        
        car c2 = cars.get(i);
        if (c2 == c) {
        } else {
          float dist = PVector.dist(c2.loc, c.loc);

          if (abs(dist) < c.w + 3) {

            c2.applyForce(c2.repel(c.loc));
            c.applyForce(c.repel(c2.loc));
          }
          if (abs(dist) < 15) {
            heading.add(c2.vel);
            position.add(c2.loc);
            locals++;
            r+=red(c2.col);
            g+=green(c2.col);
            b+=blue(c2.col);
            // console.log(red(c2.col))
          }
        }
      //}
    }
    if (locals > 0) {
      heading = PVector.div(heading, locals);
      heading.normalize();
      heading.mult(c.maxSpeed);
      // console.log(heading)
      position = PVector.div(position, locals);


      PVector steer = PVector.sub(heading, c.vel);

      c.applyForce(steer);

      c.applyForce(c.seek(position));
      //c.col= color(r/locals, g/locals,b/locals);
    } else {
      c.col = c.orig;
    }
    r=0;
    g=0;
    b=0;
    c.update();
  }
}

class obstacle {
  PVector loc;
  int r;

  obstacle(int locx, int locy) {
    loc = new PVector(locx, locy);
    r =floor( random(0, height /10));
  }
  void show() {
    pushMatrix();
    translate(loc.x, loc.y);
    fill(255, 128, 0);

    circle(0, 0, r*2);
    popMatrix();
  }
}

class car {
  PVector loc, vel, acc;
  float maxSpeed;
  float maxForce;
  color col, orig;
  float w;
  boolean done;
  car(float x, float y, int wd) {
    loc = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
    done = false;
    w = wd;
    maxSpeed = random(0.9, 1.25);
    maxForce = random(0.010, 0.1);
    col = color(random(255), random(255), random(255));
    orig = col;
  }
  void applyForce(PVector f) {
    acc.add(f);
  }
  void show() {
    fill(col);
    stroke(col);
    circle(loc.x, loc.y, w);
  }

  void update() {
    checkEdges();
    vel.add(acc);
    vel.limit(maxSpeed);
    loc.add(vel);
    acc.mult(0);
  }

  void  checkEdges() {
    if (this.loc.x < this.w) {
      this.loc.x = width - this.w;
    }
    if (this.loc.y < this.w) {
      this.loc.y = height - this.w;
    }
    if (this.loc.x > width) {
      this.loc.x = this.w;
    }
    if (this.loc.y > height) {
      this.loc.y = this.w;
    }
  }


  PVector seek(PVector t) {
    PVector desired = PVector.sub(t, this.loc);
    desired.normalize();
    desired.mult(this.maxSpeed);

    PVector steer = PVector.sub(desired, this.vel);
    steer.normalize();
    steer.limit(this.maxForce);
    return steer;
  }
  PVector repel(PVector t) {
    PVector desired = PVector.sub(t, this.loc);
    desired.normalize();
    desired.mult(-this.maxSpeed);

    PVector steer = PVector.sub(desired, this.vel);
    steer.limit(this.maxForce);
    return steer;
  }
}
