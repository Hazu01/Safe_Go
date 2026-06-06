import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/UI/driver/driver_bottom_nav.dart';
import 'package:safe_go/UI/driver/ride_requests_vm.dart';

class RideRequestsScreen extends StatelessWidget {
  const RideRequestsScreen({super.key});

  final Color darkBg = const Color(0xFF0F172A);
  final Color cardBg = const Color(0xFF1E293B);
  final Color accentBlue = const Color(0xFF0084FF);

  @override
  Widget build(BuildContext context) {
    final DriverRideRequestsVM vm = Get.find<DriverRideRequestsVM>();
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Ride Requests',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (vm.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: ${vm.errorMessage.value}',
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        if (vm.pendingRides.isEmpty) {
          return const Center(
            child: Text(
              'No pending ride requests',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.pendingRides.length,
          itemBuilder: (context, index) {
            final ride = vm.pendingRides[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildRequestCard(
                vm: vm,
                ride: ride,
              ),
            );
          },
        );
      }),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 1),
    );
  }

  Widget _buildRequestCard({
    required DriverRideRequestsVM vm,
    required RideRequest ride,
  }) {
    const String name = 'Passenger';
    const String rating = '4.9';
    final String pickup = ride.pickupLocation;
    final String dropoff = ride.dropoffLocation;
    const String duration = '';
    const String imageUrl = 'https://i.pravatar.cc/150?img=1';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
           
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(" $rating", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRouteLine(pickup, dropoff),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 32),

           
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSmallStat(Icons.account_balance_wallet_outlined, ride.offeredFare != null ? 'PKR ${ride.offeredFare}' : 'N/A'),
              _buildSmallStat(Icons.payment, ride.paymentMethod ?? 'Cash'),
              _buildSmallStat(Icons.people_outline, '${ride.passengers}'),
            ],
          ),
          const SizedBox(height: 20),

           
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => vm.rejectRide(ride),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Reject', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => vm.acceptRide(ride),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Accept', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteLine(String pickup, String dropoff) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.radio_button_checked, color: accentBlue, size: 16),
            const SizedBox(width: 12),
            Expanded(child: Text(pickup, style: const TextStyle(color: Colors.white70, fontSize: 14))),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 7),
          height: 20,
          width: 2,
          color: Colors.white24,
        ),
        Row(
          children: [
            Icon(Icons.location_on, color: accentBlue, size: 16),
            const SizedBox(width: 12),
            Expanded(child: Text(dropoff, style: const TextStyle(color: Colors.white70, fontSize: 14))),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallStat(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 18),
        const SizedBox(width: 6),
        Text(value, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      ],
    );
  }
}