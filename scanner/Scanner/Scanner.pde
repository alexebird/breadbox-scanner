/*
 * A simple sketch that uses WiServer to get the hourly weather data from LAX and prints
 * it via the Serial API
 */

#include <WiServer.h>

#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = {192,168,1,66};	// IP address of WiShield
unsigned char gateway_ip[] = {192,168,1,1};	// router or gateway IP address
unsigned char subnet_mask[] = {255,255,255,0};	// subnet mask for the local network
const prog_char ssid[] PROGMEM = {"dd-wrt"};		// max 32 bytes

unsigned char security_type = 3;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2

// WPA/WPA2 passphrase
const prog_char security_passphrase[] PROGMEM = {"boobtit1207"};	// max 64 characters

prog_uchar wep_keys[] PROGMEM = { 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,0x0d,// Key 0
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,// Key 1
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,0x00,// Key 2
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00// Key 3
};

// setup the wireless mode
// infrastructure - connect to AP
// adhoc - connect to another WiFi device
unsigned char wireless_mode = WIRELESS_MODE_INFRA;

unsigned char ssid_len;
unsigned char security_passphrase_len;
// End of wireless configuration parameters ----------------------------------------
//
//
#define SCAN_SIZE  12
#define ID_SIZE    ((SCAN_SIZE) - 1)
/*#define DISABLE_PERIOD 1000*/
#define DISABLE_PIN 4
#define BUTTON_PIN 6

#define SCAN_START_BYTE 0x0A
#define SCAN_END_BYTE   0x0D

#define VALID_SCAN(scan_bytes) scan_bytes[0] == SCAN_START_BYTE && scan_bytes[SCAN_SIZE - 1] == SCAN_END_BYTE
#define SCAN_AVAILABLE() Serial.available() >= SCAN_SIZE 
#define DISABLE_READER() digitalWrite(DISABLE_PIN, HIGH);
#define ENABLE_READER()  digitalWrite(DISABLE_PIN, LOW);

#define SCANNER_ID 1

#define LOCATION_ROOM 10
#define LOCATION_FRIDGE 11
#define LOCATION_FREEZER 12

#define SCAN_REQUEST      10
#define INVENTORY_REQUEST 20
#define INVENTORY_RESPONSE 20

char scan_bytes[SCAN_SIZE];

#define RESPONSE_TYPE_SIZE 2
typedef struct __response {
  char type[RESPONSE_TYPE_SIZE];
  char body[150];
} response;

int last_button_state = LOW;
int button_state;
int location = LOCATION_FRIDGE;

void scanRequestBodyCallback()
{
    scan_bytes[ID_SIZE] = '\0';

    // Set id to the start of the acsii part of the RFID.
    char *rfid = scan_bytes + 1;

    // Send the request over the network.
    WiServer.print(SCAN_REQUEST);
    WiServer.print(' ');
    WiServer.print(SCANNER_ID);
    WiServer.print(' ');
    WiServer.print(rfid);
    WiServer.print(' ');
    WiServer.print(location);

    // Send the request over serial for debugging.
    Serial.println();
    Serial.print(SCAN_REQUEST);
    Serial.print(' ');
    Serial.print(SCANNER_ID);
    Serial.print(' ');
    Serial.print(rfid);
    Serial.print(' ');
    Serial.println(location);
}

void responseCallback(char *data, int len)
{
    response *r = (response *) data;
    for (int i = 0; i < len; i++) {
        Serial.write(r->body[i]);
    }
    Serial.println();
    ENABLE_READER();
}

// IP Address for the scan-server.
uint8 ip[] = {192,168,1,29};

// A request that sends
POSTrequest sendScan(ip, 5000, "everest", "/", scanRequestBodyCallback);

void setup()
{
    pinMode(BUTTON_PIN, INPUT);
    pinMode(DISABLE_PIN, OUTPUT);
    digitalWrite(DISABLE_PIN, LOW);

    Serial.begin(2400);
    Serial.println("Starting...");
    // Initialize WiServer (we'll pass NULL for the page serving function since we don't need to serve web pages) 
    WiServer.init(NULL);
    /*WiServer.enableVerboseMode(true);*/

    // Set the scan request's callbacks.
    sendScan.setReturnFunc(responseCallback);
}

void readButton()
{
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

void loop()
{
    if (SCAN_AVAILABLE()) {
        for (int i = 0; i < SCAN_SIZE; i++)
            scan_bytes[i] = Serial.read();

        if (VALID_SCAN(scan_bytes)) {
            DISABLE_READER();
            sendScan.submit();
        }
    }

    readButton();

    // Run WiServer
    WiServer.server_task();

    delay(10);
}

