import 'package:example/debug_view/output/output_form_builder.dart';
import 'package:example/debug_view/output/output_form_builder_factory.dart';
import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class ListOutputFormBuilder extends OutputFormBuilder<List> {
  late final OutputFormBuilderFactory outputFormBuilderFactory = OutputFormBuilderFactory();

  @override
  Widget build(List value) {
    return StyledContent.low(
      children: value
          .map<Widget>((value) => outputFormBuilderFactory.getOutputFormBuilderByValueOrNull(value)!.build(value))
          .intersperse(StyledDivider())
          .toList(),
    );
  }
}
