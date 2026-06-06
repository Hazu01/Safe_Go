import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/UI/passenger/passenger_bottom_nav.dart';
import 'package:intl/intl.dart';

class PassengerHistoryScreen extends StatelessWidget {
  const PassengerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RideRepo rideRepo = Get.find();
    final AuthRepo authRepo = Get.find();
    final user = authRepo.getCurrentUser();

    const Color darkBg = Color(0xFF0F172A);
    const Color cardBg = Color(0xFF1E293B);

    if (user == null) {
      return const Scaffold(
        backgroundColor: darkBg,
        body: Center(child: Text("Please login to view activity", style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text('Activity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: darkBg,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<List<RideRequest>>(
        stream: rideRepo.passengerHistoryStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }

          final rides = snapshot.data ?? [];
          if (rides.isEmpty) {
            return const Center(child: Text("No recent activity", style: TextStyle(color: Colors.white70)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];
              return _buildHistoryCard(ride, cardBg);
            },
          );
        },
      ),
      bottomNavigationBar: const PassengerBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHistoryCard(RideRequest ride, Color cardBg) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateStr, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              Row(
                children: [
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
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                    onPressed: () => _confirmDelete(Get.context!, ride.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Pickup Location
          Row(
            children: [
              const Icon(Icons.my_location, color: Colors.green, size: 16),
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
          
          // Vertical Connector Line
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Container(
              height: 12,
              width: 2,
              color: Colors.white12,
            ),
          ),

          // Dropoff Location
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
          const SizedBox(height: 8),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ride.offeredFare != null ? 'PKR ${ride.offeredFare}' : 'N/A',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
               Text(
                ride.paymentMethod ?? 'Cash',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String rideId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text("Delete Ride", style: TextStyle(color: Colors.white)),
        content: const Text("Are you sure you want to delete this ride from history?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Get.find<RideRepo>().deleteRide(rideId);
              Get.snackbar("Success", "Ride deleted from history");
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
