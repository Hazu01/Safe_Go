import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfile {
  final String id;
  final String name;
  final String? username;
  final String vehicleModel;
  final String plateNumber;
  final String? phone;
  final double? rating;
  final int ratingCount;
  final String? activeVehicleId;
  final String? pendingEmail;
  final String? profileImage;

  DriverProfile({
    required this.id,
    required this.name,
    this.username,
    required this.vehicleModel,
    required this.plateNumber,
    this.phone,
    this.rating,
    this.ratingCount = 0,
    this.activeVehicleId,
    this.pendingEmail,
    this.profileImage,
  });

  DriverProfile copyWith({
    String? name,
    String? username,
    String? vehicleModel,
    String? plateNumber,
    String? phone,
    double? rating,
    int? ratingCount,
    String? activeVehicleId,
    String? pendingEmail,
    String? profileImage,
  }) {
    return DriverProfile(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      vehicleModel: vehicleModel ?? this.vehicleModel,
      plateNumber: plateNumber ?? this.plateNumber,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      activeVehicleId: activeVehicleId ?? this.activeVehicleId,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  factory DriverProfile.fromMap(String id, Map<String, dynamic> data) {
    return DriverProfile(
      id: id,
      name: data['name'] as String? ?? '',
      username: data['username'] as String?,
      vehicleModel: data['vehicleModel'] as String? ?? '',
      plateNumber: data['plateNumber'] as String? ?? '',
      phone: data['phone'] as String?,
      rating: (data['rating'] as num?)?.toDouble(),
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
      activeVehicleId: data['activeVehicleId'] as String?,
      pendingEmail: data['pendingEmail'] as String?,
      profileImage: data['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'vehicleModel': vehicleModel,
      'plateNumber': plateNumber,
      'phone': phone,
      'rating': rating,
      'ratingCount': ratingCount,
      'activeVehicleId': activeVehicleId,
      'pendingEmail': pendingEmail,
      'profileImage': profileImage,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
