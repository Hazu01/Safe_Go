import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/DriverProfileRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';
import 'package:safe_go/Data/Repository/VehicleRepo.dart';
import 'package:safe_go/UI/driver/ride_requests_vm.dart';
import 'package:safe_go/UI/driver/update_ride_status_vm.dart';
import 'package:safe_go/UI/driver/driver_history_vm.dart';
import 'package:safe_go/UI/driver/driver_profile_vm.dart';
import 'package:safe_go/UI/driver/driver_dashboard_vm.dart';
import 'package:safe_go/UI/Auth/ChangePasswordVM.dart';
import 'package:safe_go/UI/driver/vehicles_vm.dart';

class DriverBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepo>()) {
      Get.put(AuthRepo());
    }
    if (!Get.isRegistered<RideRepo>()) {
      Get.put(RideRepo());
    }
    if (!Get.isRegistered<DriverProfileRepo>()) {
      Get.put(DriverProfileRepo());
    }
    if (!Get.isRegistered<UserRepo>()) {
      Get.put(UserRepo());
    }
    if (!Get.isRegistered<VehicleRepo>()) {
      Get.put(VehicleRepo());
    }
    if (!Get.isRegistered<DriverRideRequestsVM>()) {
      Get.put(DriverRideRequestsVM());
    }
    if (!Get.isRegistered<UpdateRideStatusVM>()) {
      Get.put(UpdateRideStatusVM());
    }
    if (!Get.isRegistered<DriverHistoryVM>()) {
      Get.put(DriverHistoryVM());
    }
    if (!Get.isRegistered<DriverProfileVM>()) {
      Get.put(DriverProfileVM());
    }
    if (!Get.isRegistered<DriverDashboardVM>()) {
      Get.put(DriverDashboardVM());
    }
    if (!Get.isRegistered<ChangePasswordVM>()) {
      Get.put(ChangePasswordVM());
    }
    if (!Get.isRegistered<DriverVehiclesVM>()) {
      Get.put(DriverVehiclesVM());
    }
  }
}
