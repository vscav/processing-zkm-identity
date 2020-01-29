/** Processing Sound library */
import processing.sound.*;

/** Processing font class */
PFont text;
String content = "W R I T I N G\nT H E  H I S T O R Y  O F\nT H E  F U T U R E";

/** Processing graphics and rendering context class */
PGraphics pg;

/** Audio variables (microphone input and sound amplitude) declaration */
AudioIn mic;
Amplitude amp;

/** Stock variable (sound amplitude result will be added to it every sequence) */
float change;

/** Colors declaration and definition */
color c1 = color(0, 0, 255, 30);
color c2 = color(255, 0, 0, 30);
color c3 = color(255, 0, 255, 30);
color c4 = color(0, 255, 0, 30);
color c5 = color(0, 255, 255, 30);
color c6 = color(255, 255, 0, 30);

/** Colors array declaration and definition */
color[] colors  = {  
  c1, c2, c3, c4, c5, c6
};

/** Organic array declaration */
Organic[] organics;

/** Number of organic shapes */
final int SHAPES_COUNT = 110;

/** Logo images path */
final String LOGOS_PATH = "logos/";

/** Image saving possibilities ((10^8)-1) */
final String LOGOS_COUNT = "########";

void setup() {
  /** Size of the canvas (the third parameter specify a P2D renderer) */
  fullScreen();
  
  /** Text initialization */
  text = createFont("assets/CODE-Bold.otf", width/24);
  textFont(text);
  textAlign(LEFT);
  
  /** Change variable initialization */
  change = 0;
  
  /** Create a new Amplitude */
  amp = new Amplitude(this);
  
  /** Microphone input stream creation (which is routed into the Amplitude analyzer) */
  mic = new AudioIn(this, 0);
  /** Define the audio input (microphone input) for the analyzer */
  amp.input(mic);
  
  /** Organics array initialization (which will contain Organic objects) */
  organics = new Organic[SHAPES_COUNT];
  
  /** For loop to fill organics array */
  for (int i = 0; i < SHAPES_COUNT; i++) {
    organics[i] = new Organic(0.08 + 2 * i,width/2.8,height/2, i, i * random(90), colors[floor(random(6))]);
  }
}      

void draw() {
  /** New background (white) every sequence (to hide previous Organic shapes) */
  background(255);
  /** To apply a black background, uncomment the line below */
  //background(13);
  
  /** For loop to animate Organic objects */
  for (int i = 0; i < organics.length; i++) {
      /** Organic class show function is called */
      organics[i].show(change);
  }
  
  /* Text update */
  fill(13);
  /** To apply a white color to the font, uncomment the line below */
  //fill(255);
  
  text(content, width/3, height/2.2);
    
  /** Sound analizing result is added to change variable */
  change += amp.analyze();
  
  if(amp.analyze() > 0.42) {setup();}
  
}

/** mouseClicked function */
/*void mouseClicked() {
  /** Call the main setup function to generate new colors and shapes 
  //setup();
}*/

/** keyPressed function */
void keyPressed() {
  /** Is the space bar the key pressed ? */
  if (keyPressed == true && keyCode == 32) {
    /** Print a success message in the console */
    print("Image has been successfully saved.");
    /** Save the canvas capture (.jpeg) in the adequat folder */
    saveFrame(LOGOS_PATH + "logo-" + LOGOS_COUNT + ".jpeg");
  }
}

/** Organic class */
class Organic {
  /** Organic class parameters declaration */
  int roughness;
  float radius, angle, xpos, ypos; 
  color col;
  /** Organic class constructor */
  Organic (float radius, float xpos, float ypos, int roughness, float angle, color col) {  
    this.radius = radius;
    this.xpos = xpos;
    this.ypos = ypos; 
    this.roughness = roughness;
    this.angle = angle;
    this.col = col;
  } 
  /** Organic class show function */
  void show(float change) { 
    /** No stroke for the circle */
    noStroke();
    /** Fill the shape with the color received as parameter */
    fill(this.col);

    /** Enclose things between push() and pop() functions (so that all transformations within only affect items within) */
    push();
    translate(xpos, ypos);
    rotate(this.angle + change);

    /** Begin a shape based on the vertex points below */
    beginShape();

    /** Creation of vertex points */
    float off = 0;
    for (float i = 0; i < TWO_PI; i += 0.1) {
      float offset = map(noise(off, change), 0, 1, -this.roughness, this.roughness);
      float r = this.radius + offset;
      float x = r * cos(i);
      float y = r * sin(i);
      vertex(x, y);
      off += 0.1;
    }
    /** End (then create the shape) */
    endShape();
    pop();
  }
}