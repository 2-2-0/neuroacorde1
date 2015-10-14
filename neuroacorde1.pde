// Hipermente - neuroacorde #1, por 220
// generado con los datos EM recopilados por Hipermente en Meditatio Sonus C03.S04 - Marte

import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

// Audio system
Minim minim;
AudioRecorder rec;
AudioOutput out;

// Sound channels
Oscil sound0;
Oscil sound1;
Oscil sound2;
Oscil sound3;
Oscil sound4;
Oscil sound5;

// Data storage
int [] data_set0;
int [] data_set1;
int [] data_set2;
int [] data_set3;
int [] data_set4;
int [] data_set5;

int set_length;
int count; 

long start_time;

void setup () {
  size (384, 64);
    
  // abrir sistema de audio
  minim = new Minim (this);
  out = minim.getLineOut (Minim.STEREO, 2048, 44100, 16);
  out.setVolume (1.0f);
  
  rec = minim.createRecorder (out, "rec.wav");
  
  // extraer la información de cada archivo
  data_set0 = parseCSV ("Hipermente-CSV-rawvalues-set0.csv");
  data_set1 = parseCSV ("Hipermente-CSV-rawvalues-set1.csv");
  data_set2 = parseCSV ("Hipermente-CSV-rawvalues-set2.csv");
  data_set3 = parseCSV ("Hipermente-CSV-rawvalues-set3.csv");
  data_set4 = parseCSV ("Hipermente-CSV-rawvalues-set4.csv");
  data_set5 = parseCSV ("Hipermente-CSV-rawvalues-set5.csv");

  // ajustar características de los canales de audio
  sound0 = initOscil (out, 0.8f, -1.0f);
  sound0.setWaveform (Waves.TRIANGLE);
  
  sound1 = initOscil (out, 0.3f, -0.6f);
  sound1.setWaveform (Waves.SQUARE);
  
  sound2 = initOscil (out, 0.8f, -0.2f);
  sound2.setWaveform (Waves.SINE);
  
  sound3 = initOscil (out, 0.8f, 0.2f);
  sound3.setWaveform (Waves.SINE);
  
  sound4 = initOscil (out, 0.3f, 0.6f);
  sound4.setWaveform (Waves.SQUARE);
  
  sound5 = initOscil (out, 0.8f, 1.0f);
  sound5.setWaveform (Waves.TRIANGLE);
  
  // comenzar grabación
  rec.beginRecord ();
  
  // tomar tiempo de inicio
  start_time = millis ();
  count = 0;
}
void draw () {
  background (0);
  int val;
  // si estamos dentro del conteo de sampleos...
  if (count<data_set0.length) {
    // dibuja la señal
    fill (0, 64, 255, data_set0 [count]);
    rect (0, 0, 64, 64);
    
    fill (0, 64, 255, data_set1 [count]);
    rect (64, 0, 64, 64);
    
    fill (0, 64, 255, data_set2 [count]);
    rect (128, 0, 64, 64);
    
    fill (0, 64, 255, data_set3 [count]);
    rect (192, 0, 64, 64);
    
    fill (0, 64, 255, data_set4 [count]);
    rect (256, 0, 64, 64);
    
    fill (0, 64, 255, data_set5 [count]);
    rect (320, 0, 64, 64);
    
    // ajusta la frecuencia de cada canal
    val = (int)map (data_set0 [count], 0, 255, 16, 220);
    sound0.setFrequency ((float)val);
    
    val = (int)map (data_set1 [count], 0, 255, 32, 494);//988
    sound1.setFrequency ((float)val);
    
    val = (int)map (data_set2 [count], 0, 255, 64, 220);
    sound2.setFrequency ((float)val);
    
    val = (int)map (data_set3 [count], 0, 255, 64, 220);
    sound3.setFrequency ((float)val);
    
    val = (int)map (data_set4 [count], 0, 255, 32, 494);//988
    sound4.setFrequency ((float)val);
    
    val = (int)map (data_set5 [count], 0, 255, 16, 220);
    sound5.setFrequency ((float)val);
    
    println (count);

    count++;
  } else {
    // terminar grabación
    rec.endRecord ();
    
    // reporte final
    long ts = (millis () - start_time)/1000;
    long tm = ts/60;
    println ("Total seconds: "+str (ts));
    println ("Total minutes: "+str (tm));
    delay (5000);
    exit ();
  }
  
  // 5 minutes, aprox.
  delay (30);
}

// extractor de datos csv en un array de integers
int [] parseCSV (String filename) {
  String data [] = loadStrings (filename);
  int data_values [] = new int [data.length];
  int data_value;
  
  for (int i=0; i<data.length; i++) {
    int x = data [i].indexOf (",");
    if (x!=-1) {
      data_values [i] = int (data [i].substring (0, x));
    }
  }
  
  return data_values;
}
// "ajustador" de canal de audio
Oscil initOscil (AudioOutput out, float amp, float _pan) {
  Oscil sound = new Oscil (0, amp, Waves.SINE);
  Pan pan = new Pan (_pan);
  pan.patch (out);
  
  Delay delay = new Delay (0.7f, 0.5f, false, true);
  delay.patch (pan);
  
  sound.patch (delay);
  
  return sound;
}
