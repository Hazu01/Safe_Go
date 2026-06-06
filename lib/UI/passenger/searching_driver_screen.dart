import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/Widgets/live_map.dart';
import 'package:safe_go/UI/passenger/searching_driver_vm.dart';

class SearchingDriverScreen extends StatefulWidget {
  const SearchingDriverScreen({super.key});

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen> {
  final SearchingDriverVM vm = Get.find<SearchingDriverVM>();

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF1E2630);  


    return Scaffold(
      backgroundColor: darkBg,
      body: Stack(
        children: [
          // Background Map
          const Positioned.fill(
            child: LiveMap(),
          ),

          // Back Button
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                   // Ensure we cancel or just back? Usually just back allow continuing in background?
                   // User said "bring me back", usually implies navigation.
                   // If we go back, the searching might continue? 
                   // Safest is just Get.back() for navigation.
                   Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E2630), // Match dark theme
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),

          // Searching Progress Bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(child: LinearProgressIndicator(minHeight: 4, color: Color(0xFF0084FF))),
          ),

          // Bottom Sheet with Driver List
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 400, // Fixed height or use DraggableScrollableSheet for better UX
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E2630),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 10)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Drivers',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select a driver to confirm your ride.',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  
                  // Driver List
                  Expanded(
                    child: Obx(() {
                      if (vm.availableDrivers.isEmpty) {
                         return const Center(
                           child: Text("Searching for nearby drivers...", style: TextStyle(color: Colors.white70)),
                         );
                      }
                      return ListView.builder(
                        itemCount: vm.availableDrivers.length,
                        itemBuilder: (context, index) {
                          final driver = vm.availableDrivers[index];
                          return Card(
                            color: const Color(0xFF2A3440),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orangeAccent,
                                backgroundImage: (driver.profilePicture != null && driver.profilePicture!.isNotEmpty)
                                    ? NetworkImage(driver.profilePicture!)
                                    : null,
                                child: (driver.profilePicture == null || driver.profilePicture!.isEmpty)
                                    ? const Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              title: Text(driver.displayName ?? 'Driver', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (driver.vehicleModel != null && driver.vehicleModel!.isNotEmpty)
                                    Text('${driver.vehicleModel} • ${driver.plateNumber ?? ""}',
                                        style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                  if (driver.phone != null && driver.phone!.isNotEmpty)
                                    Text(driver.phone!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                  if (vm.ride.value?.duration != null)
                                    Text("Est. Duration: ${vm.ride.value!.duration}", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: ElevatedButton(
                                onPressed: () => vm.selectDriver(driver.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0084FF),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: const Text("Select"),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: vm.cancelRide,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel Request', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
