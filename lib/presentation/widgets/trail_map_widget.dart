import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sacriversafety/domain/entities/trail_amenity.dart';
import 'package:sacriversafety/domain/entities/safety_alert.dart';
import 'package:sacriversafety/domain/entities/trail_incident.dart';
import 'package:sacriversafety/domain/entities/drowning_incident.dart';
import 'package:sacriversafety/presentation/cubits/trail_safety_cubit.dart';

class TrailMapWidget extends StatefulWidget {
  final List<TrailAmenity> amenities;
  final List<SafetyAlert> safetyAlerts;
  final List<TrailIncident> incidents;
  final List<DrowningIncident> drowningIncidents;
  final bool showAmenities;
  final bool showSafetyAlerts;
  final bool showIncidents;
  final bool showDrowningIncidents;
  final bool showMileMarkers;
  final Function(TrailAmenity)? onAmenityTap;
  final Function(SafetyAlert)? onAlertTap;
  final Function(TrailIncident)? onIncidentTap;
  final Function(DrowningIncident)? onDrowningIncidentTap;

  const TrailMapWidget({
    super.key,
    required this.amenities,
    required this.safetyAlerts,
    required this.incidents,
    this.drowningIncidents = const [],
    this.showAmenities = true,
    this.showSafetyAlerts = true,
    this.showIncidents = true,
    this.showDrowningIncidents = true,
    this.showMileMarkers = true,
    this.onAmenityTap,
    this.onAlertTap,
    this.onIncidentTap,
    this.onDrowningIncidentTap,
  });

  @override
  State<TrailMapWidget> createState() => _TrailMapWidgetState();
}

