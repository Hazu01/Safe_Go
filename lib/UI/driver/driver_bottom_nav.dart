import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverBottomNav extends StatelessWidget {
  final int currentIndex;

  const DriverBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0F172A);
    const Color accentBlue = Color(0xFF0084FF);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            Get.offAllNamed('/driver/dashboard');
            break;
          case 1:
            Get.offAllNamed('/driver/history');
            break;
          case 2:
            Get.offAllNamed('/driver/profile');
            break;
        }
      },
      backgroundColor: darkBg,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: accentBlue,
      unselectedItemColor: Colors.blueGrey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_rounded),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
