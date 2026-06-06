import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_go/Data/Services/osrm_service.dart';

class LiveMap extends StatefulWidget {
  final List<Marker> markers;
  final bool isInteractive;
  final LatLng? pickup;
  final LatLng? dropoff;
  final Function(LatLng)? onMapCreated;
  final MapController? mapController;

  const LiveMap({
    super.key,
    this.markers = const [],
    this.isInteractive = true,
    this.pickup,
    this.dropoff,
    this.onMapCreated,
    this.mapController,
    this.currentLocation,
  });

  final LatLng? currentLocation;

  @override
  State<LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  late final MapController _mapController;
  final OSRMService _osrmService = OSRMService();
  
   
  LatLng _center = const LatLng(37.42796133580664, -122.085749655962);
  bool _isLoading = true;
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _mapController = widget.mapController ?? MapController();
    _determinePosition();
  }

  @override
  void didUpdateWidget(LiveMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pickup != oldWidget.pickup || widget.dropoff != oldWidget.dropoff) {
      _fetchRoute();
    }
  }

  Future<void> _fetchRoute() async {
    if (widget.pickup != null && widget.dropoff != null) {
      final points = await _osrmService.getRoute(widget.pickup!, widget.dropoff!);
      if (mounted) {
        setState(() {
          _routePoints = points;
        });
         
        if (points.isNotEmpty) {
            
           _mapController.move(widget.pickup!, 13);
        }
      }
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    } 

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      if (widget.onMapCreated != null) {
          widget.onMapCreated!(_center);
      }
    } catch (e) {
       setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    if (widget.mapController == null) {
      _mapController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _center,
        initialZoom: 15.0,
        interactionOptions: InteractionOptions(
          flags: widget.isInteractive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.safe_go',
        ),
        if (_routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
             
            Marker(
              point: widget.currentLocation ?? _center,
              width: 80,
              height: 80,
              child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
            ),
            ...widget.markers,
          ],
        ),
      ],
    );
  }
}
