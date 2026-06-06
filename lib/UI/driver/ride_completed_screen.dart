import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safe_go/UI/driver/trip_completed_vm.dart';

class TripCompletedScreen extends GetView<TripCompletedVM> {
  const TripCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0F172A);
    const Color cardBg = Color(0xFF1E293B);
    const Color accentBlue = Color(0xFF0084FF);
    const Color successGreen = Color(0xFF4CAF50);

    final args = Get.arguments as Map<String, dynamic>?;
    final bool viewOnly = args?['viewOnly'] ?? false;

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: Text(viewOnly ? 'Ride Details' : 'Ride Completed!',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: viewOnly,
        leading: viewOnly 
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white), 
              onPressed: () => Get.back()
            )
          : null,
        actions: [
          if (!viewOnly)
            TextButton(
              onPressed: () {
                 Get.offAllNamed('/driver/dashboard');
              },
              child: const Text('Done', style: TextStyle(color: accentBlue, fontSize: 16)),
            )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ride = controller.ride.value;
        final passengerName = controller.passengerName.value;

        if (ride == null) {
          return const Center(child: Text('Ride details not available', style: TextStyle(color: Colors.white)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
               // Map Section
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: (ride.pickupLat != null && ride.pickupLng != null) 
                          ? LatLng(ride.pickupLat!, ride.pickupLng!) 
                          : const LatLng(30.6953, 76.8546),
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.safego.app',
                      ),
                      if (ride.pickupLat != null && ride.pickupLng != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(ride.pickupLat!, ride.pickupLng!),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on, color: Colors.green, size: 40),
                            ),
                             if (ride.dropoffLat != null && ride.dropoffLng != null)
                              Marker(
                                point: LatLng(ride.dropoffLat!, ride.dropoffLng!),
                                width: 40,
                                height: 40,
                                child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Stats Section
              _buildStatRow('Duration', '18 min'), // Placeholder or calculate if timestamps valid
              const Divider(color: Colors.white10, height: 24),
              // Calculate distance using latlong2
              _buildStatRow('Distance', () {
                 if (ride.pickupLat != null && ride.pickupLng != null &&
                     ride.dropoffLat != null && ride.dropoffLng != null) {
                    final Distance distance = const Distance();
                    final double km = distance.as(LengthUnit.Kilometer,
                        LatLng(ride.pickupLat!, ride.pickupLng!),
                        LatLng(ride.dropoffLat!, ride.dropoffLng!));
                    return '${km.toStringAsFixed(1)} km';
                 }
                 return 'N/A';
              }()),
              const Divider(color: Colors.white10, height: 24),
              _buildStatRow('Total Earnings', 'PKR ${ride.offeredFare ?? 0.0}', isFare: true),
              const SizedBox(height: 32),

              // Passenger Info
              Row(
                children: [
                   const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(passengerName ?? 'Passenger',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Passenger',
                          style: TextStyle(color: Colors.white54, fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

               // Find Next Ride Button
              if (!viewOnly) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed('/driver/dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: successGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Find Next Ride',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/driver/history');
                  },
                  child: const Text('View Ride History',
                      style: TextStyle(color: accentBlue, fontSize: 16)),
                ),
                const SizedBox(height: 20),
              ]
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isFare = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 16)),
        Text(value,
            style: TextStyle(
                color: isFare ? Colors.greenAccent : Colors.white,
                fontSize: 16,
                fontWeight: isFare ? FontWeight.bold : FontWeight.normal
            )),
      ],
    );
  }
}