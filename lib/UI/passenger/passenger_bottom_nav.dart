import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerBottomNav extends StatelessWidget {
  final int currentIndex;

  const PassengerBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    const Color darkBackground = Color(0xFF101317);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: darkBackground,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.home,
            "Home",
            currentIndex == 0,
            onTap: () {
              if (currentIndex != 0) Get.offNamed('/passenger/dashboard');
            },
          ),
          _buildNavItem(
            Icons.history,
            "Activity",
            currentIndex == 1,
            onTap: () {
              if (currentIndex != 1) Get.offNamed('/passenger/history');
            },
          ),
          _buildNavItem(
            Icons.person,
            "Profile",
            currentIndex == 2,
            onTap: () {
              if (currentIndex != 2) Get.offNamed('/passenger/profile');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xFF4CAF50) : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF4CAF50) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
