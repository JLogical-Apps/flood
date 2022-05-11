import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../utils/export.dart';
import '../model/port_field.dart';
import '../model/port_model.dart';

abstract class PortFieldWidget<F extends PortField<T>, T> extends HookWidget {
  final String name;

  PortFieldWidget({Key? key, required this.name}) : super(key: key);

  Widget buildField(BuildContext context, F field, T value);

  void setValue(BuildContext context, T newValue) {
    getPort(context)[name] = newValue;
  }

  Port getPort(BuildContext context) {
    return Provider.of<Port>(context, listen: false);
  }

  PortField<T> getPortField(BuildContext context) {
    return getPort(context).getFieldByName(name) as PortField<T>;
  }

  @override
  Widget build(BuildContext context) {
    final port = getPort(context);
    final field = port.getFieldByName(name);

    final valueX = useMemoized(() => port.getFieldValueXByName(name));
    final value = useValueStream(valueX);

    return buildField(context, field as F, value);
  }
}
