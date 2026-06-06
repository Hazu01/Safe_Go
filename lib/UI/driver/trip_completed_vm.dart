import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';

class TripCompletedVM extends GetxController {
  RideRepo get rideRepo => Get.find();

  UserRepo get userRepo => Get.find();

  final ride = Rxn<RideRequest>();
  final passengerName = Rxn<String>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final args = Get.arguments;
      if (args == null || (args is! Map) || !args.containsKey('rideId')) {
        return;
      }
      
      final rideId = args['rideId'] as String;
      final rideData = await rideRepo.rideRequestStream(rideId).first;
      ride.value = rideData;

      if (rideData.passengerId.isNotEmpty) {
        final user = await userRepo.getUserById(rideData.passengerId);
        passengerName.value = user?.displayName ?? 'Passenger';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load trip details');
    } finally {
      isLoading.value = false;
    }
  }
}
