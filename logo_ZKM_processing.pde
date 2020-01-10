/** Processing Sound library */
import processing.sound.*;

/** Processing font class */
PFont font;

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

/** Kinetic text declaration */
Kinetic text;

/** Number of tiles on the X and Y axes */
final int TILES_X = 50;
final int TILES_Y = 8;

/** Logo images path */
final String LOGOS_PATH = "logos/";

/** Image saving possibilities ((10^8)-1) */
final String LOGOS_COUNT = "########";

void setup() {
  /** Font creation (place in the main directory) */
  font = createFont("assets/Hind-SemiBold.ttf", 600/18);
  /** Create a new reference of Kinetic text object */
  text = new Kinetic();
  /** Size of the canvas (the third parameter specify a P2D renderer) */
  size(600, 600, P2D);
  /** Create a new PGraphics object */
  pg = createGraphics(600, 600, P2D);
  /** Canvas background color */
  background(13, 13, 13);
  
  /** Change variable initialization */
  change = 0;
  
  /** Create a new Amplitude */
  amp = new Amplitude(this);
  
  /** Microphone input stream creation (which is routed into the Amplitude analyzer) */
  mic = new AudioIn(this, 0);
  /** Start capturing the input stream and route it to the audio output */
  mic.play();
  /** Define the audio input (microphone input) for the analyzer */
  amp.input(mic);
  
  /** Organics array initialization (which will contain Organic objects) */
  organics = new Organic[SHAPES_COUNT];
  
  /** For loop to fill organics array */
  for (int i = 0; i < SHAPES_COUNT; i++) {
    organics[i] = new Organic(0.1 + 1 * i, 180, 300, i, i * random(90), colors[floor(random(6))]);
  }
}      

void draw() {
  /** New background every sequence (to hide previous Organic shapes) */
  background(13, 13, 13);
  
  /** For loop to animate Organic objects */
  for (int i = 0; i < organics.length; i++) {
      /** Organic class show function is called */
      organics[i].show(change);
  }

  /** PGraphics initialization and specification */
  pg.beginDraw();
  pg.background(0, 0, 0, 0);
  pg.fill(255);
  pg.textFont(font);
  pg.translate(350, 600/2);
  pg.textAlign(LEFT, CENTER);
  /** Text definition */
  pg.text("Writing\nthe history\nof the future.", 0, 0);
  pg.endDraw();

  /** Animation of Kinetic text */
  text.anim();

  /** Sound analizing result is added to change variable */
  change += amp.analyze();
}

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
  int xpos, ypos, roughness;
  float radius, angle; 
  color col;
  /** Organic class constructor */
  Organic (float radius, int xpos, int ypos, int roughness, float angle, color col) {  
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

/** Kinetic class */
class Kinetic {
  /** Kinetic class anim function */
  void anim(){
    int tileW = int(600/TILES_X);
    int tileH = int(600/TILES_Y);

    for (int y = 0; y < TILES_Y; y++) {
      for (int x = 0; x < TILES_X; x++) {
        /** Warp */
        int wave = int(sin(frameCount * 0.05 + ( x * y ) * 0.1) * 3.5);
        /** Uncomment the line below (and comment the line above) to avoid text effect */
        //int wave = 0;
      
        /** Source (position and dimension) */
        int sx = x*tileW + wave;
        int sy = (int)y*tileH + wave;
        int sw = tileW;
        int sh = tileH;

        /** Destination (position and dimension) */
        int dx = x*tileW;
        int dy = y*tileH;
        int dw = tileW;
        int dh = tileH;
      
        /** Apply new destination and new dimension */
        copy(pg, sx, sy, sw, sh, dx, dy, dw, dh);
      }
    }
  }
}
