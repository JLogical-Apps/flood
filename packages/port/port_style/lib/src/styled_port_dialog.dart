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
  }) : super(body: _portBuilder(port: port, children: children));

  static Widget _portBuilder({required Port port, List<Widget>? children}) {
    return Builder(
      builder: (context) {
        return StyledList.column(
          children: [
            children == null
                ? StyledObjectPortBuilder(port: port)
                : PortBuilder(
                    port: port,
                    builder: (context, port) => StyledList.column(children: children),
                  ),
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
