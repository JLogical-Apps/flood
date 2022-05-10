import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/form/export_core.dart';
import 'package:provider/provider.dart';

import '../../utils/export.dart';

abstract class FormFieldModelWidget<T> extends HookWidget {
  final String name;

  FormFieldModelWidget({Key? key, required this.name}) : super(key: key);

  Widget buildField(BuildContext context, T value);

  void setValue(BuildContext context, T newValue) {
    getFormModel(context)[name] = newValue;
  }

  FormModel getFormModel(BuildContext context) {
    return Provider.of<FormModel>(context, listen: false);
  }

  FormFieldModel<T> getFieldModel(BuildContext context) {
    return getFormModel(context).getFieldByName(name) as FormFieldModel<T>;
  }

  @override
  Widget build(BuildContext context) {
    final valueX = useMemoized(() => getFormModel(context).getFieldValueXByName(name));
    final value = useValueStream(valueX);

    return buildField(context, value);
  }
}
