import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/custom_icon_button.dart';
import '../widget/custom_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!cred.user!.emailVerified) {
        _show('Verify your email');
        await FirebaseAuth.instance.signOut();
        return;
      }

      _show('Login successful');
    } catch (e) {
      _show('Login error');
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
            top: 30,
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
                      _circleIcon(Icons.lock),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Fitness',
                    style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),

                  const SizedBox(height: 30),

                  Container(
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  _actionButton('Sign In', _login),

                  const SizedBox(height: 15),

                  // 🔁 переход на регистрацию
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/'),
                    child: const Text(
                      "Don't have an account? Sign Up",
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
          BoxShadow(color: Colors.white, blurRadius: 60, spreadRadius: 20),
        ],
      ),
      child: Icon(icon, color: Colors.black),
    );
  }
}
