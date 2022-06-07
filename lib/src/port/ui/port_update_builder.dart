import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../utils/export.dart';
import '../model/port.dart';

class PortUpdateBuilder extends HookWidget {
  final Widget Function(Port port) builder;

  PortUpdateBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);

    final valueByNameX = port.rawValueByNameX;
    useValueStream(valueByNameX);

    final exceptionByNameX = port.exceptionByNameX;
    useValueStream(exceptionByNameX);

    return builder(port);
  }
}
