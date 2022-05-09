import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/form/export_core.dart';
import 'package:provider/provider.dart';

import '../../utils/export.dart';

abstract class FormFieldModelBuilder<T> extends HookWidget {
  final String name;

  FormFieldModelBuilder({Key? key, required this.name}) : super(key: key);

  Widget buildField(BuildContext context, T value);

  void setValue(BuildContext context, T newValue) {
    Provider.of<FormModel>(context).set(name, newValue);
  }

  @override
  Widget build(BuildContext context) {
    final valueX = useMemoized(() => Provider.of<FormModel>(context).getFieldValueXByName(name));
    final value = useValueStream(valueX);

    return buildField(context, value);
  }
}
