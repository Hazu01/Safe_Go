import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF101317);
    const Color cardBg = Color(0xFF1A222C);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        leading: const Icon(Icons.arrow_back),
        title: const Text("Notifications"),
        centerTitle: true,
        actions: [const Icon(Icons.settings), const SizedBox(width: 16)],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _sectionHeader("TODAY"),
          _notificationCard("Driver Arrived", "Your driver Michael is waiting...", "2 mins ago", Icons.directions_car, Colors.green, true),
          _notificationCard("New Ride Request", "Pickup at 123 Main St • Dropoff at Downtown...", "15 mins ago", Icons.person_pin_circle, Colors.blue, false),
          _notificationCard("Ride Completed", "You have arrived at your destination.", "2 hours ago", Icons.check_circle, Colors.green, false),
          _sectionHeader("YESTERDAY"),
          _notificationCard("Weekend Bonus!", "Drive this weekend and earn an extra 10%...", "Yesterday, 4:30 PM", Icons.campaign, Colors.purple, false),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.done_all, color: Colors.green),
          label: const Text("Mark all as read", style: TextStyle(color: Colors.green)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white10),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
  );

  Widget _notificationCard(String title, String sub, String time, IconData icon, Color iconCol, bool isNew) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A222C),
        borderRadius: BorderRadius.circular(12),
        border: isNew ? Border.all(color: Colors.green.withOpacity(0.5)) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: iconCol.withOpacity(0.1), child: Icon(icon, color: iconCol, size: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    if (isNew) const CircleAvatar(radius: 4, backgroundColor: Colors.green),
                  ],
                ),
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 13), maxLines: 2),
                const SizedBox(height: 8),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}