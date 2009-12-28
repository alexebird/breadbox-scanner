/**
 * Reads ID via the RFID reader and sends them over ethernet to a web server.
 *
 * Copyright 2009 Alex Bird.
 */

#include <Ethernet.h>

#define MSG_SIZE   12
#define ID_SIZE    ((MSG_SIZE) - 1)
#define JAM_PERIOD 1000
#define JAM_PIN    4

#define RFID_START_BYTE 0x0A
#define RFID_END_BYTE   0x0D

#define VALID_RFID(msg)  msg[0] == RFID_START_BYTE && msg[MSG_SIZE - 1] == RFID_END_BYTE
#define MSG_AVAILABLE()  Serial.available() >= MSG_SIZE 
#define DISABLE_READER() digitalWrite(JAM_PIN, HIGH);
#define ENABLE_READER()  digitalWrite(JAM_PIN, LOW);

unsigned int user_id = 1;
char msg[MSG_SIZE];
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 2, 66 };
byte server[] = { 192, 168, 2, 60 };

Client client(server, 7001);

void setup()
{
    pinMode(JAM_PIN, OUTPUT);
    digitalWrite(JAM_PIN, LOW);

    Serial.begin(2400);
    Ethernet.begin(mac, ip);
}

void loop()
{
    if (MSG_AVAILABLE()) {
        DISABLE_READER();

        for (int i = 0; i < MSG_SIZE; i++)
            msg[i] = Serial.read();

        if (VALID_RFID(msg))
            sendRFID();

        ENABLE_READER();
    }
}

void sendRFID()
{
    // Assumes constant length for RFID's.  User ID's are two unsigned bytes
    // so the max value could be as large as 6 characters.
    char request[18];

    if (client.connect()) {
        msg[ID_SIZE] = '\0';

        // Set id to the start of the acsii part of the RFID.
        char *id = msg + 1;

        // Send the request over the network.  No response is sent.
        client.print(user_id);
        client.print(' ');
        client.println(id);
        client.stop();

        // Send the request over serial for debugging.
        Serial.print(user_id);
        Serial.print(' ');
        Serial.println(id);

        delay(JAM_PERIOD);
        // Mysteriously required to work properly.
        Serial.flush();
    }
    else {
        Serial.println("Couldn't connect via Ethernet.");
    }
}

