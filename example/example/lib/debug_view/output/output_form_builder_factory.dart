import 'package:example/debug_view/output/default_output_form_builder.dart';
import 'package:example/debug_view/output/output_form_builder.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import 'list_output_form_builder.dart';
import 'map_output_form_builder.dart';

class OutputFormBuilderFactory {
  final WrapperResolver<dynamic, OutputFormBuilder> formBuilderResolver = WrapperResolver([
    MapOutputFormBuilder(),
    ListOutputFormBuilder(),
    DefaultOutputFormBuilder(),
  ]);

  OutputFormBuilder? getOutputFormBuilderByValueOrNull(dynamic value) {
    return formBuilderResolver.resolveOrNull(value);
  }
}
