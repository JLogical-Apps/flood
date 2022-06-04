import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../utils/export.dart';
import '../model/port.dart';
import '../model/port_field.dart';

/// A widget that builds and updates a PortField of type [F] with an internal state of [R],
/// which [F] should be able to translate into [T] in its `valueParser` method.
abstract class PortFieldWidget<F extends PortField<T>, T, R> extends HookWidget {
  final String name;

  PortFieldWidget({super.key, required this.name});

  Widget buildField(BuildContext context, F field, R value, Object? exception);

  R getInitialRawValue(T portValue) {
    return portValue as R;
  }

  void setValue(BuildContext context, R newValue) {
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

    useOneTimeEffect(() {
      port[name] = getInitialRawValue(port[name]);
    });

    final rawValueX = useMemoized(() => port.getRawFieldValueXByName(name));
    final rawValue = useValueStream(rawValueX);

    final exceptionX = useMemoized(() => port.getExceptionXByName(name));
    final exception = useValueStream(exceptionX);

    return buildField(context, field as F, rawValue, exception);
  }
}
