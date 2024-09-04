import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final bool showToggle;
  final void Function()? togglePasswordView;

  const CustomTextField({
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.showToggle = false,
    this.togglePasswordView,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: showToggle
            ? IconButton(
                icon: Icon(isPassword ? Icons.visibility : Icons.visibility_off),
                onPressed: togglePasswordView,
              )
            : null,
      ),
    );
  }
}
