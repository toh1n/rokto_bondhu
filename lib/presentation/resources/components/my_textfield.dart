import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final validator;
  final onSaved;
  final keyboardType;
  final initialValue;

  const MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.validator,
    this.onSaved,
    this.keyboardType,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        keyboardType: keyboardType,
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        onSaved: onSaved,
        initialValue: initialValue,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
