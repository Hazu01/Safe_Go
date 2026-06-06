import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_go/Data/Models/DriverProfile.dart';

class DriverProfileRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<DriverProfile?> getByUserId(String uid) async {
    final doc = await _db.collection('driver_profiles').doc(uid).get();
    if (!doc.exists) return null;
    return DriverProfile.fromMap(doc.id, doc.data()!);
  }

  Future<void> save(DriverProfile profile) async {
    await _db
        .collection('driver_profiles')
        .doc(profile.id)
        .set(profile.toMap(), SetOptions(merge: true));
  }

  Future<void> updateRating(String driverId, double newRating) async {
    final docRef = _db.collection('driver_profiles').doc(driverId);
    
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final currentRating = (data['rating'] as num?)?.toDouble() ?? 0.0;
      final count = (data['ratingCount'] as num?)?.toInt() ?? 0;

      final newCount = count + 1;
      final updatedRating = ((currentRating * count) + newRating) / newCount;

      transaction.update(docRef, {
        'rating': updatedRating,
        'ratingCount': newCount,
      });
    });
  }
}
