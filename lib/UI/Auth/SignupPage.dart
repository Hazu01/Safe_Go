
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_go/UI/Auth/SignupVM.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isPassVisible = false;
  bool _isConfirmVisible = false;

  final signupVM = Get.find<SignupVM>();

  void _signup() async {
    if (_passwordController.text != _confirmController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    await signupVM.signup(
      _emailController.text,
      _passwordController.text,
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String hint,
      IconData icon, {
        bool isPassword = false,
        bool visible = false,
        VoidCallback? toggleVisible,
        TextInputType keyboard = TextInputType.text,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.15)),
            color: const Color(0xFF0E1A26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? !visible : false,
            keyboardType: keyboard,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  visible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: toggleVisible,
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1520),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                "Join the Ride",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Create an account to start sharing rides.",
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
              const SizedBox(height: 30),

              _buildTextField(_nameController, "Full Name", "Enter your full name", Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField(_emailController, "Email", "Enter your email address", Icons.email_outlined, keyboard: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, "Password", "Enter your password", Icons.lock_outline,
                  isPassword: true, visible: _isPassVisible, toggleVisible: () => setState(() => _isPassVisible = !_isPassVisible)),
              const SizedBox(height: 20),
              _buildTextField(_confirmController, "Confirm Password", "Confirm your password", Icons.lock_outline,
                  isPassword: true, visible: _isConfirmVisible, toggleVisible: () => setState(() => _isConfirmVisible = !_isConfirmVisible)),
              const SizedBox(height: 30),

              Obx(() {
                if (signupVM.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: Colors.blueAccent));
                } else {
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }
              }),
              const SizedBox(height: 15),
              Center(
                child: GestureDetector(
                  onTap: () => Get.offAllNamed('/login'),
                  child: const Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(color: Colors.blueAccent, fontSize: 14, fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
