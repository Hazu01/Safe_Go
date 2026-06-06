import 'dart:async';

import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';

class DriverHistoryVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final RideRepo rideRepo = Get.find();

  final rides = <RideRequest>[].obs;
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    final user = authRepo.getCurrentUser();
    if (user != null) {
      _sub=rideRepo.driverHistoryStream(driverId).
    }
  }

  Future<void> deleteRide(String rideId) async {
    try {
      await rideRepo.deleteRideForDriver(rideId);
      Get.snackbar('Success', 'Ride deleted from history');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete ride');
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
