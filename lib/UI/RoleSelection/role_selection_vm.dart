import 'package:get/get.dart';
import 'package:safe_go/Data/Models/AppUser.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';

class RoleSelectionVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final UserRepo userRepo = Get.find();

  final isLoading = false.obs;

  Future<void> selectRole(String role) async {
    isLoading.value = true;
    try {
      final user = authRepo.getCurrentUser();
      if (user == null) {
        Get.offAllNamed('/login');
        return;
      }
      final appUser = AppUser(
        id: user.uid,
        email: user.email ?? '',
        role: role,
      );
      await userRepo.createOrUpdateUser(appUser);

      if (role == 'passenger') {
        Get.offAllNamed('/passenger/dashboard');
      } else {
        Get.offAllNamed('/driver/dashboard');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save role');
    } finally {
      isLoading.value = false;
    }
  }
}
