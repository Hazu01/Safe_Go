import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequest {
  final String id;
  final String passengerId;
  final String? driverId;
  final String pickupLocation;
  final String dropoffLocation;
  final String status;
  final DateTime createdAt;
  final double? offeredFare;
  final int passengers;
  final DateTime? pickupTime;
  final String? paymentMethod;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final bool isHiddenFromPassenger;
  final double? rating;
  final String? ratingComment;
  final String? duration;
  final bool isHiddenFromDriver;

  RideRequest({
    required this.id,
    required this.passengerId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.status,
    required this.createdAt,
    this.driverId,
    this.offeredFare,
    this.passengers = 1,
    this.pickupTime,
    this.paymentMethod,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.isHiddenFromPassenger = false,
    this.isHiddenFromDriver = false,
    this.rating,
    this.ratingComment,
    this.duration,
  });

  factory RideRequest.fromMap(String id, Map<String, dynamic> data) {
    final ts = data['createdAt'] as Timestamp;
    final pickupTs = data['pickupTime'] as Timestamp?;
    return RideRequest(
      id: id,
      passengerId: data['passengerId'] as String,
      driverId: data['driverId'] as String?,
      pickupLocation: data['pickupLocation'] as String,
      dropoffLocation: data['dropoffLocation'] as String,
      status: data['status'] as String,
      createdAt: ts.toDate(),
      offeredFare: (data['offeredFare'] as num?)?.toDouble(),
      passengers: (data['passengers'] as int?) ?? 1,
      pickupTime: pickupTs?.toDate(),
      paymentMethod: data['paymentMethod'] as String? ?? 'Cash',
      pickupLat: (data['pickupLat'] as num?)?.toDouble(),
      pickupLng: (data['pickupLng'] as num?)?.toDouble(),
      dropoffLat: (data['dropoffLat'] as num?)?.toDouble(),
      dropoffLng: (data['dropoffLng'] as num?)?.toDouble(),
      isHiddenFromPassenger: data['isHiddenFromPassenger'] as bool? ?? false,
      isHiddenFromDriver: data['isHiddenFromDriver'] as bool? ?? false,
      rating: (data['rating'] as num?)?.toDouble(),
      ratingComment: data['ratingComment'] as String?,
      duration: data['duration'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'passengerId': passengerId,
      'driverId': driverId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'status': status,
      'createdAt': createdAt,
      'offeredFare': offeredFare,
      'passengers': passengers,
      'pickupTime': pickupTime,
      'paymentMethod': paymentMethod,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropoffLat': dropoffLat,
      'dropoffLng': dropoffLng,
      'isHiddenFromPassenger': isHiddenFromPassenger,
      'isHiddenFromDriver': isHiddenFromDriver,
      'rating': rating,
      'ratingComment': ratingComment,
      'duration': duration,
    };
  }
}
