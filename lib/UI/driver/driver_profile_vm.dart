import 'dart:async';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_go/Data/Models/AppUser.dart';
import 'package:safe_go/Data/Models/DriverProfile.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/DriverProfileRepo.dart';
import 'package:safe_go/Data/Repository/Mediarepo.dart';
import 'package:safe_go/Data/Repository/UserRepo.dart';

class DriverProfileVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final DriverProfileRepo profileRepo = Get.find();
  final UserRepo userRepo = Get.find();

  final profile = Rxn<DriverProfile>();
  final user = Rxn<AppUser>();
  final isLoading = false.obs;
  StreamSubscription? _userSub;

  String? get currentEmail => authRepo.getCurrentUser()?.email;
  String? get currentDisplayName => authRepo.getCurrentUser()?.displayName;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
    _bindUserStream();
  }

  void _bindUserStream() {
    final currentUser = authRepo.getCurrentUser();
    if (currentUser == null) return;
    _userSub = userRepo.userStream(currentUser.uid).listen((u) {
      user.value = u;
    });
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }

  Future<void> updateProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      isLoading.value = true;
      try {
        if (!Get.isRegistered<MediaRepo>()) {
          Get.put(MediaRepo());
        }
        final mediaRepo = Get.find<MediaRepo>();
        
        final url = await mediaRepo.uploadImage(pickedFile);
        if (url != null) {
          final uid = authRepo.getCurrentUser()?.uid;
          if (uid != null) {
            await userRepo.updateUserFields(uid, {'profilePicture': url});
            
            // Also update driver profile
            final currentProfile = profile.value;
            if (currentProfile != null) {
              final updated = currentProfile.copyWith(profileImage: url);
              await profileRepo.save(updated);
              profile.value = updated;
            } else {
               // Fallback if profile not loaded yet for some reason
               await profileRepo.save(DriverProfile(
                 id: uid, 
                 name: currentDisplayName ?? 'Driver', 
                 vehicleModel: '', 
                 plateNumber: '',
                 profileImage: url
               ));
            }

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

  Future<void> _loadProfile() async {
    isLoading.value = true;
    try {
      final user = authRepo.getCurrentUser();
      if (user == null) {
        Get.offAllNamed('/login');
        return;
      }
      final existing = await profileRepo.getByUserId(user.uid);
      if (existing != null) {
         
        if (existing.username == null || existing.username!.isEmpty) {
          final updated = existing.copyWith(username: user.displayName);
          await profileRepo.save(updated);
          profile.value = updated;
        } else {
          profile.value = existing;
        }
      } else {
         
        final created = DriverProfile(
          id: user.uid,
          name: user.displayName ?? (user.email ?? ''),
          username: user.displayName,
          vehicleModel: '',
          plateNumber: '',
        );
        await profileRepo.save(created);
        profile.value = created;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<DriverProfile?> _ensureProfile() async {
    final user = authRepo.getCurrentUser();
    if (user == null) return null;

    if (profile.value != null) return profile.value;

    final existing = await profileRepo.getByUserId(user.uid);
    if (existing != null) {
      profile.value = existing;
      return existing;
    }

    final created = DriverProfile(
      id: user.uid,
      name: user.displayName ?? (user.email ?? ''),
      username: user.displayName,
      vehicleModel: '',
      plateNumber: '',
    );
    await profileRepo.save(created);
    profile.value = created;
    return created;
  }

  Future<void> saveProfile({
    required String name,
    required String phone,
    required String vehicleModel,
    required String plateNumber,
  }) async {
    final current = profile.value;
    if (current == null) return;
    isLoading.value = true;
    try {
      final updated = current.copyWith(
        name: name,
        phone: phone,
        vehicleModel: vehicleModel,
        plateNumber: plateNumber,
      );
      await profileRepo.save(updated);
      profile.value = updated;
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateName(String name) async {
    final user = authRepo.getCurrentUser();
    final current = profile.value;
    if (user == null || current == null) {
      Get.offAllNamed('/login');
      return;
    }
    isLoading.value = true;
    try {
      final updated = current.copyWith(name: name, username: current.username ?? name);
      await profileRepo.save(updated);
       
      await authRepo.updateDisplayName(name);
       
      await userRepo.updateUserFields(user.uid, {'displayName': name});

      profile.value = updated;
      Get.snackbar('Success', 'Name updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUsername(String username) async {
    final user = authRepo.getCurrentUser();
    final current = await _ensureProfile();
    if (user == null || current == null) {
      Get.offAllNamed('/login');
      return;
    }

    isLoading.value = true;
    try {
       
      await authRepo.updateDisplayName(username);
       
      await userRepo.updateUserFields(user.uid, {'displayName': username});
       
      final updated = current.copyWith(username: username);
      await profileRepo.save(updated);

       
      profile.value = updated;
      Get.snackbar('Success', 'Username updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update username');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateEmail(String email) async {
    final user = authRepo.getCurrentUser();
    final current = await _ensureProfile();
    if (user == null || current == null) {
      Get.offAllNamed('/login');
      return;
    }

    isLoading.value = true;
    try {
       
      await authRepo.updateEmail(email);

       
      await userRepo.updateUserFields(user.uid, {'pendingEmail': email});
      final updated = current.copyWith(pendingEmail: email);
      await profileRepo.save(updated);
      profile.value = updated;

      Get.snackbar('Success', 'Verification email sent. Please verify to complete change.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update email');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePhone(String phone) async {
    final user = authRepo.getCurrentUser();
    final current = await _ensureProfile();
    if (user == null || current == null) {
      Get.offAllNamed('/login');
      return;
    }
    isLoading.value = true;
    try {
      final updated = current.copyWith(phone: phone);
      await profileRepo.save(updated);
      await userRepo.updateUserFields(user.uid, {'phone': phone});
      profile.value = updated;
      Get.snackbar('Success', 'Phone updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update phone');
    } finally {
      isLoading.value = false;
    }
  }
}
