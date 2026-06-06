import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/RideRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';
import 'package:safe_go/UI/Auth/LoginVM.dart';
import 'package:safe_go/UI/Auth/LogoutVM.dart';
import 'package:safe_go/UI/Auth/ResetPasswordVM.dart';
import 'package:safe_go/UI/Auth/SignupVM.dart';
import 'package:safe_go/UI/Auth/ChangePasswordVM.dart';
import 'package:safe_go/UI/passenger/ride_request_vm.dart';
import 'package:safe_go/UI/passenger/searching_driver_vm.dart';
import 'package:safe_go/UI/passenger/ride_status_vm.dart';
import 'package:safe_go/UI/passenger/passenger_profile_vm.dart';
import 'package:safe_go/UI/passenger/ride_completed_vm.dart';
import 'package:safe_go/Data/Repository/DriverProfileRepo.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepo());
    Get.put(LoginVM());
  }
}

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignupVM());
  }
}

class ResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ResetVM());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {

    if (!Get.isRegistered<AuthRepo>()) {
      Get.put(AuthRepo());
    }
    if (!Get.isRegistered<LogoutVM>()) {
      Get.put(LogoutVM());
    }
  }
}

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChangePasswordVM());
  }
}

 
class PassengerRideBinding extends Bindings {
  @override
  void dependencies() {
     
    if (!Get.isRegistered<AuthRepo>()) {
      Get.put(AuthRepo());
    }
    if (!Get.isRegistered<UserRepo>()) {
      Get.put(UserRepo());
    }
    if (!Get.isRegistered<RideRepo>()) {
      Get.lazyPut(() => RideRepo());
    }
    if (!Get.isRegistered<RideRequestVM>()) {
      Get.lazyPut(() => RideRequestVM());
    }
    if (!Get.isRegistered<SearchingDriverVM>()) {
      Get.lazyPut(() => SearchingDriverVM());
    }
    if (!Get.isRegistered<RideStatusVM>()) {
      Get.lazyPut(() => RideStatusVM());
    }
    if (!Get.isRegistered<DriverProfileRepo>()) {
      Get.lazyPut(() => DriverProfileRepo());
    }
    if (!Get.isRegistered<RideCompletedVM>()) {
      Get.lazyPut(() => RideCompletedVM());
    }
  }
}

 
class PassengerProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepo>()) {
      Get.put(AuthRepo());
    }
    if (!Get.isRegistered<UserRepo>()) {
      Get.put(UserRepo());
    }
    if (!Get.isRegistered<LogoutVM>()) {
      Get.put(LogoutVM());
    }
    if (!Get.isRegistered<PassengerProfileVM>()) {
      Get.put(PassengerProfileVM());
    }
  }
}
