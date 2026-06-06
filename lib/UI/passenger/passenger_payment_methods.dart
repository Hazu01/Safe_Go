import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PassengerPaymentMethodsPage extends StatelessWidget {
  const PassengerPaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0F172A);
    const Color cardBg = Color(0xFF1E293B);
    const Color accentGreen = Color(0xFF4CAF50);

    // Get the currently selected method passed as argument, default to 'Cash'
    final String currentMethod = Get.arguments?['currentMethod'] ?? 'Cash';

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text('Payment Methods', style: TextStyle(color: Colors.white)),
        backgroundColor: darkBg,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMethodCard('Cash', Icons.money, currentMethod == 'Cash', cardBg, accentGreen, () {
            Get.back(result: 'Cash');
          }),
          const SizedBox(height: 12),
          _buildMethodCard('Card', Icons.credit_card, currentMethod == 'Card', cardBg, accentGreen, () {
            Get.back(result: 'Card');
          }),
           const SizedBox(height: 12),
          // _buildAddButton(accentGreen), // Hidden as per request to focused on 2 options
        ],
      ),
    );
  }

  Widget _buildMethodCard(String title, IconData icon, bool isSelected, Color bg, Color accent, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: accent, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16))),
            if (isSelected) Icon(Icons.check_circle, color: accent),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(Color accent) {
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {
          Get.snackbar('Coming Soon', 'Add card feature is under construction.');
        },
        icon: Icon(Icons.add, color: accent),
        label: Text('Add Payment Method', style: TextStyle(color: accent)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: accent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
