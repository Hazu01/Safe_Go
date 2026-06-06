import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';

class LoginVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await authRepo.login(email, password);
       
      Get.offAllNamed('/splash');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }
}