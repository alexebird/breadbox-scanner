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

void scanRequestBodyCallback()
{
    WiServer.print("20 1");
}

void responseCallback(char *data, int len)
{
    for (int i = 0; i < len; i++) {
        Serial.write(data[i]);
    }
}

// IP Address for the scan-server.
uint8 ip[] = {192,168,1,29};

// A request that sends
POSTrequest sendScan(ip, 5000, "everest", "/", scanRequestBodyCallback);

void setup()
{
    Serial.begin(57600);
    // Initialize WiServer (we'll pass NULL for the page serving function since we don't need to serve web pages) 
    WiServer.init(NULL);
    WiServer.enableVerboseMode(true);

    // Set the scan request's callbacks.
    sendScan.setReturnFunc(responseCallback);
}

// Time (in millis) when the data should be retrieved 
long updateTime = 0;

void loop()
{
    if (millis() >= updateTime) {
        sendScan.submit();
        // 1 second updates
        updateTime += 1000;
    }

    // Run WiServer
    WiServer.server_task();

    delay(10);
}

