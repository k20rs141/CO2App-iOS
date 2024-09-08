//
// System Info.
//
#define BUILD             200
#define SYSTEM_VERSION    "3.0.0"

// iPhoneのテザリングを使う場合（30秒毎に通信する）
// 以下のdefineを有効にすると，iPhoneモードで動作
//#define IPHONE
#ifdef IPHONE
int iPhone = 1;
#else
int iPhone = 0;
#endif

// ループディレイの時間設定
#define LOOP_DELAY_MINUTES  5 // ５分
//#define LOOP_DELAY_MINUTES  1 // １分
#define MINUTE  60000 // 60秒=60,000ミリ秒

// 自動調整（使わない方がよさそう？）
//#define AUTO_CALIBRATION
#ifdef AUTO_CALIBRATION
int autoCalibration = 1;
#else
int autoCalibration = 0;
#endif

// 手動調整（ZERO　CALIBRATION）
// #defineを有効にせず，ディジタルピン６をGNDにつなぐ
//const int zeroCalibrationPin =  6;
//#define ZERO_CALIBRATION
//#ifdef ZERO_CALIBRATION
//bool zeroCalibration = true;
//#else
//bool zeroCalibration = false;
//#endif

// LOW POWERで動作させるときは，有効にする．
#define LOW_POWER
#ifdef LOW_POWER
int lowPower = 1;
#else
int lowPower = 0;
#endif

// 1回毎にWi-Fiをクローズ
#define WIFI_END
#define WIFI_END_TIME 3000
#ifdef WIFI_END
int wifiEnd = 1;
#else
int wifiEnd = 0;
#endif

// CO2センサーがあるときは，有効にする．
// #define CO2
#ifdef CO2
int co2Sensor = 1;
#else
int co2Sensor = 0;
#endif

#define MHZ19_BAUD_RATE 9600
#define CO2_MINIMUM_VALUE 405
#define CO2_CORRECTION_VALUE 16 // 外気は，408 + 16 = 424 になる．多分．
#define CO2_LED_GREEN_MINIMUMB_VALUE 768
#define CO2_LED_RED_MINIMUMB_VALUE 1024
#define CO2_LED_PURPLE_MINIMUMB_VALUE 1536

// 温度センサーがあるときは，有効にする．
#define Temperature
//#define Temperature_Bme680
#define BME280_I2C_ADDRESS  0x76
#ifdef Temperature
//#ifdef Temperature_Bme680
int temperatureSensor = 1;
#else
int temperatureSensor = 0;
#endif
