import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sacriversafety/domain/entities/river_gauge.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';


class RiverMapWidget extends StatefulWidget {
  final List<RiverGauge> riverGauges;
  final List<TrailAmenity> amenities;
  final List<SafetyAlert> safetyAlerts;
  final Function(RiverGauge)? onGaugeTap;
  final Function(TrailAmenity)? onAmenityTap;
  final Function(SafetyAlert)? onAlertTap;
  final bool showRiverGauges;
  final bool showAmenities;
  final bool showSafetyAlerts;

  const RiverMapWidget({
    super.key,
    required this.riverGauges,
    required this.amenities,
    required this.safetyAlerts,
    this.onGaugeTap,
    this.onAmenityTap,
    this.onAlertTap,
    this.showRiverGauges = true,
    this.showAmenities = true,
    this.showSafetyAlerts = true,
  });

  @override
  State<RiverMapWidget> createState() => _RiverMapWidgetState();
}

class _RiverMapWidgetState extends State<RiverMapWidget> {
  final MapController _mapController = MapController();
  late List<Marker> _markers;
  late List<CircleMarker> _circles;

  @override
  void initState() {
    super.initState();
    _buildMapElements();
  }

  @override
  void didUpdateWidget(RiverMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.riverGauges != widget.riverGauges ||
        oldWidget.amenities != widget.amenities ||
        oldWidget.safetyAlerts != widget.safetyAlerts ||
        oldWidget.showRiverGauges != widget.showRiverGauges ||
        oldWidget.showAmenities != widget.showAmenities ||
        oldWidget.showSafetyAlerts != widget.showSafetyAlerts) {
      _buildMapElements();
    }
  }

  void _buildMapElements() {
    _markers = [];
    _circles = [];

    // Add river gauge markers
    if (widget.showRiverGauges) {
      for (final gauge in widget.riverGauges) {
        _markers.add(
          Marker(
            point: LatLng(gauge.latitude, gauge.longitude),
            width: 40,
            height: 40,
            child: _buildRiverGaugeMarker(gauge),
          ),
        );
      }
    }

    // Add amenity markers
    if (widget.showAmenities) {
      for (final amenity in widget.amenities) {
        if (amenity.isOperational) {
          _markers.add(
            Marker(
              point: LatLng(amenity.latitude, amenity.longitude),
              width: 30,
              height: 30,
              child: _buildAmenityMarker(amenity),
            ),
          );
        }
      }
    }

    // Add safety alert circles
    if (widget.showSafetyAlerts) {
      for (final alert in widget.safetyAlerts) {
        if (alert.isActive) {
          _circles.add(
            CircleMarker(
              point: LatLng(alert.latitude, alert.longitude),
              radius: alert.radius,
              color: _getAlertColor(alert.severity).withOpacity(0.3),
              borderColor: _getAlertColor(alert.severity),
              borderStrokeWidth: 2,
            ),
          );
        }
      }
    }
  }

  Color _getSafetyColor(String safetyLevel) {
    switch (safetyLevel.toLowerCase()) {
      case 'safe':
        return Colors.green;
      case 'caution':
        return Colors.orange;
      case 'danger':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getAlertColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'low':
        return Colors.yellow;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'critical':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRiverGaugeMarker(RiverGauge gauge) {
    final safetyColor = _getSafetyColor(gauge.safetyLevel);

    return GestureDetector(
      onTap: () => widget.onGaugeTap?.call(gauge),
      child: Container(
        decoration: BoxDecoration(
          color: safetyColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.water_drop,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildAmenityMarker(TrailAmenity amenity) {
    IconData icon;
    Color color;

    switch (amenity.type) {
      case 'water':
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case 'restroom':
        icon = Icons.wc;
        color = Colors.green;
        break;
      case 'emergency_callbox':
        icon = Icons.phone;
        color = Colors.red;
        break;
      case 'ranger_station':
        icon = Icons.local_police;
        color = Colors.orange;
        break;
      default:
        icon = Icons.place;
        color = Colors.grey;
    }

    return GestureDetector(
      onTap: () => widget.onAmenityTap?.call(amenity),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(38.5901, -121.3442), // Sacramento area
        initialZoom: 11.0,
        minZoom: 9.0,
        maxZoom: 18.0,
        onTap: (point, latLng) => _handleMapTap(latLng),
      ),
      children: [
        // Base map layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.riversafe.sac',
          maxZoom: 18,
          minZoom: 9,
        ),
        // Safety alert circles
        CircleLayer(
          circles: _circles,
        ),
        // Markers layer
        MarkerLayer(
          markers: _markers,
        ),
      ],
    );
  }

  void _handleMapTap(LatLng latLng) {
    // Handle map tap if needed
  }
} 