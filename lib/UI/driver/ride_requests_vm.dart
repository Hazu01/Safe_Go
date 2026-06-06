import 'dart:async';

import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';

class DriverRideRequestsVM extends GetxController {
  final RideRepo rideRepo = Get.find();
  final AuthRepo authRepo = Get.find();

  final pendingRides = <RideRequest>[].obs;
  final errorMessage = ''.obs;
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    final user = authRepo.getCurrentUser();
    if (user == null) {
      errorMessage.value = "Not logged in";
      return;
    }

    _sub = rideRepo.pendingRequestsStream(driverId: user.uid).listen(
      (list) {
         
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        pendingRides.value = list;
      },
      onError: (e) {
         
        pendingRides.clear();
        errorMessage.value = e.toString();
        print("RideRequests error: $e");
      },
    );
  }

  Future<void> acceptRide(RideRequest ride) async {
    final driver = authRepo.getCurrentUser();
    if (driver == null) {
      Get.offAllNamed('/login');
      return;
    }
    try {
      await rideRepo.updateRideStatus(ride.id, 'accepted', driverId: driver.uid);
      Get.offAllNamed('/driver/progress', arguments: {'rideId': ride.id});
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept ride');
    }
  }

  Future<void> rejectRide(RideRequest ride) async {
    try {
      await rideRepo.updateRideStatus(ride.id, 'cancelled');
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject ride');
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
