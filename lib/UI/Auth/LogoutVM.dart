import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';


class LogoutVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  var isLoading = false.obs;

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await authRepo.logout();
      Get.offAllNamed('/login');
      Get.snackbar('Success', 'Logged out successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
