import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/UI/passenger/searching_driver_vm.dart';

class RideRequestVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final RideRepo rideRepo = Get.find();

  final isLoading = false.obs;

  String get userName => authRepo.getCurrentUser()?.displayName ?? "User";

  Future<void> createRide({
    required String pickup,
    required String dropoff,
    required String fare,
    required int passengers,
    required String paymentMethod,
    DateTime? pickupTime,
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    String? duration,
  }) async {
    if (pickup.isEmpty || dropoff.isEmpty) {
      Get.snackbar('Error', 'Please enter pickup and drop-off');
      return;
    }

    final user = authRepo.getCurrentUser();
    if (user == null) {
      Get.offAllNamed('/login');
      return;
    }

    isLoading.value = true;
    try {
      final rideId = await rideRepo.createRideRequest(
        passengerId: user.uid,
        pickup: pickup,
        dropoff: dropoff,
        offeredFare: double.tryParse(fare),
        passengers: passengers,
        pickupTime: pickupTime,
        paymentMethod: paymentMethod,
        pickupLat: pickupLat,   
        pickupLng: pickupLng,
        dropoffLat: dropoffLat,
        dropoffLng: dropoffLng,
        duration: duration,
      );

      
      // Ensure fresh SearchingDriverVM to force onInit and argument reading
      if (Get.isRegistered<SearchingDriverVM>()) {
        Get.delete<SearchingDriverVM>();
      }
      Get.offNamed('/passenger/searching', arguments: {'rideId': rideId});
    } catch (e) {
      Get.snackbar('Error', 'Failed to create ride');
    } finally {
      isLoading.value = false;
    }
  }
}
