import 'package:json_annotation/json_annotation.dart';

part 'usgs_response.g.dart';

/// USGS API response model
@JsonSerializable()
class USGSResponse {
  final String name;
  final List<USGSValue> timeSeries;

  const USGSResponse({
    required this.name,
    required this.timeSeries,
  });

  factory USGSResponse.fromJson(Map<String, dynamic> json) => _$USGSResponseFromJson(json);
  Map<String, dynamic> toJson() => _$USGSResponseToJson(this);
}

/// USGS time series value model
@JsonSerializable()
class USGSValue {
  final String name;
  final String unit;
  final List<USGSDataPoint> values;

  const USGSValue({
    required this.name,
    required this.unit,
    required this.values,
  });

  factory USGSValue.fromJson(Map<String, dynamic> json) => _$USGSValueFromJson(json);
  Map<String, dynamic> toJson() => _$USGSValueToJson(this);
}

/// USGS data point model
@JsonSerializable()
class USGSDataPoint {
  @JsonKey(name: 'dateTime')
  final DateTime dateTime;
  final double value;
  final String qualifiers;

  const USGSDataPoint({
    required this.dateTime,
    required this.value,
    required this.qualifiers,
  });

  factory USGSDataPoint.fromJson(Map<String, dynamic> json) => _$USGSDataPointFromJson(json);
  Map<String, dynamic> toJson() => _$USGSDataPointToJson(this);
} 