import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_go/Data/Models/AppUser.dart';

class UserRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser?> getUserById(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(doc.id, doc.data()!);
  }

  Future<void> createOrUpdateUser(AppUser user) async {
    await _db
        .collection('users')
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<void> updateUserFields(String uid, Map<String, dynamic> fields) async {
    await _db.collection('users').doc(uid).set(
      {
        ...fields,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }
  Stream<AppUser?> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.id, doc.data()!);
    });
  }

  Stream<List<AppUser>> availableDriversStream() {
    return _db
        .collection('users')
        .where('role', isEqualTo: 'driver')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((d) => AppUser.fromMap(d.id, d.data()))
            .toList());
  }
}
