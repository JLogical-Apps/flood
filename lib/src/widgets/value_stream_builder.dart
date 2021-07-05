import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// A widget that builds based on the value of a stream.
class ValueStreamBuilder<T> extends StatelessWidget {
  /// The stream to build based off of.
  final ValueStream<T> stream;

  /// Builder for when the stream is updated.
  final Widget Function(T value) builder;

  const ValueStreamBuilder({Key? key, required this.stream, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snap) {
        if (!snap.hasData) {
          return Container();
        }

        return builder(snap.data!);
      },
    );
  }
}
