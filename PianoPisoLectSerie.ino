//int teclasEntrada[] = {A0, A1, A2, A3, A4, A5, A6, A7};
//int keyStateNow[] = {0, 0, 0, 0, 0, 0, 0, 0};
//int keyStatePrev[] = {0, 0, 0, 0, 0, 0, 0, 0};
// Puertos de entrada, estados actual y anterior
#define NUMERO_TECLAS 8
int keyPins[] = {12, 11, 10, 9, 5, 4, 3, 2};
int keyStateNow[] = {0, 0, 0, 0, 0, 0, 0, 0};
int keyStatePrev[] = {0, 0, 0, 0, 0, 0, 0, 0};

// Definiciones y variables de NeoPixels
#include <Adafruit_NeoPixel.h>
#define PIN_RGB 13    // Pin que va a la tira de LEDs RGB
#define NUMPIXELS 69 // Para controlar las luces
int inicioFila = 0; // Dónde arranca la tira de LEDs
int finFila = 0; // Dónde termina la tira de LEDs
// Nuevo objeto 'pixels', para controlar la tira RGB
Adafruit_NeoPixel pixels(NUMPIXELS, PIN_RGB, NEO_GRB + NEO_KHZ800);

void setup() {
  Serial.begin(115200);

  pixels.begin(); // Inicializamos el objeto pixels

  // Inicializamos las teclas de entrada
  for (int i = 0; i<NUMERO_TECLAS; i++){
    pinMode(keyPins[i], INPUT_PULLUP);
  }
}

void loop() {
  
  // Ciclo para lectura y procesamiento de teclas
  for (int i = 0; i<NUMERO_TECLAS; i++){
    // Lectura de las entradas
    keyStatePrev[i] = keyStateNow[i];
    keyStateNow[i] = digitalRead(keyPins[i]);
    
    // Comprobacion de tecla presionada
    if(keyStatePrev[i] != keyStateNow[i]){    // Detecto un cambio de estado
      if (keyStateNow[i] == LOW){   // Con la PullUp, detectamos por bajo
        Serial.write(i+1);
        prenderTira(i);
        }
      else apagarTira(i);
      }
    }

    // Nos fijamos si entra la info de una tecla por serial
    // (ver la función serialEvent más abajo)
    
  // Antirrebote
  delay(50);
}

// Funcion para encender una tira de LEDs, en la fila solicitada (de la 0 a la N-1)
void prenderTira (int fila){
  
    // seleccionamos la fila correspondiente
    switch (fila) {
    case 0:
      inicioFila = 0;
      finFila = 6;
      break;
    case 1:
      inicioFila = 7;
      finFila = 15;
      break;
    case 2:
      inicioFila = 15;
      finFila = 24;
      break;
    case 3:
      inicioFila = 25;
      finFila = 33;
      break;
    case 4:
      inicioFila = 34;
      finFila = 42;
      break;
    case 5:
      inicioFila = 43;
      finFila = 52;
      break;
    case 6:
      inicioFila = 52;
      finFila = 61;
      break;
    case 7:
      inicioFila = 61;
      finFila = 69;
      break;
    default:
      break;
    }

    // Encendemos la tira de LEDs en la parte que corresponde
    for(int led=inicioFila; led<=finFila; led++) {
      pixels.setPixelColor(led, pixels.Color(100, 70, 60));
    }
    pixels.show();   // Actualizamos los valores para la tira de RGB
}

// Funcion para apagar una tira de LEDs, en la fila solicitada (de la 0 a la N-1)
void apagarTira (int fila){
  
    // seleccionamos la fila correspondiente
    switch (fila) {
    case 0:
      inicioFila = 0;
      finFila = 6;
      break;
    case 1:
      inicioFila = 7;
      finFila = 15;
      break;
    case 2:
      inicioFila = 15;
      finFila = 24;
      break;
    case 3:
      inicioFila = 25;
      finFila = 33;
      break;
    case 4:
      inicioFila = 34;
      finFila = 42;
      break;
    case 5:
      inicioFila = 43;
      finFila = 52;
      break;
    case 6:
      inicioFila = 52;
      finFila = 61;
      break;
    case 7:
      inicioFila = 61;
      finFila = 69;
      break;
    default:
      break;
    }

    // Encendemos la tira de LEDs en la parte que corresponde
    for(int led=inicioFila; led<=finFila; led++) {
      pixels.setPixelColor(led, pixels.Color(0, 0, 0));
    }
    pixels.show();   // Actualizamos los valores para la tira de RGB
}

// Rutina para procesar la entrada de datos por serial
void serialEvent() {
  if (Serial.available()) {
    // Tomamos el número de la tecla
    char numeroTecla = (char)Serial.read();

    // Encendemos, esperamos 100 milisegundos y apagamos
    prenderTira(numeroTecla);
    delay(200);
    apagarTira(numeroTecla);
  }
}

// NOTA: El delay en serialEvent no es recomendable dado que bloquearía todo el sistema,
// se me ocurre hace un timer aparte para llamar a apagarTira
