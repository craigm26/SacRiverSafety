/// API configuration constants
class ApiConfig {
  // USGS Water Data API
  static const String usgsBaseUrl = 'https://waterservices.usgs.gov/nwis/';
  static const String usgsInstantaneousUrl = '${usgsBaseUrl}iv/';
  static const String usgsDailyUrl = '${usgsBaseUrl}dv/';
  
  // National Weather Service API
  static const String weatherBaseUrl = 'https://api.weather.gov/';
  static const String weatherStationsUrl = '${weatherBaseUrl}stations/';
  static const String weatherAlertsUrl = '${weatherBaseUrl}alerts/active';
  
  // AirNow Air Quality API
  static const String airNowBaseUrl = 'https://www.airnowapi.org/aq/';
  static const String airNowObservationUrl = '${airNowBaseUrl}observation/zipCode/current/';
  
  // Drowning Statistics APIs
  static const String cdphEpicenterUrl = 'https://epicenter.cdph.ca.gov/api/';
  static const String sacCountyParksUrl = 'https://regionalparks.saccounty.gov/api/';
  static const String usaceFatalityUrl = 'https://www.usace.army.mil/api/recreation/fatalities/';
  static const String americanWhitewaterUrl = 'https://www.americanwhitewater.org/api/accidents/';
  
  // API Keys (set via environment variables)
  static const String airNowApiKey = String.fromEnvironment('AIRNOW_API_KEY', defaultValue: '');
  
  // Sacramento area weather stations
  static const List<String> sacramentoWeatherStations = [
    'KSAC', // Sacramento Executive Airport
    'KSMF', // Sacramento International Airport
  ];
  
  // Sacramento area ZIP codes for air quality
  static const List<String> sacramentoZipCodes = [
    '95814', // Downtown Sacramento
    '95816', // Midtown Sacramento
    '95818', // East Sacramento
    '95819', // Land Park
    '95820', // Curtis Park
    '95821', // Tahoe Park
    '95822', // Oak Park
    '95823', // Meadowview
    '95824', // Parkway
    '95825', // College Glen
    '95826', // Rosemont
    '95827', // Arden-Arcade
    '95828', // Rancho Cordova
    '95829', // South Sacramento
    '95830', // Del Paso Heights
    '95831', // North Sacramento
    '95832', // Natomas
    '95833', // North Highlands
    '95834', // Antelope
    '95835', // Rio Linda
  ];
  
  // Cache configuration
  static const Duration riverDataCache = Duration(minutes: 15);
  static const Duration weatherCache = Duration(minutes: 30);
  static const Duration airQualityCache = Duration(hours: 1);
  static const Duration alertsCache = Duration(minutes: 5);
  
  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
} 