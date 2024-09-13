#include <Arduino.h>
#include <WiFiNINA.h>
#include <Config.h>
#include <FirebaseClient.h>

#define WIFI_SSID ""
#define WIFI_PASSWORD ""
#define API_KEY ""
#define USER_EMAIL ""
#define USER_PASSWORD ""

#define DATABASE_SECRET ""
#define DATABASE_URL ""

int status = WL_IDLE_STATUS; 
DefaultNetwork network;
UserAuth user_auth(API_KEY, USER_EMAIL, USER_PASSWORD, 3000);
// NoAuth noAuth;
FirebaseApp app;

#include <WiFiSSLClient.h>
WiFiSSLClient ssl;
// WiFiClient client;

AsyncClientClass client(ssl, getNetwork(network));

RealtimeDatabase Database;
AsyncResult result;
LegacyToken dbSecret(DATABASE_SECRET);

void printError(int code, const String &msg)
{
    Firebase.printf("Error, msg: %s, code: %d\n", msg.c_str(), code);
}

void setup()
{

    Serial.begin(115200);

    Serial.print("Connecting to Wi-Fi");
    while (status != WL_CONNECTED)
    {
        WiFi.end();
        status = WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
        Serial.print("Wi-Fi status: ");
        Serial.println(status);
        delay(1000);
    }
    Serial.println();
    Serial.print("Connected with IP: ");
    Serial.println(WiFi.localIP());
    Serial.println();

    Firebase.printf("Firebase Client v%s\n", FIREBASE_CLIENT_VERSION);

    Serial.print("Verifying user... ");
    bool ret = verifyUser(API_KEY, USER_EMAIL, USER_PASSWORD);
    if (ret)
        Serial.println("ok");
    else
        Serial.println("failed");

    Serial.println("Initializing app...");
    initializeApp(client, app, getAuth(user_auth));
    // initializeApp(client, app, getAuth(dbSecret));

    authHandler();

    app.getApp<RealtimeDatabase>(Database);

    Database.url(DATABASE_URL);

    client.setAsyncResult(result);

    Serial.print("Get JSON... ");
    String name = Database.get<String>(client, "/test");
    if (client.lastError().code() == 0)
        Serial.println(name);
    else
      printError(client.lastError().code(), client.lastError().message());
}

void loop()
{
  authHandler();
}

void authHandler()
{
    unsigned long ms = millis();
    while (app.isInitialized() && !app.ready() && millis() - ms < 120 * 1000)
    {
        JWT.loop(app.getAuth());
        printResult(result);
    }
}

bool verifyUser(const String &apiKey, const String &email, const String &password)
{
    if (ssl.connected())
        ssl.stop();

    String host = "www.googleapis.com";
    bool ret = false;

    if (ssl.connect(host.c_str(), 443) > 0)
    {
        String payload = "{\"email\":\"";
        payload += email;
        payload += "\",\"password\":\"";
        payload += password;
        payload += "\",\"returnSecureToken\":true}";

        String header = "POST /identitytoolkit/v3/relyingparty/verifyPassword?key=";
        header += apiKey;
        header += " HTTP/1.1\r\n";
        header += "Host: ";
        header += host;
        header += "\r\n";
        header += "Content-Type: application/json\r\n";
        header += "Content-Length: ";
        header += payload.length();
        header += "\r\n\r\n";

        if (ssl.print(header) == header.length())
        {
            if (ssl.print(payload) == payload.length())
            {
                unsigned long ms = millis();
                while (ssl.connected() && ssl.available() == 0 && millis() - ms < 5000)
                {
                    delay(1);
                }

                ms = millis();
                while (ssl.connected() && ssl.available() && millis() - ms < 5000)
                {
                    String line = ssl.readStringUntil('\n');
                    if (line.length())
                    {
                        ret = line.indexOf("HTTP/1.1 200 OK") > -1;
                        break;
                    }
                }
                ssl.stop();
            }
        }
    }

    return ret;
}

void printResult(AsyncResult &aResult)
{
    if (aResult.isEvent())
    {
        Firebase.printf("Event task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.appEvent().message().c_str(), aResult.appEvent().code());
    }

    if (aResult.isDebug())
    {
        Firebase.printf("Debug task: %s, msg: %s\n", aResult.uid().c_str(), aResult.debug().c_str());
    }

    if (aResult.isError())
    {
        Firebase.printf("Error task: %s, msg: %s, code: %d\n", aResult.uid().c_str(), aResult.error().message().c_str(), aResult.error().code());
    }

    if (aResult.available())
    {
        Firebase.printf("task: %s, payload: %s\n", aResult.uid().c_str(), aResult.c_str());
    }
}
