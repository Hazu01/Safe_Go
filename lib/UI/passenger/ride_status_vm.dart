import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Models/DriverProfile.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/DriverProfileRepo.dart';

class RideStatusVM extends GetxController {
  final RideRepo rideRepo = Get.find();
  
  // Use lazy getter for DriverProfileRepo in case it's not put yet
  DriverProfileRepo get driverRepo {
    if (Get.isRegistered<DriverProfileRepo>()) {
      return Get.find<DriverProfileRepo>();
    }
    return Get.put(DriverProfileRepo());
  }

  final ride = Rxn<RideRequest>();
  final driver = Rxn<DriverProfile>();
  late final String rideId;
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();

     
     
    final args = Get.arguments;
    if (args == null || (args is! Map) || !args.containsKey('rideId')) {
      return;
    }

    rideId = args['rideId'] as String;
    _sub = rideRepo.rideRequestStream(rideId).listen((r) async {
      ride.value = r;

      if (r.driverId != null && driver.value == null) {
          try {
             driver.value = await driverRepo.getByUserId(r.driverId!);
          } catch (_) {
            // Handle error silently or retry
          }
      }

      if (r.status == 'completed') {
         
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.currentRoute == '/passenger/status') {
            Get.offAllNamed('/passenger/completed', arguments: {'rideId': rideId});
          }
        });
      }
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  Future<void> cancelRide() async {
    try {
      await rideRepo.updateRideStatus(rideId, 'cancelled');
      Get.offAllNamed('/passenger/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel ride');
    }
  }
}
