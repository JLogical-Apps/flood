import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/export.dart';
import '../model/port.dart';

class PortUpdateBuilder extends StatelessWidget {
  final Widget Function(Port port) builder;

  PortUpdateBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    final valueByNameX = port.valueByNameX;
    final valueByName = useValueStream(valueByNameX);

    return builder(port);
  }
}
