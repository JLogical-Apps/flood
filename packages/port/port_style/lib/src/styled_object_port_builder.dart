import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:type_core/type_core.dart';
import 'package:utils/utils.dart';

class StyledObjectPortBuilder<T> extends HookWidget {
  final Port<T> port;
  final Map<String, Widget> overrides;
  final List<String>? only;
  final List<String>? order;
  final bool useOverrides;

  final Function(Port<T> port)? portListener;

  StyledObjectPortBuilder({
    super.key,
    required this.port,
    this.overrides = const {},
    this.only,
    this.order,
    this.useOverrides = true,
    this.portListener,
  });

  @override
  Widget build(BuildContext context) {
    useListen(useMemoized(() => port.getPortX(), [port]), (_) => portListener?.call(port));
    return PortBuilder(
      key: ObjectKey(port),
      port: port,
      builder: (context, port) {
        if (useOverrides) {
          final providedOverrides = context.read<StyledObjectPortOverrides>();
          final portOverride = providedOverrides.getOverrideByTypeOrNullRuntime(
            context.find<TypeCoreComponent>(),
            port.submitType,
          );
          if (overrides.isEmpty && order == null && only == null && portOverride != null) {
            return portOverride.build(port);
          }
        }

        var portFieldByName = port.portFieldByName;
        if (only != null) {
          portFieldByName = portFieldByName.where((name, portField) => only!.contains(name));
        }

        return StyledList.column(
          children: portFieldByName.entries
              .sorted((a, b) => _sortByOrder(a, b))
              .map((entry) {
                final name = entry.key;
                final portField = entry.value;

                if (overrides.containsKey(name)) {
                  return overrides[name];
                }

                return PortFieldBuilderModifier.getPortFieldBuilderModifier(portField)?.getWidgetOrNull(portField);
              })
              .whereNonNull()
              .toList(),
        );
      },
    );
  }

  int _sortByOrder(MapEntry<String, PortField> a, MapEntry<String, PortField> b) {
    final order = this.order ?? [];

    var aIndex = order.indexOf(a.key);
    var bIndex = order.indexOf(b.key);

    aIndex = aIndex == -1 ? order.length : aIndex;
    bIndex = bIndex == -1 ? order.length : bIndex;

    return aIndex.compareTo(bIndex);
  }
}
