import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/passenger/ride_status_vm.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Models/DriverProfile.dart';
import 'package:safe_go/UI/Widgets/live_map.dart';

class RideStatusScreen extends StatefulWidget {
  const RideStatusScreen({super.key});

  @override
  State<RideStatusScreen> createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  final RideStatusVM vm = Get.find<RideStatusVM>();

  final Color darkBg = const Color(0xFF0F172A);
  final Color cardBg = const Color(0xFF1E293B);
  final Color accentBlue = const Color(0xFF0084FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final ride = vm.ride.value;
        final statusText = _statusText(ride?.status ?? 'pending');
        return Stack(
          children: [
             
            // Map Layer instead of placeholder
             const Positioned.fill(
               child: LiveMap(isInteractive: true),
            ),

             
            _buildTopBar(statusText),

             
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildDriverInfoCard(ride, vm.driver.value),
            ),
          ],
        );
      }),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'accepted':
        return 'Driver accepted your ride';
      case 'on_the_way':
        return 'Driver is on the way';
      case 'completed':
        return 'Ride completed';
      default:
        return 'Waiting for driver...';
    }
  }

  Widget _buildTopBar(String statusText) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildCircleButton(Icons.arrow_back, () {
               Get.back();
            }),
            const Spacer(),
            _buildStatusChip(statusText),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDriverInfoCard(RideRequest? ride, DriverProfile? driver) {
    if (ride == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: darkBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 20)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           
          if (driver != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 28, 
                  backgroundColor: Colors.orangeAccent, 
                  backgroundImage: (driver.profileImage != null && driver.profileImage!.isNotEmpty)
                      ? NetworkImage(driver.profileImage!)
                      : null,
                  child: (driver.profileImage == null || driver.profileImage!.isEmpty)
                      ? const Icon(Icons.person, size: 30)
                      : null
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${driver.vehicleModel} • ${driver.plateNumber}',
                          style: const TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ],
                  ),
                ),
                Column(
                  children: [
                    Text('${driver.rating?.toStringAsFixed(1) ?? '0.0'} ⭐', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('${driver.ratingCount} Rides', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Contact Info
            if (driver.phone != null && driver.phone!.isNotEmpty)
              _buildContactRow(Icons.phone, driver.phone!),
            if (driver.pendingEmail != null && driver.pendingEmail!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildContactRow(Icons.email, driver.pendingEmail!)
            ],
            const Divider(color: Colors.white10, height: 32),
          ] else ...[
             // Placeholder if driver not yet fetched (e.g. accepted but profile loading)
             const Text("Loading Driver Details...", style: TextStyle(color: Colors.white70)),
             const SizedBox(height: 16),
          ],

           
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildCircleActionButton(Icons.close, Colors.red.withOpacity(0.2), Colors.redAccent, () {
                  vm.cancelRide();
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: cardBg, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCircleActionButton(IconData icon, Color bg, Color iconColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 24),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }
}