import 'package:rxdart/rxdart.dart';
import 'package:utils_core/src/extensions/export.dart';

class MapValueStream<T, R> extends ValueConnectableStream<R> implements ValueStream<R> {
  final ValueStream<T> source;
  final R Function(T value) mapper;

  MapValueStream({required this.source, required this.mapper})
      : super.seeded(source.map(mapper), mapper(source.value), sync: false);

  @override
  R get value => mapper(source.value);

  @override
  R? get valueOrNull => source.valueOrNull?.mapIfNonNull((value) => mapper(value));
}
