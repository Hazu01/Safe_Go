import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';

class ChangePasswordVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  var isLoading = false.obs;

  Future<void> changePassword(String newPassword) async {
    isLoading.value = true;
    try {
      await authRepo.changePassword(newPassword);
      Get.snackbar('Success', 'Password updated successfully');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to change password');
    } finally {
      isLoading.value = false;
    }
  }
}
