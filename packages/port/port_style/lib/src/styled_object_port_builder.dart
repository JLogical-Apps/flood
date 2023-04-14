import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class StyledObjectPortBuilder<T> extends HookWidget {
  final Port<T> port;
  final Map<String, Widget> overrides;

  final Function(Port<T> port)? portListener;

  StyledObjectPortBuilder({required this.port, this.overrides = const {}, this.portListener});

  @override
  Widget build(BuildContext context) {
    useListen(useMemoized(() => port.getPortX(), [port]), (_) => portListener?.call(port));
    return PortBuilder(
      key: ObjectKey(port),
      port: port,
      builder: (context, port) {
        final providedOverrides = Provider.of<StyledObjectPortOverrides>(context, listen: false);
        final portOverride = providedOverrides.getOverrideByTypeOrNullRuntime(port.submitType);
        if (overrides.isEmpty && portOverride != null) {
          return portOverride.build(port);
        }

        final portFieldByName = port.portFieldByName;
        return StyledList.column(
          children: portFieldByName
              .mapToIterable((name, portField) {
                if (overrides.containsKey(name)) {
                  return overrides[name];
                }

                return PortFieldBuilderModifier.getPortFieldBuilderModifier(portField)
                    ?.getWidgetOrNull(port, name, portField);
              })
              .whereNonNull()
              .toList(),
        );
      },
    );
  }
}
