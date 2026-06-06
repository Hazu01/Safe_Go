import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/Widgets/live_map.dart';
import 'package:safe_go/UI/driver/update_ride_status_vm.dart';

class UpdateRideStatusScreen extends StatelessWidget {
  const UpdateRideStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UpdateRideStatusVM vm = Get.find<UpdateRideStatusVM>();

     
    const Color darkBackground = Color(0xFF101317);
    const Color cardBackground = Color(0xFF363D49);
    const Color accentBlue = Color(0xFF007AFF);
    const Color iconBoxColor = Color(0xFF1A222C);

    return Scaffold(
      body: Obx(() {
        final ride = vm.ride.value;
        if (ride == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
             
            const Positioned.fill(
              child: LiveMap(isInteractive: true),
            ),

             
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Expanded(
                          child: Text(
                            "To: ${ride.dropoffLocation}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                 
                 
                 

                 
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
                    decoration: const BoxDecoration(
                      color: darkBackground,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 20),

                         
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFFF8C8B5),  
                              child: Icon(Icons.person, size: 40, color: Colors.white),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() => Text(
                                    vm.passengerName.value ?? 'Loading...',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                  Text(
                                    "${ride.passengers} Passenger(s)",
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                         
                        _buildLocationRow(Icons.radio_button_checked, "Pickup: ${ride.pickupLocation}", iconBoxColor),
                        const SizedBox(height: 16),
                        _buildLocationRow(Icons.location_on, "Drop-off: ${ride.dropoffLocation}", iconBoxColor),
                        const SizedBox(height: 25),

                         
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: vm.isWorking.value ? null : vm.onPrimaryAction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: vm.isWorking.value
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    vm.primaryButtonText,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      }

       
      Widget _buildLocationRow(IconData icon, String text, Color boxColor) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF007AFF), size: 20),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      }
    }
