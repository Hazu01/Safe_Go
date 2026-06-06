import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/UI/driver/driver_bottom_nav.dart';
import 'package:safe_go/UI/driver/driver_history_vm.dart';

class DriverHistoryScreen extends StatelessWidget {
  const DriverHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DriverHistoryVM vm = Get.find<DriverHistoryVM>();

    const Color darkBg = Color(0xFF0F172A);
    const Color cardBg = Color(0xFF1E293B);
    const Color accentBlue = Color(0xFF0084FF);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text('Ride History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: darkBg,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offAllNamed('/driver/dashboard'),
        ),
      ),
      body: Obx(() {
        if (vm.rides.isEmpty) {
          return const Center(
            child: Text(
              'No completed rides yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.rides.length,
          itemBuilder: (context, index) {
            final ride = vm.rides[index];
            return GestureDetector(
              onTap: () => Get.toNamed('/driver/completed', arguments: {'rideId': ride.id, 'viewOnly': true}),
              child: _buildHistoryCard(ride, cardBg, accentBlue, () => vm.deleteRide(ride.id)),
            );
          },
        );
      }),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHistoryCard(RideRequest ride, Color cardBg, Color accentColor, VoidCallback onDelete) {
    final dateStr = DateFormat('MMM dd, yyyy • hh:mm a').format(ride.createdAt);
    final isCompleted = ride.status == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           // Header: Date, Status, Delete
          Row(
            children: [
              Text(dateStr, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  ride.status.toUpperCase(),
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.delete_outline, color: Colors.white54, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Locations
          Row(
            children: [
              const Icon(Icons.radio_button_checked, color: Colors.green, size: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ride.pickupLocation,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Container(
              height: 12,
              width: 2,
              color: Colors.white12,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ride.dropoffLocation,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),

          // Footer: Fare and Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Earnings', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    ride.offeredFare != null ? 'PKR ${ride.offeredFare}' : 'N/A',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              if (ride.rating != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Rating', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          ride.rating!.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
