import 'package:example/presentation/components/tag_chip.dart';
import 'package:example_core/features/tag/tag_entity.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

class StyledTagSearchResultOverride with IsStyledSearchResultOverride<TagEntity> {
  @override
  Widget build(TagEntity result) {
    return TagChip(tag: result.value);
  }
}
