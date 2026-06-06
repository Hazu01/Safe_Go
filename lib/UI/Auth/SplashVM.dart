import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';
import 'package:safe_go/Data/Models/AppUser.dart';

class SplashVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final UserRepo userRepo = Get.find();

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final user = authRepo.getCurrentUser();
    if (user == null) {
       
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.currentRoute == '/splash') {
          Get.offAllNamed('/login');
        }
      });
      return;
    }

    AppUser? profile;
    try {
      profile = await userRepo.getUserById(user.uid).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('Firestore request timed out. Using cache if available.');
              return null; // This will return null to profile, and we can handle it below
            },
          );
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      // If we can't fetch profile (e.g. offline and no cache), we'll handle it below.
    }


     
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != '/splash') return;

      if (profile == null || profile.role.isEmpty) {
        Get.offAllNamed('/roleSelect');
      } else if (profile.role == 'passenger') {
        Get.offAllNamed('/passenger/dashboard');
      } else {
        Get.offAllNamed('/driver/dashboard');
      }
    });
  }
}
