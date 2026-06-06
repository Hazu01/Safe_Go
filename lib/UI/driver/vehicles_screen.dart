import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/Data/Models/Vehicle.dart';
import 'package:safe_go/UI/driver/driver_bottom_nav.dart';
import 'package:safe_go/UI/driver/vehicles_vm.dart';

class MyVehiclesScreen extends StatefulWidget {
  const MyVehiclesScreen({super.key});

  @override
  State<MyVehiclesScreen> createState() => _MyVehiclesScreenState();
}

class _MyVehiclesScreenState extends State<MyVehiclesScreen> {
  final DriverVehiclesVM vm = Get.find<DriverVehiclesVM>();

  final _make = TextEditingController();
  final _model = TextEditingController();
  final _plate = TextEditingController();
  final _year = TextEditingController();
  final _color = TextEditingController();

  Vehicle? _editing;

   
  static const Color darkBackground = Color(0xFF101317);
  static const Color cardBackground = Color(0xFF1A222C);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color inputFieldColor = Color(0xFF141A21);

  @override
  void dispose() {
    _make.dispose();
    _model.dispose();
    _plate.dispose();
    _year.dispose();
    _color.dispose();
    super.dispose();
  }

  void _startEdit(Vehicle v) {
    setState(() {
      _editing = v;
      _make.text = v.make;
      _model.text = v.model;
      _plate.text = v.plateNumber;
      _year.text = v.year?.toString() ?? '';
      _color.text = v.color ?? '';
    });
  }

  void _clearForm() {
    setState(() {
      _editing = null;
      _make.clear();
      _model.clear();
      _plate.clear();
      _year.clear();
      _color.clear();
    });
  }

  Future<void> _submit() async {
    final make = _make.text.trim();
    final model = _model.text.trim();
    final plate = _plate.text.trim();
    final year = int.tryParse(_year.text.trim());
    final color = _color.text.trim().isEmpty ? null : _color.text.trim();

    if (make.isEmpty || model.isEmpty || plate.isEmpty) {
      Get.snackbar('Error', 'Make, model, and plate number are required');
      return;
    }

    final editing = _editing;
    if (editing == null) {
      await vm.createVehicle(make: make, model: model, plateNumber: plate, year: year, color: color);
      _clearForm();
      return;
    }

    await vm.updateVehicle(
      editing.copyWith(
        make: make,
        model: model,
        plateNumber: plate,
        year: year,
        color: color,
      ),
    );
    _clearForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'My Vehicles',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _clearForm,
            icon: const Icon(Icons.add, color: accentGreen),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editing == null ? 'Add New Vehicle' : 'Edit Vehicle',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Make', _make, inputFieldColor)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTextField('Model', _model, inputFieldColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('License Plate', _plate, inputFieldColor),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField('Year', _year, inputFieldColor, keyboard: TextInputType.number),
                      ),
                      const SizedBox(width: 15),
                      Expanded(child: _buildTextField('Color', _color, inputFieldColor)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (vm.isWorking.value) {
                      return const Center(child: CircularProgressIndicator(color: accentGreen));
                    }
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              _editing == null ? 'Register Vehicle' : 'Update Vehicle',
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (_editing != null) ...[
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 46,
                            child: OutlinedButton(
                              onPressed: _clearForm,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                            ),
                          ),
                        ]
                      ],
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 32),

             
            Obx(() {
              final count = vm.vehicles.length;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Fleet',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$count Vehicle${count == 1 ? '' : 's'}',
                    style: const TextStyle(color: accentGreen, fontSize: 14),
                  ),
                ],
              );
            }),

            const SizedBox(height: 16),

             
            Obx(() {
              if (vm.vehicles.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Text(
                    'No vehicles yet. Add your first vehicle above.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: vm.vehicles.length,
                itemBuilder: (context, index) {
                  final v = vm.vehicles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildVehicleCard(v),
                  );
                },
              );
            }),

            const SizedBox(height: 24),

             
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF142845),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info, color: Colors.blueAccent),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Make sure your vehicle documents are up to date. Expired documents may prevent you from going online.',
                      style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 3),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color bgColor, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboard,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(Vehicle v) {
    final subtitleParts = <String>[];
    if ((v.color ?? '').trim().isNotEmpty) subtitleParts.add(v.color!.trim());
    if (v.year != null) subtitleParts.add(v.year.toString());
    final subtitle = subtitleParts.isEmpty ? '' : subtitleParts.join(' • ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: v.isActive ? Border.all(color: accentGreen.withOpacity(0.5)) : null,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${v.make} ${v.model}',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: Colors.grey)),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        v.plateNumber,
                        style: const TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
              if (v.isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: v.isActive ? null : () => vm.setActive(v.id),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white10),
                    backgroundColor: v.isActive ? Colors.white.withOpacity(0.05) : null,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    v.isActive ? 'Active' : 'Set Active',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _startEdit(v),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton(
                  onPressed: () => vm.deleteVehicle(v.id),
                  child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
