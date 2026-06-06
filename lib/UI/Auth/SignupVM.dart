import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';

class SignupVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  var isLoading = false.obs;

  Future<void> signup(String email, String password) async {
    isLoading.value = true;
    try {
      await authRepo.signup(email, password);
      Get.snackbar('Success', 'Verification email sent! Check your inbox.');
      Get.toNamed('/login');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Signup failed');
    } finally {
      isLoading.value = false;
    }
  }
}
