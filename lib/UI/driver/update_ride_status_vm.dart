import 'dart:async';

import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';

class UpdateRideStatusVM extends GetxController {
  RideRepo get rideRepo => Get.find();

  UserRepo get userRepo {
    if (!Get.isRegistered<UserRepo>()) {
      Get.put(UserRepo());
    }
    return Get.find<UserRepo>();
  }

  final ride = Rxn<RideRequest>();
  final passengerName = Rxn<String>();
  late final String rideId;
  StreamSubscription? _sub;
  final isWorking = false.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    if (args == null || (args is! Map) || !args.containsKey('rideId')) {
      return;
    }

    rideId = args['rideId'] as String;
    _sub = rideRepo.rideRequestStream(rideId).listen(
      (r) async {
        ride.value = r;
        if (r.passengerId.isNotEmpty && passengerName.value == null) {
           try {
             final user = await userRepo.getUserById(r.passengerId);
             passengerName.value = user?.displayName ?? 'Passenger';
           } catch (e) {
             print("Error fetching passenger: $e");
             passengerName.value = 'Passenger';
           }
        }
      },
      onError: (e) {
        ride.value = null;
      },
    );
  }

  String get primaryButtonText {
    final status = ride.value?.status ?? 'accepted';
    switch (status) {
      case 'accepted':
        return 'Arrived at Pickup';
      case 'on_the_way':
        return 'Complete Ride';
      default:
        return 'Update Status';
    }
  }

  Future<void> onPrimaryAction() async {
    final current = ride.value;
    if (current == null) return;
    isWorking.value = true;
    try {
      if (current.status == 'accepted') {
        await rideRepo.updateRideStatus(rideId, 'on_the_way');
      } else if (current.status == 'on_the_way') {
        await rideRepo.updateRideStatus(rideId, 'completed');
        Get.offAllNamed('/driver/completed', arguments: {'rideId': rideId});
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update ride status');
    } finally {
      isWorking.value = false;
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
