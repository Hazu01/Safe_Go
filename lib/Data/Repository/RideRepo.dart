import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_go/Data/Models/RideRequest.dart';

class RideRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createRideRequest({
    required String passengerId,
    required String pickup,
    required String dropoff,
    double? offeredFare,
    int passengers = 1,
    DateTime? pickupTime,
    String paymentMethod = 'Cash',
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    String? duration,
  }) async {
    final doc = _db.collection('ride_requests').doc();
    await doc.set({
      'passengerId': passengerId,
      'driverId': null,
      'pickupLocation': pickup,
      'dropoffLocation': dropoff,
      'status': 'searching',
      'createdAt': FieldValue.serverTimestamp(),
      'offeredFare': offeredFare,
      'passengers': passengers,
      'pickupTime': pickupTime,
      'paymentMethod': paymentMethod,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropoffLat': dropoffLat,
      'dropoffLng': dropoffLng,
      'duration': duration,
    });
    return doc.id;
  }

  Stream<RideRequest> rideRequestStream(String rideId) {
    return _db.collection('ride_requests').doc(rideId).snapshots().map((doc) {
      return RideRequest.fromMap(doc.id, doc.data()!);
    });
  }

  Future<void> updateRideStatus(
    String rideId,
    String status, {
    String? driverId,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (driverId != null) {
      data['driverId'] = driverId;
    }
    await _db.collection('ride_requests').doc(rideId).update(data);
  }

  Stream<List<RideRequest>> pendingRequestsStream({required String driverId}) {
    return _db
        .collection('ride_requests')
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((d) => RideRequest.fromMap(d.id, d.data()))
            .toList());
  }


  Stream<RideRequest?> driverActiveRideStream(String driverId) {
    return _db
        .collection('ride_requests')
        .where('driverId', isEqualTo: driverId)
        .where('status', whereIn: ['accepted', 'on_the_way'])
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      var docs = snapshot.docs;
      // Sort in-memory to avoid composite index requirements
      docs.sort((a, b) {
        final aTs = a.data()['createdAt'] as Timestamp?;
        final bTs = b.data()['createdAt'] as Timestamp?;
        if (aTs == null) return 1;
        if (bTs == null) return -1;
        return bTs.compareTo(aTs);
      });
      final d = docs.first;
      return RideRequest.fromMap(d.id, d.data());
    });
  }

  Stream<List<RideRequest>> driverHistoryStream(String driverId) {
    return _db
        .collection('ride_requests')
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: 'completed')
        .snapshots()
        .map((snapshot) {
      var rides = snapshot.docs
          .map((d) => RideRequest.fromMap(d.id, d.data()))
          .where((r) => !r.isHiddenFromDriver) // Filter soft deletes for driver
          .toList();
      // Sort in-memory to avoid composite index requirements
      rides.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return rides;
    });
  }

  Stream<List<RideRequest>> passengerHistoryStream(String passengerId) {
    return _db
        .collection('ride_requests')
        .where('passengerId', isEqualTo: passengerId)
        .where('status', whereIn: ['completed', 'cancelled'])
        .snapshots()
        .map((snapshot) {
      var rides = snapshot.docs
          .map((d) => RideRequest.fromMap(d.id, d.data()))
          .where((r) => !r.isHiddenFromPassenger) // Filter soft deletes
          .toList();
      // Sort in-memory to avoid composite index requirements
      rides.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return rides;
    });
  }

  Future<void> rateRide(String rideId, double rating, String? comment) async {
    await _db.collection('ride_requests').doc(rideId).update({
      'rating': rating,
      'ratingComment': comment,
      'ratedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteRide(String rideId) async {
    // Soft delete: just hide it from passenger
    await _db.collection('ride_requests').doc(rideId).update({
      'isHiddenFromPassenger': true,
    });
  }

  Future<void> deleteRideForDriver(String rideId) async {
    // Soft delete: just hide it from driver
    await _db.collection('ride_requests').doc(rideId).update({
      'isHiddenFromDriver': true,
    });
  }
}
