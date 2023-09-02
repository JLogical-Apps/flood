import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:port/port.dart';
import 'package:port_style/port_style.dart';
import 'package:provider/provider.dart';
import 'package:style/style.dart';

class StyledStagePortField<E, T> extends HookWidget {
  final String fieldName;

  final String? labelText;
  final Widget? label;

  final bool enabled;

  final Widget Function(StagePortField<E, T> stagePortField, E value) valueWidgetMapper;
  final Widget Function(StagePortField<E, T> stagePortField, Port parentPort, String fieldName, Port<T> value)
      portWidgetMapper;
  final Widget Function(StagePortField<E, T> stagePortField, E value)? beforeBuilder;
  final Widget Function(StagePortField<E, T> stagePortField, E value)? afterBuilder;

  const StyledStagePortField({
    super.key,
    required this.fieldName,
    this.labelText,
    this.label,
    this.enabled = true,
    Widget Function(StagePortField<E, T> stagePortField, E value)? valueWidgetMapper,
    Widget Function(StagePortField<E, T> stagePortField, Port parentPort, String fieldName, Port<T> port)?
        portWidgetMapper,
    this.beforeBuilder,
    this.afterBuilder,
  })  : valueWidgetMapper = valueWidgetMapper ?? _defaultValueMapper,
        portWidgetMapper = portWidgetMapper ?? _defaultPortMapper;

  @override
  Widget build(BuildContext context) {
    final port = Provider.of<Port>(context, listen: false);
    return PortFieldBuilder<StageValue<E, T>>(
      fieldName: fieldName,
      builder: (context, field, value, error) {
        final stageField = (field.findStageFieldOrNull() ??
            (throw Exception('Could not find stage field for [$field]'))) as StagePortField<E, T>;
        final valuePort = value.port;

        final containerWidgets = [
          if (beforeBuilder != null)
            valuePort != null
                ? PortBuilder(
                    port: valuePort,
                    builder: (context, port) => beforeBuilder!(stageField, value.value),
                  )
                : beforeBuilder!(stageField, value.value),
          if (valuePort != null && valuePort.portFieldByName.isNotEmpty)
            portWidgetMapper(stageField, port, fieldName, valuePort),
          if (afterBuilder != null)
            valuePort != null
                ? PortBuilder(
                    port: valuePort,
                    builder: (context, port) => afterBuilder!(stageField, value.value),
                  )
                : afterBuilder!(stageField, value.value),
        ];

        return StyledList.column(
          itemPadding: EdgeInsets.symmetric(vertical: 4),
          children: [
            StyledOptionField<E>(
              value: value.value,
              labelText: label == null ? (labelText ?? field.findDisplayNameOrNull(port)) : null,
              label: label,
              errorText: error?.toString(),
              enabled: enabled,
              onChanged: (value) => port[fieldName] = stageField.getStageValue(value),
              options: stageField.options,
              widgetMapper: (option) => valueWidgetMapper(stageField, option),
            ),
            if (containerWidgets.isNotEmpty)
              StyledContainer(
                child: StyledList.column(children: containerWidgets),
              ),
          ],
        );
      },
    );
  }
}

Widget _defaultValueMapper<E, T>(StagePortField<E, T> stagePortField, E value) {
  return StyledText.button(value == null ? 'None' : stagePortField.getDisplayName(value) ?? 'None');
}

Widget _defaultPortMapper<E, T>(StagePortField<E, T> stagePortField, Port parentPort, String fieldName, Port<T> port) {
  return StyledObjectPortBuilder<T>(
    port: port,
    portListener: (subPort) {
      return parentPort[fieldName] = stagePortField.value.withPort(subPort);
    },
  );
}
