import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/driver/driver_bottom_nav.dart';
import 'package:safe_go/UI/driver/driver_profile_vm.dart';

 
 
class DriverProfileEditFieldPage extends StatefulWidget {
  const DriverProfileEditFieldPage({super.key});

  @override
  State<DriverProfileEditFieldPage> createState() => _DriverProfileEditFieldPageState();
}

class _DriverProfileEditFieldPageState extends State<DriverProfileEditFieldPage> {
  final DriverProfileVM vm = Get.find<DriverProfileVM>();
  final _controller = TextEditingController();

  String _field = 'name';
  String _title = 'Edit';
  TextInputType _keyboard = TextInputType.text;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is Map && args['field'] is String) {
      _field = args['field'] as String;
    }

    switch (_field) {
      case 'username':
        _title = 'Edit Username';
        _keyboard = TextInputType.text;
        _controller.text = vm.profile.value?.username ?? vm.currentDisplayName ?? '';
        break;
      case 'phone':
        _title = 'Edit Phone';
        _keyboard = TextInputType.phone;
        _controller.text = vm.profile.value?.phone ?? '';
        break;
      case 'email':
        _title = 'Edit Email';
        _keyboard = TextInputType.emailAddress;
        _controller.text = vm.profile.value?.pendingEmail ?? vm.currentEmail ?? '';
        break;
      case 'name':
      default:
        _title = 'Edit Name';
        _keyboard = TextInputType.text;
        _controller.text = vm.profile.value?.name ?? '';
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      Get.snackbar('Error', 'Value cannot be empty');
      return;
    }

    switch (_field) {
      case 'username':
        await vm.updateUsername(value);
        break;
      case 'phone':
        await vm.updatePhone(value);
        break;
      case 'email':
        await vm.updateEmail(value);
        break;
      case 'name':
      default:
        await vm.updateName(value);
        break;
    }

    if (mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0F172A);
    const Color cardBg = Color(0xFF1E293B);
    const Color accentBlue = Color(0xFF0084FF);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(_title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                controller: _controller,
                keyboardType: _keyboard,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (vm.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: accentBlue));
              }
              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 3),
    );
  }
}
