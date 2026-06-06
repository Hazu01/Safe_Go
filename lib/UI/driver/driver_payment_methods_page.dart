import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/driver/driver_bottom_nav.dart';

class DriverPaymentMethodsPage extends StatelessWidget {
  const DriverPaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Payment Methods', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Payment methods screen coming soon.',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 3),
    );
  }
}
