import 'package:drop/src/drop_hooks.dart';
import 'package:drop_core/drop_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';

class ReferenceBuilder<E extends Entity> extends HookWidget {
  final String id;
  final Widget Function(E? entity) builder;

  const ReferenceBuilder({super.key, required this.id, required this.builder});

  @override
  Widget build(BuildContext context) {
    final entityModel = useEntityOrNull<E>(id);
    return ModelBuilder(
      model: entityModel,
      builder: builder,
    );
  }
}
