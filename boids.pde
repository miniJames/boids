import peasy.*;

PeasyCam cam;
ArrayList<car> cars;
int radius = 2;

void setup(){
  cars =new ArrayList<car>();
  size(1000, 1000,P3D);
  //fullScreen(P3D);
  for (int i = 0; i < 500; i++) {
    car c;
    c = new car(random(radius, width - radius), random(radius, height - 10),random(radius, height - 10), radius);
    // c.vel = createVector(random(-c.maxSpeed, c.maxSpeed), random(-c.maxSpeed, c.maxSpeed))
    cars.add(c);
  }
  cam = new PeasyCam(this,100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(5000);
  
}

void draw(){
  background(0);
  noStroke();
  for(car c : cars){
    c.show();
    PVector heading = new PVector();
    PVector position = new PVector();
    float r=0,g=0,b=0;
    // Repel each other.
    int locals = 0;
    for (int i = 0; i < cars.size(); i++) {
      car c2 = cars.get(i);
      if (c2 == c) {} else {
        float dist = PVector.dist(c2.loc, c.loc);

        if (abs(dist) < c.w + 25) {

          c2.applyForce(c2.repel(c.loc));
          c.applyForce(c.repel(c2.loc));
        }
        if (abs(dist) < 50) {
          heading.add(c2.vel);
          position.add(c2.loc);
          locals++;
          r+=red(c2.col);
          g+=green(c2.col);
          b+=blue(c2.col);
          // console.log(red(c2.col))
        }

      }

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
      stroke(255);
      
      //c.col= color(r/locals, g/locals,b/locals);
    } else {
      c.col = c.orig;
    }
    
    r=0;
    g=0;
    b=0;
    c.update();
    line(c.loc.x, c.loc.y, c.loc.z, c.loc.x+c.vel.x,c.loc.y+ c.vel.y,c.loc.z+ c.vel.z);
  }
}
class car{
  PVector loc, vel, acc;
  float maxSpeed;
  float maxForce;
  color col, orig;
  float w;
  
  car(float x, float y, float z, int wd){
      loc = new PVector(x,y,z);
      vel = new PVector();
      acc = new PVector();
      
      w = wd;
      maxSpeed = random(2.9,3.25);
      maxForce = random(0.10,1);
      col = color(random(255), random(255),random(255));
      orig = col;
      
  }
  void applyForce(PVector f){
    acc.add(f);
  }
  void show(){
    fill(col);
    stroke(col);
    pushMatrix();
    translate(loc.x, loc.y, loc.z);
    sphere(w);
    popMatrix();
  }
  
  void update(){
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
    if (this.loc.z > height) {
      this.loc.z = this.w;
    }
        if (this.loc.z < this.w) {
      this.loc.z = height - this.w;
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
