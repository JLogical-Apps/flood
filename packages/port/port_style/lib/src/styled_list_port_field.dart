import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:port_style/src/object/port_field_builder_modifier.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';
import 'package:uuid/uuid.dart';

class StyledListPortField<T> extends HookWidget {
  final String fieldPath;

  final String? labelText;
  final Widget? label;

  const StyledListPortField({
    super.key,
    required this.fieldPath,
    this.labelText,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final label = this.label ?? labelText?.mapIfNonNull((labelText) => StyledText.body.bold.display(labelText));
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<Map<String, T?>>(
      fieldPath: fieldPath,
      builder: (context, field, value, error) {
        return StyledList.column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null)
              Padding(
                padding: const EdgeInsets.all(4),
                child: label,
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(4),
                child: StyledText.body.bold.error.centered(error.toString()),
              ),
            ...value.entries
                .mapIndexed((i, entry) {
                  final fieldPath = '${field.fieldPath}/$i';
                  final portField = port.getFieldByPath(fieldPath);
                  final editWidget =
                      PortFieldBuilderModifier.getPortFieldBuilderModifier(portField)?.getWidgetOrNull(portField);
                  if (editWidget == null) {
                    return null;
                  }

                  return MapEntry(entry.key, editWidget);
                })
                .whereNonNull()
                .mapIndexed((i, entry) => StyledList.row(
                      key: EquatableKey([i, entry.key]),
                      itemPadding: EdgeInsets.zero,
                      children: [
                        StyledButton.subtle(
                          icon: StyledIcon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            port[fieldPath] = value.copy()..remove(entry.key);
                          },
                        ),
                        Expanded(child: entry.value),
                      ],
                    ))
                .toList(),
            Center(
              child: StyledButton.subtle(
                labelText: 'Add',
                iconData: Icons.add,
                onPressed: () {
                  port[fieldPath] = {
                    ...value,
                    Uuid().v4(): null,
                  };
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
