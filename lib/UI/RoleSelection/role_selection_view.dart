import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/RoleSelection/role_selection_vm.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {

  int? selectedRole;
  final RoleSelectionVM vm = Get.find<RoleSelectionVM>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Obx(() {
            final isLoading = vm.isLoading.value;
            return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your role to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey[300],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),

              _buildRoleCard(
                index: 0,
                icon: Icons.hail_rounded,
                title: "I'm a Passenger",
                subtitle: "Find a ride and share the journey.",
              ),
              const SizedBox(height: 16),
              _buildRoleCard(
                index: 1,
                icon: Icons.directions_car_rounded,
                title: "I'm a Driver",
                subtitle: "Offer rides and earn money.",
              ),

              const Spacer(),

              Text(
                'You can always switch roles later in your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey[400], fontSize: 14),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: (selectedRole != null && !isLoading)
                    ? () {
                        final role = selectedRole == 0 ? 'passenger' : 'driver';
                        vm.selectRole(role);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0084FF),
                  disabledBackgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ],
          );
          }),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    bool isSelected = selectedRole == index;

    return GestureDetector(
      onTap: () => setState(() => selectedRole = index),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),  
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0084FF) : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF0084FF) : Colors.white, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.blueGrey[300], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}