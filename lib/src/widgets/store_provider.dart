import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Provider for a store.
class StoreProvider<T> extends StatelessWidget {
  /// Function to call when created.
  final T Function(BuildContext) create;

  /// Builder that takes in the store.
  final Widget Function(BuildContext context, T store) builder;

  const StoreProvider({required this.create, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: create,
      child: Builder(
        builder: (context) => builder(context, context.read<T>()),
      ),
    );
  }
}
