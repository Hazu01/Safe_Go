import 'dart:async';

import 'package:get/get.dart';
import 'package:safe_go/Data/Models/Vehicle.dart';
import 'package:safe_go/Data/Repository/AuthRepo.dart';
import 'package:safe_go/Data/Repository/VehicleRepo.dart';

class DriverVehiclesVM extends GetxController {
  final AuthRepo authRepo = Get.find();
  final VehicleRepo vehicleRepo = Get.find();

  final vehicles = <Vehicle>[].obs;
  final isWorking = false.obs;

  StreamSubscription? _sub;
  String? _driverId;

  @override
  void onInit() {
    super.onInit();
    final user = authRepo.getCurrentUser();
    if (user == null) return;
    _driverId = user.uid;

    _sub = vehicleRepo.streamVehicles(user.uid).listen((list) {
      vehicles.value = list;
    });
  }

  Future<void> createVehicle({
    required String make,
    required String model,
    required String plateNumber,
    int? year,
    String? color,
  }) async {
    final driverId = _driverId;
    if (driverId == null) {
      Get.offAllNamed('/login');
      return;
    }

    isWorking.value = true;
    try {
      await vehicleRepo.createVehicle(
        driverId,
        Vehicle(
          id: '',
          make: make,
          model: model,
          plateNumber: plateNumber,
          year: year,
          color: color,
        ),
      );
      Get.snackbar('Success', 'Vehicle added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add vehicle');
    } finally {
      isWorking.value = false;
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    final driverId = _driverId;
    if (driverId == null) {
      Get.offAllNamed('/login');
      return;
    }

    isWorking.value = true;
    try {
      await vehicleRepo.updateVehicle(driverId, vehicle);
      Get.snackbar('Success', 'Vehicle updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update vehicle');
    } finally {
      isWorking.value = false;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    final driverId = _driverId;
    if (driverId == null) {
      Get.offAllNamed('/login');
      return;
    }

    isWorking.value = true;
    try {
      await vehicleRepo.deleteVehicle(driverId, vehicleId);
      Get.snackbar('Success', 'Vehicle deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete vehicle');
    } finally {
      isWorking.value = false;
    }
  }

  Future<void> setActive(String vehicleId) async {
    final driverId = _driverId;
    if (driverId == null) {
      Get.offAllNamed('/login');
      return;
    }

    isWorking.value = true;
    try {
      await vehicleRepo.setActiveVehicle(driverId, vehicleId);
      Get.snackbar('Success', 'Active vehicle updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to set active vehicle');
    } finally {
      isWorking.value = false;
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
