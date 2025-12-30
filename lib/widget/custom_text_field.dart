import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller; // добавляем контроллер

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller, // добавляем сюда
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller, // используем контроллер
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
    );
  }
}