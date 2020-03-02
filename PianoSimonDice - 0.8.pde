import ddf.minim.*;           // Libreria para el reproductor de sonidos
import processing.serial.*;   // Libreria para conexion por puerto serie


// Instanciacion de objetos necesarios para recibir señales y reproducir sonidos
Minim minim;
Serial serialCon;
AudioPlayer[] keys;
int val;      // Datos que entran del puerto serial


// Inicializacion de variables para el juego de Simon dice
int [] simonSentence = new int[32];
int positionInSentence = 0;
int currentLengthOfTheSentence = 0;

int talkTime = 420;
int timeOut = 0;
boolean isSimonsTurn = true;
boolean isWrong = false;

void setup() {
  size(600,600);
  
  //Conexion con puerto serie
  //String portName = Serial.list()[0];
  //serialCon = new Serial(this, portName, 115200);
  
  // Reproductor de sonidos
  minim=new Minim(this);
  
  // Definimos 8 sonidos para las teclas del piano gigante,
  // y un noveno sonido para el tono de "error"
  keys=new AudioPlayer[9];
  
  // En este caso pusimos una escala de do mayor
  keys[0]=minim.loadFile("c3.wav");
  keys[1]=minim.loadFile("d3.wav");
  keys[2]=minim.loadFile("e3.wav");
  keys[3]=minim.loadFile("f3.wav");
  keys[4]=minim.loadFile("g3.wav");
  keys[5]=minim.loadFile("a3.wav");
  keys[6]=minim.loadFile("b3.wav");
  keys[7]=minim.loadFile("c4.wav");
  keys[8]=minim.loadFile("error.wav");
  
  // Arrancamos el juego
  textSize(40);
  textAlign(CENTER, CENTER);
  simonStartsNewGame();
  }

//-------------------------------------------------------------------

void draw(){
  
  // Inicializamos el valor de la tecla presionada
  val=0;

  // Nos fijamos si llegaron datos de la Arduino
  //if (serialCon.available()>0) { 
  //  val = serialCon.read();
  //}
  
  if(isSimonsTurn) simonSays();
  
  background(255);             
  
  if(isSimonsTurn) {
     if(currentLengthOfTheSentence == 0) text("Simon Starts", width/2, height/2); 
     else                                text("Simons Turn", width/2, height/2); 
  }
  else {
     text("Your Turn", width/2, height/2);
  }
  
  //if(val>=1){
  //  keys[val-1].rewind();
  //  keys[val-1].play();
  //}
}

//---------------------------------------------------------------------------

void keyPressed(){
  int num= keyCode-49;
  println(num);
  
  // Esto tiene que funcionar sólo en el turno del jugador
  if(isSimonsTurn == false) {
    
    // Espera una entrada válida
    if( num>=0 && num<=7 ){
      
       // Compara la tecla que tocamos con la que teníamos que tocar
       if(simonSentence[positionInSentence] != num) {
            // En este caso, el jugador le erra
            keys[8].rewind();
            keys[8].play();
            isWrong = true;
          }
          else {
            // En este caso, el jugador acierta
            keys[num].rewind();
            keys[num].play();
          } 
    }
  }
}

void keyReleased() {
    //println("released!");
    
    if(isSimonsTurn == false) {
      
      if(isWrong) {
        simonStartsNewGame();
        isWrong = false;
      }
      else {
        
        if(positionInSentence < currentLengthOfTheSentence) {
          positionInSentence++; 
          //println(positionInSentence);
        }
        else {
          
          if(currentLengthOfTheSentence == simonSentence.length-1) {
             println("user wins!!!"); 
             simonStartsNewGame();
          }
          else {
          
            currentLengthOfTheSentence++;
            
            if(currentLengthOfTheSentence <6)        talkTime = 420;
            else if(currentLengthOfTheSentence < 14) talkTime = 320;
            else                                     talkTime = 220;
            
            positionInSentence = 0;
            
            timeOut = millis() + 1000;
            isSimonsTurn = true;
          }
        }
      }
    }
}

//-------------------------------------------------------------------------


// Funcion que permite mostrar la secuencia que el jugador debe repetir
void simonSays() {
  
  if(millis() >= timeOut) {
  
    // Simon muestra la secuencia
    int simonsWord = simonSentence[positionInSentence];
    keys[simonsWord].rewind();
    keys[simonsWord].play();
    //--------------------------------------------------------
    // Codigo para mandarle el numero de nota por serie a
    // la Arduino, para que prenda las luces correspondientes
    //--------------------------------------------------------
    
    if(positionInSentence < currentLengthOfTheSentence) {
      positionInSentence++;
    }
    else {
      isSimonsTurn = false;
      positionInSentence = 0;
    }
    
    //if(positionInSentence>=simonSentence.length) {
    //  positionInSentence = 0;    
    //}
    
    //println(positionInSentence);
    
    timeOut = millis() + talkTime + 55;
  }  
  
}

void simonStartsNewGame() {
  
  makeNewSentence();
  timeOut = millis() + 1000;
  isSimonsTurn = true;
  
}

void makeNewSentence() {
  for(int i = 0; i<simonSentence.length; i++) {
    simonSentence[i] = int(random(0,8));
  }
  
  positionInSentence = 0;
  currentLengthOfTheSentence = 0;
  
  //printArray(simonSentence);
  println(join(nf(simonSentence, 0), ", "));  
}
