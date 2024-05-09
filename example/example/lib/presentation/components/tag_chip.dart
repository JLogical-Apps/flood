import 'package:example_core/features/tag/tag.dart';
import 'package:flood/flood.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final Tag tag;

  const TagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return StyledChip.subtle(
      labelText: tag.nameProperty.value,
      foregroundColor: Color(tag.colorProperty.value),
    );
  }
}
