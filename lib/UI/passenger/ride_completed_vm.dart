import 'package:get/get.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';
import 'package:safe_go/Data/Models/DriverProfile.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/DriverProfileRepo.dart';

class RideCompletedVM extends GetxController {
  final RideRepo _rideRepo = Get.find();
  final DriverProfileRepo _driverRepo = Get.find(); // Assuming registered

  final ride = Rxn<RideRequest>();
  final driver = Rxn<DriverProfile>();
  final rating = 0.0.obs;
  final isLoading = true.obs;
  
  // To handle case where driver repo might not be registered yet if lazy put
  DriverProfileRepo get driverRepo {
    try {
      return Get.find<DriverProfileRepo>();
    } catch (_) {
      Get.put(DriverProfileRepo());
      return Get.find<DriverProfileRepo>();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      final args = Get.arguments;
      String? rideId;
      
      if (args is String) {
        rideId = args;
      } else if (args is Map && args.containsKey('rideId')) {
        rideId = args['rideId'];
      }

      if (rideId != null) {
        // Fetch ride details
         // We use the stream or fetch once. Since it's completed, fetch once is fine but stream keeps it updated.
         // Let's take the first value from stream for now or just wait for it.
         final rideData = await _rideRepo.rideRequestStream(rideId).first;
         ride.value = rideData;

         if (rideData.driverId != null) {
           final driverData = await driverRepo.getByUserId(rideData.driverId!);
           driver.value = driverData;
         }
      }
    } catch (e) {
      print('Error loading ride completion data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateRating(double value) {
    rating.value = value;
  }

  Future<void> submitRating() async {
    if (ride.value == null || rating.value == 0) return;
    
    try {
      isLoading.value = true;
      await _rideRepo.rateRide(ride.value!.id, rating.value, null);
      
      if (ride.value!.driverId != null) {
        await driverRepo.updateRating(ride.value!.driverId!, rating.value);
      }

      Get.snackbar('Success', 'Rating submitted successfully!');
      // Navigate away or disable button
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit rating');
    } finally {
      isLoading.value = false;
    }
  }
}
