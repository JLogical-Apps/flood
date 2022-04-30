import 'package:example/debug_view/output/output_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class DefaultOutputFormBuilder extends OutputFormBuilder<dynamic> {
  @override
  Widget build(value) {
    return StyledBodyText(value?.toString() ?? 'N/A');
  }
}
