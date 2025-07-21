/// Weather API response models for National Weather Service
class WeatherResponse {
  final WeatherProperties properties;

  const WeatherResponse({required this.properties});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      properties: WeatherProperties.fromJson(json['properties'] ?? {}),
    );
  }
}

class WeatherProperties {
  final List<WeatherPeriod> periods;
  final WeatherObservation? observation;

  const WeatherProperties({
    required this.periods,
    this.observation,
  });

  factory WeatherProperties.fromJson(Map<String, dynamic> json) {
    return WeatherProperties(
      periods: (json['periods'] as List?)
          ?.map((e) => WeatherPeriod.fromJson(e))
          .toList() ?? [],
      observation: json['observation'] != null 
          ? WeatherObservation.fromJson(json['observation'])
          : null,
    );
  }
}

class WeatherPeriod {
  final int number;
  final String name;
  final double temperature;
  final String shortForecast;
  final String detailedForecast;

  const WeatherPeriod({
    required this.number,
    required this.name,
    required this.temperature,
    required this.shortForecast,
    required this.detailedForecast,
  });

  factory WeatherPeriod.fromJson(Map<String, dynamic> json) {
    return WeatherPeriod(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      temperature: (json['temperature'] ?? 0).toDouble(),
      shortForecast: json['shortForecast'] ?? '',
      detailedForecast: json['detailedForecast'] ?? '',
    );
  }
}

class WeatherObservation {
  final double temperature;
  final String description;
  final DateTime timestamp;

  const WeatherObservation({
    required this.temperature,
    required this.description,
    required this.timestamp,
  });

  factory WeatherObservation.fromJson(Map<String, dynamic> json) {
    return WeatherObservation(
      temperature: (json['temperature'] ?? 0).toDouble(),
      description: json['textDescription'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
} 