class _TrailMapWidgetState extends State<TrailMapWidget> {
  late MapController _mapController;
  late List<LatLng> _trailPath;
  late List<MileMarker> _mileMarkers;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeTrailData();
  }

  void _initializeTrailData() {
    // American River Parkway trail path (real coordinates from ARPF parks)
    _trailPath = [
      const LatLng(38.5901, -121.3442), // Discovery Park (Mile 0)
      const LatLng(38.5925, -121.3475), // Mile 1
      const LatLng(38.5950, -121.3500), // Mile 2
      const LatLng(38.5975, -121.3525), // Mile 3
      const LatLng(38.6000, -121.3550), // Mile 4 - Howe Ave River Access
      const LatLng(38.6025, -121.3575), // Mile 5
      const LatLng(38.6050, -121.3600), // Mile 6
      const LatLng(38.6075, -121.3625), // Mile 7
      const LatLng(38.6100, -121.3650), // Mile 8
      const LatLng(38.6125, -121.3675), // Mile 9
      const LatLng(38.6150, -121.3700), // Mile 10
      const LatLng(38.6175, -121.3725), // Mile 11
      const LatLng(38.6200, -121.3750), // Mile 12
      const LatLng(38.6225, -121.3775), // Mile 13
      const LatLng(38.6250, -121.3800), // Mile 14
      const LatLng(38.6275, -121.3825), // Mile 15
      const LatLng(38.6283, -121.3283), // William B Pond Park (Mile 16)
    ];

    // Mile markers along the trail (based on ARPF parks data)
    _mileMarkers = [
      MileMarker(0, const LatLng(38.5901, -121.3442), 'Discovery Park'),
      MileMarker(1, const LatLng(38.5925, -121.3475), 'Mile 1'),
      MileMarker(2, const LatLng(38.5950, -121.3500), 'Mile 2'),
      MileMarker(3, const LatLng(38.5975, -121.3525), 'Mile 3'),
      MileMarker(4, const LatLng(38.6000, -121.3550), 'Howe Ave River Access'),
      MileMarker(5, const LatLng(38.6025, -121.3575), 'Mile 5'),
      MileMarker(6, const LatLng(38.6050, -121.3600), 'Mile 6'),
      MileMarker(7, const LatLng(38.6075, -121.3625), 'Mile 7'),
      MileMarker(8, const LatLng(38.6100, -121.3650), 'Mile 8'),
      MileMarker(9, const LatLng(38.6125, -121.3675), 'Mile 9'),
      MileMarker(10, const LatLng(38.6150, -121.3700), 'Mile 10'),
      MileMarker(11, const LatLng(38.6175, -121.3725), 'Mile 11'),
      MileMarker(12, const LatLng(38.6200, -121.3750), 'Mile 12'),
      MileMarker(13, const LatLng(38.6225, -121.3775), 'Mile 13'),
      MileMarker(14, const LatLng(38.6250, -121.3800), 'Mile 14'),
      MileMarker(15, const LatLng(38.6275, -121.3825), 'Mile 15'),
      MileMarker(16, const LatLng(38.6283, -121.3283), 'William B Pond Park'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(38.6100, -121.3600), // Center of trail
        initialZoom: 12.0,
        minZoom: 10.0,
        maxZoom: 18.0,
      ),
      children: [
        // Base tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.sacriversafety.app',
        ),
        
        // Trail path
        PolylineLayer(
          polylines: [
            Polyline(
              points: _trailPath,
              strokeWidth: 4.0,
              color: Colors.blue.shade600,
            ),
          ],
        ),
        
        // Mile markers
        if (widget.showMileMarkers)
          MarkerLayer(
            markers: _mileMarkers.map((marker) => Marker(
              point: marker.position,
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showMileMarkerInfo(context, marker),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      marker.mile.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            )).toList(),
          ),
        
        // Amenities
        if (widget.showAmenities)
          MarkerLayer(
            markers: widget.amenities.map((amenity) => Marker(
              point: LatLng(amenity.latitude, amenity.longitude),
              width: 30,
              height: 30,
              child: GestureDetector(
                onTap: () => widget.onAmenityTap?.call(amenity),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getAmenityColor(amenity.type),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getAmenityIcon(amenity.type),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            )).toList(),
          ),
        
        // Safety alerts
        if (widget.showSafetyAlerts)
          MarkerLayer(
            markers: widget.safetyAlerts.map((alert) => Marker(
              point: LatLng(alert.latitude, alert.longitude),
              width: 35,
              height: 35,
              child: GestureDetector(
                onTap: () => widget.onAlertTap?.call(alert),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getAlertColor(alert.severity),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            )).toList(),
          ),
        
        // Incidents
        if (widget.showIncidents)
          MarkerLayer(
            markers: widget.incidents.map((incident) => Marker(
              point: LatLng(incident.latitude, incident.longitude),
              width: 32,
              height: 32,
              child: GestureDetector(
                onTap: () => widget.onIncidentTap?.call(incident),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getIncidentColor(incident.severity),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIncidentIcon(incident.type),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            )).toList(),
          ),
        
        // Drowning incidents
        if (widget.showDrowningIncidents)
          MarkerLayer(
            markers: widget.drowningIncidents.map((incident) => Marker(
              point: LatLng(incident.latitude, incident.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => widget.onDrowningIncidentTap?.call(incident),
                child: Container(
                  decoration: BoxDecoration(
                    color: incident.severityColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            )).toList(),
          ),
      ],
    );
  }

  void _showMileMarkerInfo(BuildContext context, MileMarker marker) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              marker.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Mile ${marker.mile}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMileMarkerInfo(marker),
          ],
        ),
      ),
    );
  }

  Widget _buildMileMarkerInfo(MileMarker marker) {
    // Get amenities near this mile marker
    final nearbyAmenities = widget.amenities.where((amenity) {
      final distance = _calculateDistance(
        marker.position.latitude,
        marker.position.longitude,
        amenity.latitude,
        amenity.longitude,
      );
      return distance < 0.5; // Within 0.5 km
    }).toList();

    // Get incidents near this mile marker
    final nearbyIncidents = widget.incidents.where((incident) {
      final distance = _calculateDistance(
        marker.position.latitude,
        marker.position.longitude,
        incident.latitude,
        incident.longitude,
      );
      return distance < 1.0; // Within 1 km
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (nearbyAmenities.isNotEmpty) ...[
          Text(
            'Nearby Amenities',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...nearbyAmenities.map((amenity) => ListTile(
            leading: Icon(_getAmenityIcon(amenity.type), color: _getAmenityColor(amenity.type)),
            title: Text(amenity.name),
            subtitle: Text(amenity.description ?? ''),
            dense: true,
          )),
          const SizedBox(height: 16),
        ],
        if (nearbyIncidents.isNotEmpty) ...[
          Text(
            'Recent Incidents',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...nearbyIncidents.map((incident) => ListTile(
            leading: Icon(_getIncidentIcon(incident.type), color: _getIncidentColor(incident.severity)),
            title: Text(incident.type.replaceAll('-', ' ').toUpperCase()),
            subtitle: Text(incident.description ?? ''),
            dense: true,
          )),
        ],
      ],
    );
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simple distance calculation (not precise but sufficient for this use case)
    const double earthRadius = 6371; // km
    final dLat = (lat2 - lat1) * (pi / 180);
    final dLon = (lon2 - lon1) * (pi / 180);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(lat1 * pi / 180) * sin(lat2 * pi / 180) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  Color _getAmenityColor(String type) {
    switch (type) {
      case 'water':
        return Colors.blue;
      case 'restroom':
        return Colors.green;
      case 'emergency_callbox':
        return Colors.red;
      case 'ranger_station':
        return Colors.orange;
      case 'parking':
        return Colors.purple;
      case 'picnic':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getAmenityIcon(String type) {
    switch (type) {
      case 'water':
        return Icons.water_drop;
      case 'restroom':
        return Icons.wc;
      case 'emergency_callbox':
        return Icons.emergency;
      case 'ranger_station':
        return Icons.local_police;
      case 'parking':
        return Icons.local_parking;
      case 'picnic':
        return Icons.table_restaurant;
      default:
        return Icons.place;
    }
  }

  Color _getAlertColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  Color _getIncidentColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'injury':
      case 'medical':
        return Colors.red;
      case 'minor':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getIncidentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bike-ped collision':
        return Icons.directions_bike;
      case 'heat-related rescue':
        return Icons.thermostat;
      case 'dog incident':
        return Icons.pets;
      default:
        return Icons.warning;
    }
  }
}

class MileMarker {
  final int mile;
  final LatLng position;
  final String name;

  MileMarker(this.mile, this.position, this.name);
} 