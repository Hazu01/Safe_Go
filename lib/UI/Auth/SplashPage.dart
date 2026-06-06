import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/Auth/SplashVM.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
     
    Get.find<SplashVM>();
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, size: 64, color: Colors.lightBlueAccent),
            SizedBox(height: 16),
            CircularProgressIndicator(color: Colors.lightBlueAccent),
          ],
        ),
      ),
    );
  }
}
