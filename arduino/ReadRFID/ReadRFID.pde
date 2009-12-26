/**
 * Reads ID via the RFID reader and sends them over ethernet to a web server.
 *
 * Copyright 2009 Alex Bird.
 */

#include <Ethernet.h>

#define MSG_SIZE 12
#define ID_SIZE ((MSG_SIZE) - 1)
#define JAM_PERIOD 1000
#define JAM_PIN 4

#define RFID_START_BYTE 0x0A
#define RFID_END_BYTE   0x0D

#define VALID_RFID(msg) msg[0] == RFID_START_BYTE && msg[MSG_SIZE - 1] == RFID_END_BYTE
#define MSG_AVAILABLE() Serial.available() >= MSG_SIZE 
#define DISABLE_READER() digitalWrite(JAM_PIN, HIGH);
#define ENABLE_READER()  digitalWrite(JAM_PIN, LOW);

char msg[MSG_SIZE];
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 2, 66 };
byte server[] = { 192, 168, 2, 60 };

Client client(server, 7001);

void setup()
{
    Serial.begin(2400);
    pinMode(JAM_PIN, OUTPUT);
    digitalWrite(JAM_PIN, LOW);

    Ethernet.begin(mac, ip);
}

void loop()
{
    if (MSG_AVAILABLE()) {
        for (int i = 0; i < MSG_SIZE; i++)
            msg[i] = Serial.read();

        if (VALID_RFID(msg)) {
            /*for (int i = 1; i < ID_SIZE; i++)*/
                /*Serial.print(msg[i]);*/

            /*Serial.println();*/

            sendRFID();
            /*jam();*/
        }
        /*else {*/
            /*// Discard the message.*/
            /*Serial.flush();*/
        /*}*/
    }
}

/*void jam()*/
/*{*/
    /*DISABLE_READER();*/
    /*delay(JAM_PERIOD);*/
    /*Serial.flush();*/
    /*ENABLE_READER();*/
/*}*/

void sendRFID()
{
    // Assumes constant length for ID's.
    char request[34];

    DISABLE_READER();
    if (client.connect()) {
        msg[ID_SIZE] = '\0';
        // set id to the start of the acsii part of the rfid.
        char *id = msg + 1;
        /*sprintf(request, "%s", id);*/
        Serial.println(id);
        client.println(id);
        /*while (client.available())*/
            /*client.read();*/
        client.stop();
        delay(JAM_PERIOD);
        Serial.flush();
    }
    else {
        Serial.println("Couldn't connect via Ethernet.");
    }
    ENABLE_READER();
}

