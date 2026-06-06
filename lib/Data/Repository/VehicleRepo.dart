import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_go/Data/Models/Vehicle.dart';

class VehicleRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _vehiclesRef(String driverId) {
    return _db.collection('driver_profiles').doc(driverId).collection('vehicles');
  }

  Stream<List<Vehicle>> streamVehicles(String driverId) {
    return _vehiclesRef(driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Vehicle.fromMap(d.id, d.data())).toList());
  }

  Future<String> createVehicle(String driverId, Vehicle vehicle) async {
    final doc = _vehiclesRef(driverId).doc();
    await doc.set(vehicle.copyWith(createdAt: DateTime.now()).toMap(), SetOptions(merge: true));
    return doc.id;
  }

  Future<void> updateVehicle(String driverId, Vehicle vehicle) async {
    await _vehiclesRef(driverId).doc(vehicle.id).set(vehicle.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteVehicle(String driverId, String vehicleId) async {
    await _vehiclesRef(driverId).doc(vehicleId).delete();
  }

  Future<void> setActiveVehicle(String driverId, String vehicleId) async {

    final profileRef = _db.collection('driver_profiles').doc(driverId);

    final snap = await _vehiclesRef(driverId).get();
    final batch = _db.batch();

    Vehicle? activeVehicle;
    for (final doc in snap.docs) {
      final isNewActive = doc.id == vehicleId;
      if (isNewActive) {
        activeVehicle = Vehicle.fromMap(doc.id, doc.data());
      }
      batch.update(doc.reference, {'isActive': isNewActive});
    }

    final Map<String, dynamic> profileUpdates = {'activeVehicleId': vehicleId};
    if (activeVehicle != null) {
      profileUpdates['vehicleModel'] = '${activeVehicle.make} ${activeVehicle.model}';
      profileUpdates['plateNumber'] = activeVehicle.plateNumber;
    }

    batch.set(profileRef, profileUpdates, SetOptions(merge: true));

    // Also sync to users collection for quick access in available drivers list
    if (activeVehicle != null) {
      final userRef = _db.collection('users').doc(driverId);
      batch.update(userRef, {
        'vehicleModel': '${activeVehicle.make} ${activeVehicle.model}',
        'plateNumber': activeVehicle.plateNumber,
      });
    }

    await batch.commit();
  }
}
