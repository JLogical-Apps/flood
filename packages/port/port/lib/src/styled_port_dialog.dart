import 'package:flutter/material.dart';
import 'package:port/src/port_builder.dart';
import 'package:port_core/port_core.dart';
import 'package:style/style.dart';

class StyledPortDialog<T> extends StyledDialog<T> {
  final Port<T> port;

  StyledPortDialog({
    required this.port,
    super.title,
    super.titleText,
    required List<Widget> children,
  }) : super(body: _portBuilder(port: port, children: children));

  static Widget _portBuilder({required Port port, required List<Widget> children}) {
    return PortBuilder(
      port: port,
      builder: (context, port) {
        return StyledList.column(
          children: [
            ...children,
            StyledButton(
              labelText: 'OK',
              onPressed: () async {
                final result = await port.submit();
                if (!result.isValid) {
                  return;
                }

                Navigator.of(context).pop(result.data);
              },
            ),
          ],
        );
      },
    );
  }
}
