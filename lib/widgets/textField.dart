import 'package:flutter/material.dart';

TextField buildTextField(TextEditingController controller, String label, IconData icon, TextInputType type) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: label,
      prefixIcon: Icon(icon),
    ),
    keyboardType: type,
  );
}
