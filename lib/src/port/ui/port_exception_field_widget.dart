import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import 'package:provider/provider.dart';

import '../../widgets/export.dart';
import '../model/port.dart';

abstract class PortExceptionFieldWidget extends HookWidget {
  final String name;

  PortExceptionFieldWidget({super.key, required this.name});

  Port getPort(BuildContext context) {
    return Provider.of<Port>(context, listen: false);
  }

  Widget buildException(BuildContext context, Object exception);

  @override
  Widget build(BuildContext context) {
    final port = getPort(context);

    final exceptionX = useMemoized(() => port.getExceptionXByName(name));
    final exception = useValueStream(exceptionX);

    if (exception == null) {
      return EmptyWidget();
    }

    return buildException(context, exception);
  }
}
