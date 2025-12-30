import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/custom_icon_button.dart';
import '../widget/custom_text_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _show('Fill all fields');
      return;
    }

    if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _show('Invalid email');
      return;
    }

    if (password != confirm) {
      _show('Passwords do not match');
      return;
    }

    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await cred.user!.sendEmailVerification();

      _show('Verification email sent');
      Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      _show('Registration error');
    }
  }

  void _show(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 90,
            child: Image.asset(
              'images/background_lines.png',
              height: h * 1,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomIconButton(icon: Icons.fitness_center, size: 60),
                      _circleIcon(Icons.favorite),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Fitness',
                    style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Registration',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),

                  const SizedBox(height: 30),

                  _form(),

                  const SizedBox(height: 25),

                  _actionButton('Registration', _register),

                  const SizedBox(height: 15),

                  // 🔁 переход на вход
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/signin'),
                    child: const Text(
                      'You already have an account? Sign In',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),

                  const Spacer(),

                  const CustomIconButton(icon: Icons.accessibility_new, size: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 60, spreadRadius: 10),
        ],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          CustomTextField(hintText: 'Email', controller: _emailController),
          const SizedBox(height: 12),
          CustomTextField(hintText: 'Password', isPassword: true, controller: _passwordController),
          const SizedBox(height: 12),
          CustomTextField(hintText: 'Confirm Password', isPassword: true, controller: _confirmPasswordController),
        ],
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
        child: Center(
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.white.withOpacity(0.6), blurRadius: 60, spreadRadius: 20),
        ],
      ),
      child: Icon(icon, color: Colors.black),
    );
  }
}
