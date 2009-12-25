#define MSG_SIZE 12
#define ID_SIZE ((MSG_SIZE) - 1)
#define JAM_PERIOD 500

#define RFID_START_BYTE 0x0A
#define RFID_END_BYTE   0x0D

char msg[MSG_SIZE];

void setup()
{
    Serial.begin(2400);
    pinMode(4, OUTPUT);
}

void loop()
{
    if (Serial.available() >= MSG_SIZE) {
        for (int i = 0; i < MSG_SIZE; i++)
            msg[i] = Serial.read();

        if (msg[0] == RFID_START_BYTE && msg[MSG_SIZE - 1] == RFID_END_BYTE) {
            for (int i = 1; i < ID_SIZE; i++)
                Serial.print(msg[i]);

            Serial.println();
            jam();
        }
        else 
            Serial.flush();
    }
}

void jam()
{
    digitalWrite(4, HIGH);
    delay(1000);
    Serial.flush();
    digitalWrite(4, LOW);
}
