import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/driver/driver_bottom_nav.dart';
import 'package:safe_go/UI/driver/driver_profile_vm.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DriverProfileVM vm = Get.find<DriverProfileVM>();

     
    const Color darkBackground = Color(0xFF101317);
    const Color cardBackground = Color(0xFF1A222C);
    const Color accentGreen = Color(0xFF4CAF50);
    const Color logoutRed = Color(0xFF2C1B1B);

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
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        final profile = vm.profile.value;
        final username = profile?.username ?? vm.currentDisplayName ?? profile?.name ?? 'Driver';
        final email = profile?.pendingEmail ?? vm.currentEmail ?? '';
        final phone = profile?.phone ?? '';
        final rating = (profile?.rating ?? 0).toStringAsFixed(1);

        if (vm.isLoading.value && profile == null) {
          return const Center(child: CircularProgressIndicator(color: accentGreen));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
               
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      final profilePic = vm.user.value?.profilePicture;
                      return GestureDetector(
                        onTap: () => vm.updateProfilePicture(),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: const Color(0xFFE0C9A6),
                              backgroundImage: profilePic != null ? NetworkImage(profilePic) : null,
                              child: profilePic == null 
                                  ? const Icon(Icons.person, size: 80, color: Colors.white70)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: accentGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Text(
                      username,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                     
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accentGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentGreen.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: accentGreen, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating == '0.0' ? 'No rating yet' : '$rating Rating',
                            style: const TextStyle(color: accentGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

               
              _buildSectionHeader("PERSONAL INFO"),
              _buildInfoCard(cardBackground, [
                _buildEditableListTile(
                  icon: Icons.person_outline,
                  title: "Username",
                  subtitle: username,
                  onTap: () => Get.toNamed('/driver/profile/editField', arguments: {'field': 'username'}),
                ),
                _buildDivider(),
                _buildEditableListTile(
                  icon: Icons.phone_outlined,
                  title: "Phone",
                  subtitle: phone,
                  onTap: () => Get.toNamed('/driver/profile/editField', arguments: {'field': 'phone'}),
                ),
                _buildDivider(),
                _buildEditableListTile(
                  icon: Icons.email_outlined,
                  title: "Email",
                  subtitle: email,
                  onTap: () => Get.toNamed('/driver/profile/editField', arguments: {'field': 'email'}),
                ),
              ]),

               
              const SizedBox(height: 24),
              _buildSectionHeader("DRIVER DASHBOARD"),
              _buildInfoCard(cardBackground, [
                _buildActionTile(
                  Icons.directions_car_outlined,
                  "Manage Vehicle",
                  accentGreen,
                  onTap: () => Get.toNamed('/driver/vehicles'),
                ),
                _buildDivider(),
                _buildActionTile(
                  Icons.payments_outlined,
                  "Payment Methods",
                  accentGreen,
                  onTap: () => Get.toNamed('/driver/paymentMethods'),
                ),
              ]),

               
              const SizedBox(height: 24),
              _buildSectionHeader("SETTINGS"),
              _buildInfoCard(cardBackground, [
                _buildActionTile(
                  Icons.lock_outline,
                  "Security & Password",
                  null,
                  onTap: () => Get.toNamed('/driver/changePassword'),
                ),
              ]),

              const SizedBox(height: 30),
               
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: logoutRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Log Out", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              const Text("Version 2.4.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
      bottomNavigationBar: const DriverBottomNav(currentIndex: 2),
    );
  }

   

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildInfoCard(Color bgColor, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildEditableListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildActionTile(
    IconData icon,
    String title,
    Color? iconColor, {
    String? trailingText,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, bool value) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: Switch(
        value: value,
        onChanged: (v) {},
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF4CAF50),
      ),
    );
  }

  Widget _buildDivider() => const Divider(color: Colors.white12, height: 1, indent: 50);

}
