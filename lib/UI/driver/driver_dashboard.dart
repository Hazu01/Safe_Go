import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/UI/driver/driver_bottom_nav.dart';
import 'package:safe_go/UI/driver/driver_dashboard_vm.dart';
import 'package:safe_go/UI/driver/ride_requests_vm.dart';
import 'package:safe_go/UI/Widgets/live_map.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
   
  final Color darkBg = const Color(0xFF0F172A);
  final Color cardBg = const Color(0xFF1E293B);
  final Color accentBlue = const Color(0xFF0084FF);

  @override
  Widget build(BuildContext context) {
    final DriverDashboardVM dashVM = Get.find<DriverDashboardVM>();
    final DriverRideRequestsVM requestsVM = Get.find<DriverRideRequestsVM>();

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             
            _buildStatusToggle(dashVM),
            const SizedBox(height: 16),
            _buildEarningsCard(dashVM),


            const SizedBox(height: 24),
            Obx(() {
              final count = requestsVM.pendingRides.length;
              return Text(
                'New Requests${count > 0 ? " ($count)" : ""}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              );
            }),
            const SizedBox(height: 12),

             
            Obx(() {
              if (requestsVM.pendingRides.isEmpty) {
                return _buildEmptyState();
              }
              return _buildPendingRequestCard(requestsVM.pendingRides.first);
            }),
          ],
        ),
      ),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 0),
    );
  }

  Widget _buildStatusToggle(DriverDashboardVM vm) {
    return Obx(() {
      final online = vm.isAvailable.value;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Accepting Rides', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    online ? 'You are currently online and visible.' : 'You are currently offline.',
                    style: TextStyle(color: Colors.blueGrey[300], fontSize: 13),
                  ),
                ],
              ),
            ),
            Switch(
              value: online,
              activeTrackColor: accentBlue.withOpacity(0.5),
              activeColor: accentBlue,
              onChanged: (val) => vm.toggleAvailability(val),
            )
          ],
        ),
      );
    });
  }


  Widget _buildPendingRequestCard(RideRequest ride) {
    return Container(
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           
          Container(
            height: 140,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            clipBehavior: Clip.antiAlias,
            child: const LiveMap(isInteractive: false),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pickup: ${ride.pickupLocation}\nDrop-off: ${ride.dropoffLocation}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  'Passenger: ${ride.passengerId}',
                  style: const TextStyle(color: Colors.white38, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                           
                          Get.offAllNamed('/driver/requests');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('View All', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed('/driver/requests'),
                        style: ElevatedButton.styleFrom(backgroundColor: accentBlue, padding: const EdgeInsets.symmetric(vertical: 12)),
                        child: const Text('Open', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, Color color, String label, String address) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            Text(address, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        )
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.explore_outlined, color: accentBlue, size: 32),
          const SizedBox(height: 12),
          const Text("You're all caught up!", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("We'll notify you when new ride requests come in.",
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 13)),
        ],
      ),
    );
  }
  Widget _buildEarningsCard(DriverDashboardVM vm) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg, 
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Earnings', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Obx(() => Text(
                'PKR ${vm.totalEarnings.value.toStringAsFixed(2)}',

                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }
}
