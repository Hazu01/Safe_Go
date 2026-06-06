import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';


class ResetVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  var isLoading = false.obs;

  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    try {
      await authRepo.resetPassword(email);
      Get.snackbar('Success', 'Password reset email sent!');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send reset email');
    } finally {
      isLoading.value = false;
    }
  }
}