import guicomponents.*;

GButton btnResetRotScale;
GPanel pnl;
GHorzSlider sx,sy, sz;
GVertSlider mscale;
GOptionGroup optgState;
GOption[] optStates;
GLabel lblFps;
GCheckbox cbxWire;

PMatrix3D dmat, dmatOrg;

int rotX = 90, rotY = 0, rotZ = 90;
float initZoom = 5.5f, zoom;
float interpolate = 0.1;
boolean showWire = false;

// Remember last slider values
int lastSx, lastSy, lastSz;
int currSx, currSy, currSz;

// Used to remember PGraphics3D transformation matrix
PGraphics3D g3;

MD2_Loader loader;
MD2_Model model1, model2;

long counter = 0;

void setup() {
  size(600,520,P3D);

 zoom = initZoom;

  // The matrix that will be used for rendering the model  
  dmat = new PMatrix3D((PMatrix3D)getMatrix()); // copy the initial matrix
  dmat.translate(width * 0.5f, height * 0.6f);
  
  dmat.rotateX(radians(rotX)); //esta es la oriantacion que toma para que se vea bien
  dmat.rotateY(radians(rotY));
  dmat.rotateZ(radians(rotZ));
  
  
  
  // Make a copy so we can reset the rotations to init values
  //dmatOrg = new PMatrix3D(dmat);

  // Create a loader to load MD2 model
  loader = new MD2_Loader(this);
  model1 = loader.loadModel("models/ogro/ogro.md2", "models/ogro/ogrobase.jpg");
  model2 = loader.loadModel("models/ogro/weapon.md2", "models/ogro/weapon.jpg");

  loader = null; // loader no lomger required so get rid of it to release RAM

  // Dynamically create option buttons for model states

  if(model1 != null) model1.setState(0);
  if(model2 != null) model2.setState(0);

  // Remember PGraphics3D transformation matrix
  g3 = (PGraphics3D)g;

  registerPre(this);
}

void pre(){
  interpolate = PApplet.constrain(3.1/(frameRate + 0.01), 0.001, 0.8);
  if(model1 != null) 
    model1.update(interpolate);
  if(model2 != null)
    model2.update(interpolate);

 // lblFps.setText(""+frameRate + " fps ");
}

void draw() {
  pushMatrix();
  setMatrix(dmat);
  scale(zoom);
  background(255,255,255);
  if(showWire){
    stroke(64,128,64);
    strokeWeight(1);
    noFill();
  }
  else {
    noStroke();
    fill(128);
  }
  if(model1 != null) model1.render();
  if(model2 != null) model2.render();
  G4P.draw();
  popMatrix();

  
}






