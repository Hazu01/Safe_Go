import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String make;
  final String model;
  final String plateNumber;
  final int? year;
  final String? color;
  final bool isActive;
  final DateTime? createdAt;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.plateNumber,
    this.year,
    this.color,
    this.isActive = false,
    this.createdAt,
  });

  Vehicle copyWith({
    String? make,
    String? model,
    String? plateNumber,
    int? year,
    String? color,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Vehicle(
      id: id,
      make: make ?? this.make,
      model: model ?? this.model,
      plateNumber: plateNumber ?? this.plateNumber,
      year: year ?? this.year,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Vehicle.fromMap(String id, Map<String, dynamic> data) {
    final ts = data['createdAt'] as Timestamp?;
    return Vehicle(
      id: id,
      make: data['make'] as String? ?? '',
      model: data['model'] as String? ?? '',
      plateNumber: data['plateNumber'] as String? ?? '',
      year: (data['year'] as num?)?.toInt(),
      color: data['color'] as String?,
      isActive: data['isActive'] as bool? ?? false,
      createdAt: ts?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'make': make,
      'model': model,
      'plateNumber': plateNumber,
      'year': year,
      'color': color,
      'isActive': isActive,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : createdAt,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
