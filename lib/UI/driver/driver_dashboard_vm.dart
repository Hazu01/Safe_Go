import 'dart:async';

import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';

class DriverDashboardVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final RideRepo rideRepo = Get.find();
  final UserRepo userRepo = Get.find();

  final isAvailable = false.obs;
  final totalEarnings = 0.0.obs;
  
  StreamSubscription? _sub;
  StreamSubscription? _userSub;
  StreamSubscription? _historySub;

  @override
  void onInit() {
    super.onInit();
    final user = authRepo.getCurrentUser();
    if (user == null) return;


    // Listen for user availability status
    _userSub = userRepo.userStream(user.uid).listen((u) {
      if (u != null) {
        isAvailable.value = u.isAvailable;
      }
    });

    // Calculate dynamic earnings from history
    _historySub = rideRepo.driverHistoryStream(user.uid).listen((rides) {
      double sum = 0.0;
      for (var r in rides) {
        if (r.offeredFare != null) {
          sum += r.offeredFare!;
        }
      }
      totalEarnings.value = sum;
      // Persist to Firestore so it's there after relogin
      userRepo.updateUserFields(user.uid, {'totalEarnings': sum});
    });
  }

  Future<void> toggleAvailability(bool val) async {
    final user = authRepo.getCurrentUser();
    if (user == null) return;
    // We optimistically update UI, but the stream will confirm it
    isAvailable.value = val;
    await userRepo.updateUserFields(user.uid, {'isAvailable': val});
  }

  @override
  void onClose() {
    _userSub?.cancel();
    _historySub?.cancel();
    super.onClose();
  }
}
