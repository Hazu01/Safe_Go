import 'dart:async';
import 'package:get/get.dart';
import 'package:safe_go/Data/Models/AppUser.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_go/Data/Repository/Mediarepo.dart';
import 'package:safe_go/UI/passenger/passenger_profile_vm.dart'; // Self import if needed or just keep others
import 'package:safe_go/Data/Repository/UserRepo.dart';

class PassengerProfileVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final UserRepo userRepo = Get.find();

  final user = Rxn<AppUser>();
  final isLoading = true.obs;
  StreamSubscription? _sub;

  @override
  void onInit() {
    super.onInit();
    _bindProfile();
  }

  void _bindProfile() {
    final currentUser = authRepo.getCurrentUser();
    if (currentUser == null) {
      Get.offAllNamed('/login');
      return;
    }

    isLoading.value = true;
    _sub = userRepo.userStream(currentUser.uid).listen((u) {
      user.value = u;
      isLoading.value = false;
    }, onError: (e) {
      Get.snackbar('Error', 'Failed to sync profile');
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  Future<void> updateName(String val) async {
    final uid = user.value?.id;
    if (uid == null) return;
    await userRepo.updateUserFields(uid, {'displayName': val});
  }

  Future<void> updatePhone(String val) async {
    final uid = user.value?.id;
    if (uid == null) return;
    await userRepo.updateUserFields(uid, {'phone': val});
  }

  Future<void> updateEmail(String val) async {
     
     
    final uid = user.value?.id;
    if (uid == null) return;
    await userRepo.updateUserFields(uid, {'email': val});
  }

  Future<void> toggleNotifications(bool val) async {
    final uid = user.value?.id;
    if (uid == null) return;
    await userRepo.updateUserFields(uid, {'notificationsEnabled': val});
  }

  Future<void> updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      isLoading.value = true;
      try {
        // We need to inject MediaRepo first.
        if (!Get.isRegistered<MediaRepo>()) {
          Get.put(MediaRepo());
        }
        final mediaRepo = Get.find<MediaRepo>();
        
        final url = await mediaRepo.uploadImage(pickedFile);
        if (url != null) {
          final uid = user.value?.id;
          if (uid != null) {
            await userRepo.updateUserFields(uid, {'profilePicture': url});
            Get.snackbar('Success', 'Profile picture updated');
          }
        } else {
          Get.snackbar('Error', 'Failed to upload image');
        }
      } catch (e) {
        Get.snackbar('Error', 'Something went wrong: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
