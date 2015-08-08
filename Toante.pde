  import processing.serial.*;
import cc.arduino.*;
import processing.video.*;

Arduino arduino;
Movie video;

color off = color(4, 79, 111);
color on = color(84, 145, 158);

int pin_sensor = 2;
int count = 0;
int r = 0;
int movimento = 0; // 0 -> normal, 1 -> vertical, 2->
final int n_frames_movimento = 70;

void setup() {
  size(480, 720);
  
  // Configuração Arduino
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(pin_sensor, Arduino.INPUT);
  
  // Configuração do video
  video = new Movie(this, "toante.mov");
  video.loop();
}

void draw() {
  //background(off);
  //stroke(on);
  pushMatrix();
  if( r > 0 ){
    r -= 1;
    if(movimento == 1){
      scale(-1, 1);
      image(video, -width, 0, width, height);
    } else if (movimento == 2) {
      scale(1, -1);
      image(video, 0, -height, width, height);
    } else {      
      image(video, 0, 0, width, height); 
    }
  } else if (arduino.digitalRead(pin_sensor) == Arduino.LOW){
    r = n_frames_movimento;
    movimento = (movimento + 1)%3; // (0 + 1)%2 = 1, (1+1)%2 = 0
  } else {
    // Não tem movimento. Video normal.
    image(video, 0, 0, width, height); 
  }
  
  rect(420 - pin_sensor * 30, 30, 20, 20);
  popMatrix();
}

void movieEvent(Movie m) {
  m.read();
}

