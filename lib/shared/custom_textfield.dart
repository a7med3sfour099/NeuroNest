import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.hint,
    required this.isPass,
    required this.controller,
    this.keyboard,
    this.validator,
    this.onChanged,
    this.textInputAction,
  });

  final String hint;
  final bool isPass;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPass;
  }

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      keyboardType: widget.isPass
          ? TextInputType.visiblePassword
          : widget.keyboard,
      controller: widget.controller,
      cursorColor: Colors.black,
      cursorHeight: 20,
      validator: widget.validator,
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.isPass
            ? GestureDetector(
                onTap: _togglePasswordVisibility,
                child: Icon(
                  _obscureText
                      ? CupertinoIcons.eye_slash_fill
                      : CupertinoIcons.eye_fill,
                  color: Colors.black38,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffD9D9D9), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffD9D9D9), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xffD9D9D9), width: 2),
        ),
        labelText: widget.hint,
        labelStyle: TextStyle(color: Colors.black),
        fillColor: Color(0xffFFFFFF),
        filled: true,
      ),
    );
  }
}
