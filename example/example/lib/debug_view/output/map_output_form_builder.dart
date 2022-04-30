import 'package:example/debug_view/output/output_form_builder.dart';
import 'package:example/debug_view/output/output_form_builder_factory.dart';
import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class MapOutputFormBuilder extends OutputFormBuilder<Map> {
  late final OutputFormBuilderFactory outputFormBuilderFactory = OutputFormBuilderFactory();

  @override
  Widget build(Map value) {
    return StyledContent.low(
      children: value
          .mapToIterable<Widget>((key, value) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  outputFormBuilderFactory.getOutputFormBuilderByValueOrNull(key)!.build(key),
                  StyledBodyText(':'),
                  outputFormBuilderFactory.getOutputFormBuilderByValueOrNull(value)!.build(value),
                ],
              ))
          .intersperse(StyledDivider())
          .toList(),
    );
  }
}
