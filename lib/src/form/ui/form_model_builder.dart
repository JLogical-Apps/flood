import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/form_model.dart';

class FormModelBuilder extends StatelessWidget {
  final FormModel form;

  final Widget child;

  FormModelBuilder({
    required this.form,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => form,
      child: child,
    );
  }
}
