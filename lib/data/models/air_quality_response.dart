/// Air Quality API response models for AirNow
class AirQualityResponse {
  final List<AirQualityObservation> observations;

  const AirQualityResponse({required this.observations});

  factory AirQualityResponse.fromJson(dynamic json) {
    if (json is List) {
      return AirQualityResponse(
        observations: json
            .map((e) => AirQualityObservation.fromJson(e))
            .toList(),
      );
    } else if (json is Map<String, dynamic>) {
      // Handle case where it might be wrapped in an object
      final observations = json['observations'] as List? ?? [];
      return AirQualityResponse(
        observations: observations
            .map((e) => AirQualityObservation.fromJson(e))
            .toList(),
      );
    }
    return const AirQualityResponse(observations: []);
  }
}

class AirQualityObservation {
  final DateTime dateObserved;
  final int aqi;
  final String category;
  final String parameterName;
  final double latitude;
  final double longitude;

  const AirQualityObservation({
    required this.dateObserved,
    required this.aqi,
    required this.category,
    required this.parameterName,
    required this.latitude,
    required this.longitude,
  });

  factory AirQualityObservation.fromJson(Map<String, dynamic> json) {
    return AirQualityObservation(
      dateObserved: DateTime.parse(json['DateObserved'] ?? DateTime.now().toIso8601String()),
      aqi: json['AQI'] ?? 0,
      category: json['Category']['Name'] ?? 'Unknown',
      parameterName: json['ParameterName'] ?? 'Unknown',
      latitude: (json['Latitude'] ?? 0).toDouble(),
      longitude: (json['Longitude'] ?? 0).toDouble(),
    );
  }
} 