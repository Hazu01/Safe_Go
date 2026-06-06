import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';  
import 'package:latlong2/latlong.dart';  
import 'package:geolocator/geolocator.dart';  
import 'package:safe_go/UI/passenger/ride_request_vm.dart';
import 'package:safe_go/UI/Widgets/live_map.dart';

class RequestRideUI extends StatefulWidget {
  const RequestRideUI({super.key});

  @override
  State<RequestRideUI> createState() => _RequestRideUIState();
}

class _RequestRideUIState extends State<RequestRideUI> {
  final Color darkBg = const Color(0xFF0F172A);
  final Color cardBg = const Color(0xFF1E293B);
  final Color accentBlue = const Color(0xFF0084FF);

  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  final TextEditingController _fareController = TextEditingController();
  int _passengers = 1;
  DateTime? _pickupTime;
  String _paymentMethod = 'Cash';
  final MapController _mapController = MapController();

  final RideRequestVM vm = Get.find<RideRequestVM>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
           
           
          Positioned.fill(
            child: LiveMap(mapController: _mapController),
          ),

           
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cardBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          vm.userName,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

           
          Positioned(
            right: 16,
            bottom: 340,  
            child: Column(
              children: [
                _buildMapActionButton(Icons.add, onTap: () {
                  final zoom = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, zoom + 1);
                }),
                const SizedBox(height: 8),
                _buildMapActionButton(Icons.remove, onTap: () {
                  final zoom = _mapController.camera.zoom;
                  _mapController.move(_mapController.camera.center, zoom - 1);
                }),
                const SizedBox(height: 16),
                _buildMapActionButton(Icons.my_location, isPrimary: true, onTap: () async {
                   try {
                     Position pos = await Geolocator.getCurrentPosition();
                     _mapController.move(LatLng(pos.latitude, pos.longitude), 15);
                   } catch (e) {
                     Get.snackbar("Location Error", "Could not get current location");
                   }
                }),
              ],
            ),
          ),

           
          _buildDraggableRidePanel(),
        ],
      ),
    );
  }



  Widget _buildMapActionButton(IconData icon, {bool isPrimary = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isPrimary ? accentBlue : cardBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    ),
  );
  }

  Widget _buildDraggableRidePanel() {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: darkBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
          ),
          child: Obx(() {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                 
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                   child: Text(
                    "Hi, ${vm.userName}",
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),

                 
                TextField(
                  controller: _pickupController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBg,
                    hintText: 'Pickup location',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.my_location, color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                 
                TextField(
                  controller: _dropoffController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBg,
                    hintText: 'Drop-off location',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                 
                TextField(
                  controller: _fareController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cardBg,
                    hintText: 'Offer Fare (e.g. PKR 500)',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.account_balance_wallet, color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const SizedBox(height: 12),

                 
                Row(
                  children: [
                     
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              final now = DateTime.now();
                              _pickupTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.white38, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _pickupTime != null
                                    ? '${_pickupTime!.hour}:${_pickupTime!.minute.toString().padLeft(2, '0')}'
                                    : 'Now',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                     
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.white),
                              onPressed: () {
                                if (_passengers > 1) setState(() => _passengers--);
                              },
                            ),
                            Text('$_passengers', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                if (_passengers < 6) setState(() => _passengers++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 12),

                // Payment Method Selector
                InkWell(
                  onTap: () async {
                    final result = await Get.toNamed('/passenger/payment', arguments: {'currentMethod': _paymentMethod});
                    if (result != null) {
                      setState(() {
                         _paymentMethod = result;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(_paymentMethod == 'Cash' ? Icons.money : Icons.credit_card, color: Colors.white70),
                            const SizedBox(width: 12),
                            Text('Payment: $_paymentMethod', style: const TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: vm.isLoading.value
                        ? null
                        : () {
                            // Using map center as pickup location since it's a "Live Map" context
                            // In a real app we'd want specific markers, but this fits the current constraints
                            final center = _mapController.camera.center;
                            vm.createRide(
                              pickup: _pickupController.text,
                              dropoff: _dropoffController.text,
                              fare: _fareController.text,
                              passengers: _passengers,
                              pickupTime: _pickupTime,
                              paymentMethod: _paymentMethod,
                              pickupLng: center.longitude,
                              duration: '15 min',
                              // No dropoff coords available from UI yet, leaving null or could be geocoded
                            );
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: vm.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Request Ride',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

}
