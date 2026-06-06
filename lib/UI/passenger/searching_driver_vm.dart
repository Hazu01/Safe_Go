import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Models/AppUser.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';

class SearchingDriverVM extends GetxController {
  final RideRepo rideRepo = Get.find();
  
  // Use late initialization inside onInit to ensure dependency is ready
  late final UserRepo userRepo; 
  final availableDrivers = <AppUser>[].obs;

  final ride = Rxn<RideRequest>();
  String? rideId;
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    
    // Ensure UserRepo is available
    if (Get.isRegistered<UserRepo>()) {
      userRepo = Get.find<UserRepo>();
      availableDrivers.bindStream(userRepo.availableDriversStream());
    } else {
      // Fallback or log error - in binding we fixed it, but good for safety
      Get.lazyPut(() => UserRepo());
      userRepo = Get.find<UserRepo>();
      availableDrivers.bindStream(userRepo.availableDriversStream());
    }

    final args = Get.arguments;
    if (args == null || (args is! Map) || !args.containsKey('rideId')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar("Error", "Ride ID not found");
        // Optional: Navigate back if critical
        // Get.offNamed('/passenger/dashboard'); 
      });
      return;
    }

    rideId = args['rideId'] as String;
    _sub = rideRepo.rideRequestStream(rideId!).listen((r) {
      ride.value = r;

      if (r.status != 'pending' && r.status != 'cancelled' && r.status != 'searching') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute == '/passenger/searching') {
            Get.offAllNamed('/passenger/status', arguments: {'rideId': r.id});
          }
        });
      }
    });
  }

  Future<void> selectDriver(String driverId) async {
    if (rideId == null) {
      Get.snackbar('Error', 'Ride ID is missing');
      return;
    }
    try {
      await rideRepo.updateRideStatus(rideId!, 'pending', driverId: driverId);
      Get.snackbar('Request Sent', 'Waiting for driver response...');
    } catch (e) {
      Get.snackbar('Error', 'Failed to select driver');
    }
  }

  Future<void> cancelRide() async {
    if (rideId == null) {
       // If no ride ID, just go back
       Get.offAllNamed('/passenger/dashboard');
       return;
    }
    try {
      await rideRepo.updateRideStatus(rideId!, 'cancelled');
      Get.snackbar('Success', 'Ride request cancelled');
      Get.offAllNamed('/passenger/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel ride: $e');
      // Force navigation back even if error
      Get.offAllNamed('/passenger/dashboard');
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
