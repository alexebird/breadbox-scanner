/**
 * Reads ID via the RFID reader and sends them over ethernet to a web server.
 *
 * Copyright 2009-2010 Alex Bird.
 */

#include <Ethernet.h>

#define SCAN_SIZE  12
#define ID_SIZE    ((SCAN_SIZE) - 1)
#define JAM_PERIOD 1000
#define JAM_PIN    4
#define BUTTON_PIN 2

#define SCAN_START_BYTE 0x0A
#define SCAN_END_BYTE   0x0D

#define VALID_SCAN(scan_bytes) scan_bytes[0] == SCAN_START_BYTE && scan_bytes[SCAN_SIZE - 1] == SCAN_END_BYTE
#define SCAN_AVAILABLE() Serial.available() >= SCAN_SIZE 
#define DISABLE_READER() digitalWrite(JAM_PIN, HIGH);
#define ENABLE_READER()  digitalWrite(JAM_PIN, LOW);

#define SCANNER_ID 1

#define LOCATION_ROOM 10
#define LOCATION_FRIDGE 11
#define LOCATION_FREEZER 12

#define SCAN_REQUEST      10
#define INVENTORY_REQUEST 20
#define INVENTORY_RESPONSE 20

#define RESPONSE_TYPE_SIZE 2
typedef struct __response_header {
  char type[RESPONSE_TYPE_SIZE + 1];
} response_header;

char scan_bytes[SCAN_SIZE];
byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 1, 66 };
byte scan_server[] = { 192, 168, 1, 29 };

int last_button_state = LOW;
int button_state;
int location = LOCATION_FRIDGE;

Client client(scan_server, 5000);

void setup()
{
    pinMode(BUTTON_PIN, INPUT);
    pinMode(JAM_PIN, OUTPUT);
    digitalWrite(JAM_PIN, LOW);

    Serial.begin(2400);
    Ethernet.begin(mac, ip);
}

void loop()
{
    if (SCAN_AVAILABLE()) {
        DISABLE_READER();

        for (int i = 0; i < SCAN_SIZE; i++)
            scan_bytes[i] = Serial.read();

        if (VALID_SCAN(scan_bytes))
            send_scan_request();

        ENABLE_READER();
    }

    button_state = digitalRead(BUTTON_PIN);

    if (last_button_state == LOW && button_state == HIGH) {
        switch(location) {
            case LOCATION_FREEZER:
                location = LOCATION_ROOM;
                Serial.println("Switched to room.");
                break;

            case LOCATION_ROOM:
                location = LOCATION_FRIDGE;
                Serial.println("Switched to fridge.");
                break;

            case LOCATION_FRIDGE:
                location = LOCATION_FREEZER;
                Serial.println("Switched to freezer.");
                break;
        }
        delay(50);
    }

    last_button_state = button_state;
}

void print_location()
{
    switch(location) {
        case LOCATION_ROOM:
            Serial.println("Currently adding to room.");
            break;

        case LOCATION_FRIDGE:
            Serial.println("Currently adding to fridge.");
            break;

        case LOCATION_FREEZER:
            Serial.println("Currently adding to freezer.");
            break;
    }
}

void send_scan_request()
{
    // Assumes constant length for RFID's.  User ID's are two unsigned bytes
    // so the max value could be as large as 6 characters.
    char request[18];

    if (client.connect()) {
        // Truncate the string holding the actual RFID so the SCAN_END_BYTE isn't included.
        scan_bytes[ID_SIZE] = '\0';

        // Set id to the start of the acsii part of the RFID.
        char *rfid = scan_bytes + 1;

        // Send the request over the network.
        client.print(SCAN_REQUEST);
        client.print(' ');
        client.print(SCANNER_ID);
        client.print(' ');
        client.print(rfid);
        client.print(' ');
        client.println(location);

        // Send the request over serial for debugging.
        Serial.println();
        Serial.print(SCAN_REQUEST);
        Serial.print(' ');
        Serial.print(SCANNER_ID);
        Serial.print(' ');
        Serial.print(rfid);
        Serial.print(' ');
        Serial.println(location);

        response_header hdr;
        
        while (client.connected()) {
            if (client.available() >= sizeof(response_header) - 1) {
                hdr.type[0] = client.read();
                hdr.type[1] = client.read();
                hdr.type[2] = '\0';
                Serial.print("Response: type=");
                Serial.print(hdr.type);
                break;
            }
        }

        Serial.println(" body=");
        while (client.connected()) {
            if (client.available()) {
                Serial.write(client.read());
            }
        }
        Serial.println();

        client.stop();
        print_location();
        // Mysteriously required to work properly.
        Serial.flush();
    }
    else {
        Serial.println("Couldn't connect via Ethernet.");
    }
}

