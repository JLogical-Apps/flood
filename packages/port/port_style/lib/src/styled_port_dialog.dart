import 'dart:async';

import 'package:flutter/material.dart';
import 'package:port/port.dart';
import 'package:port_style/src/styled_object_port_builder.dart';
import 'package:style/style.dart';

class StyledPortDialog<T> extends StyledDialog<T> {
  final Port<T> port;

  StyledPortDialog({
    required this.port,
    super.title,
    super.titleText,
    List<Widget>? children,
    Map<String, Widget>? overrides,
    FutureOr Function(T result)? onAccept,
  }) : super(
          body: _portBuilder<T>(
            port: port,
            children: children,
            overrides: overrides,
            onAccept: onAccept,
          ),
        );

  static Widget _portBuilder<T>({
    required Port<T> port,
    List<Widget>? children,
    Map<String, Widget>? overrides,
    List<String>? order,
    FutureOr Function(T result)? onAccept,
  }) {
    assert(children == null || overrides == null, '`children` or `overrides` must be null!');
    return Builder(
      builder: (context) {
        return StyledList.column(
          children: [
            children == null
                ? StyledObjectPortBuilder(
                    port: port,
                    overrides: overrides ?? {},
                    order: order ?? [],
                  )
                : PortBuilder(
                    port: port,
                    builder: (context, port) {
                      return StyledList.column(
                        key: ValueKey(port.portValueByName),
                        children: children,
                      );
                    },
                  ),
            StyledButton(
              labelText: 'OK',
              onPressed: () async {
                final result = await port.submit();
                if (!result.isValid) {
                  return;
                }

                await onAccept?.call(result.data);

                Navigator.of(context).pop(result.data);
              },
            ),
          ],
        );
      },
    );
  }
}
