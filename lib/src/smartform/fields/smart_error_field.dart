import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/smartform/fields/smart_field.dart';

/// Only shows up when an error is present with its name.
class SmartErrorField extends StatelessWidget {
  final String name;

  const SmartErrorField({required this.name});

  @override
  Widget build(BuildContext context) {
    return SmartField(
      name: name,
      builder: (value, error) {
        if (error == null) {
          return SizedBox.shrink();
        } else {
          return Text(
            error,
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
