import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collectionRef(String path) {
    return _db.collection(path);
  }

  Future<DocumentReference<Map<String, dynamic>>> add(
    String path,
    Map<String, dynamic> data,
  ) async {
    return await collectionRef(path).add(data);
  }

  Future<void> set(
    String path,
    String id,
    Map<String, dynamic> data,
    {
      bool merge = false,
    }
  ) async {
    return await collectionRef(path).doc(id).set(data, SetOptions(merge: merge));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDoc(String path, String id) async {
    return await collectionRef(path).doc(id).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection(String path) {
    return collectionRef(path).snapshots();
  }

  Future<void> update(String path, String id, Map<String, dynamic> data) async {
    return await collectionRef(path).doc(id).update(data);
  }

  Future<void> delete(String path, String id) async {
    return await collectionRef(path).doc(id).delete();
  }
}
