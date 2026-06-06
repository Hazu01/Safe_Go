import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/DriverProfileRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';
import 'package:safe_go/Data/Repository/VehicleRepo.dart';
import 'package:safe_go/UI/Auth/ChangePasswordVM.dart';
import 'package:safe_go/UI/driver/driver_dashboard_vm.dart';
import 'package:safe_go/UI/driver/driver_history_vm.dart';
import 'package:safe_go/UI/driver/driver_profile_vm.dart';
import 'package:safe_go/UI/driver/ride_requests_vm.dart';
import 'package:safe_go/UI/driver/update_ride_status_vm.dart';
import 'package:safe_go/UI/driver/trip_completed_vm.dart';
import 'package:safe_go/UI/driver/vehicles_vm.dart';

class _DriverCore {
  static void ensureCore() {
    if (!Get.isRegistered<AuthRepo>()) Get.put(AuthRepo());
    if (!Get.isRegistered<UserRepo>()) Get.put(UserRepo());
    if (!Get.isRegistered<DriverProfileRepo>()) Get.put(DriverProfileRepo());
    if (!Get.isRegistered<VehicleRepo>()) Get.put(VehicleRepo());
  }
}

class DriverDashboardBinding extends Bindings {
  @override
  void dependencies() {
    _DriverCore.ensureCore();
    if (!Get.isRegistered<RideRepo>()) Get.put(RideRepo());
    if (!Get.isRegistered<DriverRideRequestsVM>()) Get.put(DriverRideRequestsVM());
    if (!Get.isRegistered<DriverDashboardVM>()) Get.put(DriverDashboardVM());
  }
}

class DriverRequestsBinding extends Bindings {
  @override
  void dependencies() {
    _DriverCore.ensureCore();
    if (!Get.isRegistered<RideRepo>()) Get.put(RideRepo());
    if (!Get.isRegistered<DriverRideRequestsVM>()) Get.put(DriverRideRequestsVM());
  }
}

class DriverHistoryBinding extends Bindings {
  @override
  void dependencies() {
    _DriverCore.ensureCore();
    if (!Get.isRegistered<RideRepo>()) Get.put(RideRepo());
    if (!Get.isRegistered<DriverHistoryVM>()) Get.put(DriverHistoryVM());
  }
}

class DriverProgressBinding extends Bindings {
  @override
  void dependencies() {
    _DriverCore.ensureCore();
    if (!Get.isRegistered<RideRepo>()) Get.put(RideRepo());
    if (!Get.isRegistered<UpdateRideStatusVM>()) Get.put(UpdateRideStatusVM());
    if (!Get.isRegistered<TripCompletedVM>()) Get.put(TripCompletedVM());
  }
}

class DriverProfileBinding extends Bindings {
  @override
  void dependencies() {
    _DriverCore.ensureCore();
    if (!Get.isRegistered<DriverProfileVM>()) Get.put(DriverProfileVM());
    if (!Get.isRegistered<DriverVehiclesVM>()) Get.put(DriverVehiclesVM());
    if (!Get.isRegistered<ChangePasswordVM>()) Get.put(ChangePasswordVM());
  }
}

class DriverVehiclesBinding extends Bindings {
  @override
  void dependencies() {
    _DriverCore.ensureCore();
    if (!Get.isRegistered<DriverVehiclesVM>()) Get.put(DriverVehiclesVM());
  }
}

class DriverChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    _DriverCore.ensureCore();
    if (!Get.isRegistered<ChangePasswordVM>()) Get.put(ChangePasswordVM());
  }
}
