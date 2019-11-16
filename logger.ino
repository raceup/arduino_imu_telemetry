
#include <MPU6050_tockn.h>
#include <Wire.h>
#include <SPI.h>
#include <SD.h> 

int DIM_BUFFER = 200;
int SMPL_TIME = 10;

int ID_number;
String filename;
File logFile;
MPU6050 mpu6050(Wire);
int i = 0;

typedef struct
{
  unsigned long t;
  float data[9];
} record;

record Buffer[200];
  
void setup() {
  
  randomSeed(analogRead(A0));
  Serial.begin(9600);
  Wire.begin();
  mpu6050.begin();
  mpu6050.calcGyroOffsets(true);

  Serial.println();
  Serial.print("Checking SD card...");

  if (!SD.begin(53)) {
    Serial.println("initialization failed: missing or corrupted SD!");
    while (1);
  }
  Serial.println("initialization done.");
  //Serial.println("TIME,AccX,AccY,AccZ,GyroX,GyroY,GyroZ,AngleX,AngleY,AngleZ");
  Serial.println("start logging.");

  File root = SD.open("/");
  File dir;
  ID_number=1;
  
  while(root.openNextFile())
  {
    ID_number++;
  }

  //randNumber = random(99999);
  filename = "log"+String(ID_number)+".txt";
}

/*
other useful fcns:
getTemp()
getAccAngleX(),GetAccAngleY()
getGyroAngleX(),getGyroAngleY(),getGyroAngleZ()
*/
  
void loop() {
  mpu6050.update();
  //Serial.println("logging sample");
  Buffer[i].t=millis();
  Buffer[i].data[0]=mpu6050.getAccX();
  Buffer[i].data[1]=mpu6050.getAccY();
  Buffer[i].data[2]=mpu6050.getAccZ();
  Buffer[i].data[3]=mpu6050.getGyroX();
  Buffer[i].data[4]=mpu6050.getGyroY();
  Buffer[i].data[5]=mpu6050.getGyroZ();
  Buffer[i].data[6]=mpu6050.getAngleX();
  Buffer[i].data[7]=mpu6050.getAngleY();
  Buffer[i].data[8]=mpu6050.getAngleZ();
  i=i+1;

  if (i==DIM_BUFFER){
    logFile = SD.open(filename, FILE_WRITE);
    Serial.println("writing");
    if(logFile){
      for (i=0; i<DIM_BUFFER; i++){
        //Serial.print(Buffer[i].t);
        logFile.print(Buffer[i].t);
        for (int j = 0; j <= 8; j++) {
          //Serial.print(",");
          //Serial.print(Buffer[i].data[j]);
          logFile.print(",");
          logFile.print(Buffer[i].data[j]);
        }
        //Serial.println();
        logFile.println();
      }
    }
    else{
      Serial.println("Error while opening log file.");
    }
    logFile.close();
    i=0;
  }
  delay(SMPL_TIME);  
}
