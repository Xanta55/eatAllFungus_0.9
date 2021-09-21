import 'package:flutter/material.dart';

TextField buildTextInput(
    {required TextEditingController controller,
    TextInputType? inputType,
    String? hintText,
    bool? isObscured,
    Icon? iconInput}) {
  return TextField(
    autofocus: true,
    controller: controller,
    keyboardType: inputType ?? TextInputType.text,
    obscureText: isObscured ?? false,
    decoration: InputDecoration(
        icon: iconInput,
        border: OutlineInputBorder(),
        hintText: hintText ?? ''),
  );
}
