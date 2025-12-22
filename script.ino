//Libraires
#include <WiFi.h>
#include <PubSubClient.h>
#include <motor.h> 

// ===================== Motor settings ====================
// D26, D25, D33, D32
CustomStepper motor(26, 25, 33, 32);
const int STEPS_PER_ML = 3000; 
const int RETRACT_SPEED_MICROS = 2000; 

float stored_ml = 0.0;       
float stored_time = 0.0;     

// ===================== WIFI + MQTT =====================
const char* wifi_ssid = "Bassel_A15";
const char* wifi_password = "Gf^k@!BUQ0*3K4";

const char* mqtt_server = "test.mosquitto.org"; 
const int mqtt_port = 1883;

// ===================== Topics =====================
const char* topic_ml    = "syringe/ml";      // (ML)
const char* topic_time  = "syringe/time";    // (Time)
const char* topic_cmd   = "syringe/cmd";     // (Start)
const char* topic_status = "syringe/status";

WiFiClient espClient;
PubSubClient client(espClient);

// ===================== Status sending function =====================
void publishStatus(String msg) {
  if (client.connected()) {
    client.publish(topic_status, msg.c_str());
  }
}

// ===================== Injection and return function =====================
void injectLiquid(float ml_amount, float total_seconds) {
  if (ml_amount <= 0 || total_seconds <= 0) {
    Serial.println("⚠️ Error: Set ML and Time first!");
    publishStatus("Error: Set ML & Time");
    return;
  }
  
  Serial.println(">>> STARTING MOTION >>>");
  publishStatus("Running...");
  
  long stepsNeeded = ml_amount * STEPS_PER_ML;
  unsigned long delayPerStep = (total_seconds * 1000000.0) / stepsNeeded;
  
  motor.setStepDelay(delayPerStep);
  motor.step(stepsNeeded); 
  
  delay(1000); 
  
  Serial.println("<<< RETURNING <<<");
  publishStatus("Returning...");
  
  motor.setStepDelay(3000); 
  motor.step(-stepsNeeded); 
  
  motor.stop(); 
  Serial.println("✅ DONE");
  publishStatus("Finished. Ready.");
}

// ===================== Message receiving function =====================
void messageReceived(char* topic, byte* payload, unsigned int length) {
  String message = "";
  for (int i = 0; i < length; i++) message += (char)payload[i];
  message.trim();
  String topicStr = String(topic);

  Serial.print("\n📩 Msg on ["); Serial.print(topicStr); Serial.print("]: ");
  Serial.println(message);

  if (topicStr == topic_ml) {
    // 1. Ml
    stored_ml = message.toFloat();
    if (stored_ml > 0) {
      Serial.println("💾 ML Saved");
      publishStatus(("ML set to: " + message).c_str());
    } else {
      Serial.println("⚠️ Invalid ML value");
      publishStatus("Error: Invalid ML");
    }
  }
  else if (topicStr == topic_time) {
    // 2. Time
    stored_time = message.toFloat();
    if (stored_time > 0) {
      Serial.println("💾 Time Saved");
      publishStatus(("Time set to: " + message).c_str());
    } else {
      Serial.println("⚠️ Invalid Time value");
      publishStatus("Error: Invalid Time");
    }
  }
  else if (topicStr == topic_cmd) {
    // 3. Start
    if (message == "start" || message == "1") {
      Serial.println("🚀 Start Command Received!");
      injectLiquid(stored_ml, stored_time);
    }
  }
}

// ===================== Calling functions =====================
void connectWiFi() {
  if(WiFi.status() == WL_CONNECTED) return;
  Serial.print("Connecting WiFi");
  WiFi.begin(wifi_ssid, wifi_password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500); Serial.print(".");
  }
  Serial.println("\n✅ WiFi OK");
}

void connectMQTT() {
  while (!client.connected()) {
    Serial.println("Connecting to Mosquitto...");
    String clientId = "SyringeESP-" + String(random(0xffff), HEX);
    
    if (client.connect(clientId.c_str())) {
      Serial.println("✅ Connected to Mosquitto!");
      
      client.subscribe(topic_ml);
      client.subscribe(topic_time);
      client.subscribe(topic_cmd);
      publishStatus("System Online");
    } else {
      Serial.print("Failed, rc="); Serial.print(client.state());
      delay(3000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  connectWiFi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(messageReceived);
  connectMQTT();
}

void loop() {
  if (!client.connected()) connectMQTT();
  client.loop();
}
