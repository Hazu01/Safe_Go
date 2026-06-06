import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/passenger/passenger_profile_vm.dart';
import 'package:safe_go/UI/Auth/LogoutVM.dart';
import 'package:safe_go/UI/passenger/passenger_profile_edit_field.dart';
import 'package:safe_go/UI/passenger/passenger_profile_edit_field.dart';
import 'package:safe_go/UI/passenger/passenger_payment_methods.dart';
import 'package:safe_go/UI/passenger/passenger_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PassengerProfileVM vm = Get.find<PassengerProfileVM>();
    final LogoutVM logoutVM = Get.find<LogoutVM>();
    
     
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
          onPressed: () => Get.offNamed('/passenger/dashboard'),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
           
           
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
             
            Center(
              child: Column(
                children: [
                  Obx(() {
                    final u = vm.user.value;
                    final image = u?.profilePicture;
                    return Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: const Color(0xFFE0C9A6),
                          backgroundImage: image != null && image.isNotEmpty ? NetworkImage(image) : null,
                          child: image == null || image.isEmpty 
                              ? const Icon(Icons.person, size: 80, color: Colors.white70) 
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => vm.updateProfilePicture(),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: accentGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 16),
                  Obx(() {
                    final u = vm.user.value;
                    final name = u?.displayName ?? 'Guest';
                    final email = u?.email ?? '---';
                    return Column(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 12),
                   
                  const SizedBox(height: 12),
                  // Removed Rating Widget as requested
                ],
              ),
            ),
            const SizedBox(height: 30),

             
            _buildSectionHeader("PERSONAL INFO"),
            _buildInfoCard(cardBackground, [
              Obx(() => _buildActionTile(
                    Icons.person_outline,
                    "Name",
                    null,
                    trailingText: vm.user.value?.displayName ?? 'Set Name',
                    onTap: () => Get.to(() => const PassengerProfileEditFieldPage(), arguments: {'field': 'name'}),
                  )),
              _buildDivider(),
              Obx(() => _buildActionTile(
                    Icons.phone_outlined,
                    "Phone",
                    null,
                    trailingText: vm.user.value?.phone ?? 'Set Phone',
                    onTap: () => Get.to(() => const PassengerProfileEditFieldPage(), arguments: {'field': 'phone'}),
                  )),
              _buildDivider(),
              Obx(() => _buildActionTile(
                    Icons.email_outlined,
                    "Email",
                    null,
                    trailingText: vm.user.value?.email ?? 'Set Email',
                    onTap: () => Get.to(() => const PassengerProfileEditFieldPage(), arguments: {'field': 'email'}),
                  )),
            ]),

             
            const SizedBox(height: 24),
            _buildSectionHeader("PAYMENT"),
            _buildInfoCard(cardBackground, [
              _buildActionTile(
                Icons.payment,
                "Payment Methods",
                accentGreen,
                onTap: () => Get.to(() => const PassengerPaymentMethodsPage()),
              ),
            ]),

             
            const SizedBox(height: 24),
            _buildSectionHeader("SETTINGS"),
            _buildInfoCard(cardBackground, [
              _buildActionTile(
                Icons.lock_outline,
                "Security & Password",
                null,
                onTap: () => Get.toNamed('/change'),
              ),
            ]),

            const SizedBox(height: 30),
             
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => logoutVM.logout(),
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
            const SizedBox(height: 100),  
          ],
        ),
      ),
      bottomNavigationBar: const PassengerBottomNav(currentIndex: 2),
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

  Widget _buildActionTile(IconData icon, String title, Color? iconColor, {String? trailingText, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: const Color(0xFF4CAF50),
      ),
    );
  }

  Widget _buildDivider() => const Divider(color: Colors.white12, height: 1, indent: 50);


}