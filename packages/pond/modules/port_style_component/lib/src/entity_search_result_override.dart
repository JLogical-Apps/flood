import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:port_style/port_style.dart';
import 'package:style/style.dart';

class EntitySearchResultOverride with IsStyledSearchResultOverride<Entity> {
  @override
  Widget build(Entity result) {
    return StyledText.body(result.value.getLabel() ?? result.id!);
  }
}
