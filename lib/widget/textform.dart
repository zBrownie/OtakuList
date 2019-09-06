import 'package:flutter/material.dart';

class FieldForm extends StatelessWidget {
  final Icon icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final Function validator;
  final TextInputType textInputType;
  final bool obscureText;

  FieldForm(
      {this.icon,
      this.label,
      @required this.hint,
      this.controller,
      this.validator,
      this.textInputType,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      validator: this.validator,
      obscureText: this.obscureText,
      style: TextStyle(fontSize: 19.0),
      decoration: InputDecoration(
        prefixIcon: this.icon,
        contentPadding: EdgeInsets.all(10.0),
        labelText: this.label,
        hintText: this.hint,
        hintStyle: TextStyle(fontSize: 20.0),
        labelStyle: TextStyle(fontSize: 20.0),
        errorStyle: TextStyle(fontSize: 20.0),
        
      ),
    );
  }
}