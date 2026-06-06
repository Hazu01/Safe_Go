import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String role;
  final String? displayName;
  final String? phone;
  final bool notificationsEnabled;
  final String? profilePicture;
  final bool isAvailable;
  final double totalEarnings;
  final String? vehicleModel;
  final String? plateNumber;

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.displayName,
    this.phone,
    this.notificationsEnabled = true,
    this.profilePicture,
    this.isAvailable = false,
    this.totalEarnings = 0.0,
    this.vehicleModel,
    this.plateNumber,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'passenger',
      displayName: data['displayName'] as String?,
      phone: data['phone'] as String?,
      notificationsEnabled: data['notificationsEnabled'] as bool? ?? true,
      profilePicture: data['profilePicture'] as String?,
      isAvailable: data['isAvailable'] as bool? ?? false,
      totalEarnings: (data['totalEarnings'] as num?)?.toDouble() ?? 0.0,
      vehicleModel: data['vehicleModel'] as String?,
      plateNumber: data['plateNumber'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'displayName': displayName,
      'phone': phone,
      'notificationsEnabled': notificationsEnabled,
      'profilePicture': profilePicture,
      'isAvailable': isAvailable,
      'totalEarnings': totalEarnings,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
