import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';
import 'package:safe_go/UI/Auth/SplashVM.dart';
import 'package:safe_go/UI/RoleSelection/role_selection_vm.dart';

class AuthInitBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthRepo>()) {
      Get.put(AuthRepo());
    }
    if (!Get.isRegistered<UserRepo>()) {
      Get.put(UserRepo());
    }
    if (!Get.isRegistered<SplashVM>()) {
      Get.put(SplashVM());
    }
    if (!Get.isRegistered<RoleSelectionVM>()) {
      Get.put(RoleSelectionVM());
    }
  }
}
