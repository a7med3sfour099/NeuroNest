import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthField extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime? initialDate;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  const DateOfBirthField({
    super.key,
    this.onDateSelected,
    this.initialDate,
    this.labelText = 'Date of birth',
    this.hintText = 'Select your date of birth',
    this.errorText,
  });

  @override
  State<DateOfBirthField> createState() => _DateOfBirthFieldState();
}

class _DateOfBirthFieldState extends State<DateOfBirthField> {
  DateTime? _selectedDate;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
      _controller.text = DateFormat('MM / dd / yyyy').format(_selectedDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('MM / dd / yyyy').format(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xffD9D9D9), width: 2),
        ),
        errorText: widget.errorText,
      ),
      onTap: () => _selectDate(context),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}