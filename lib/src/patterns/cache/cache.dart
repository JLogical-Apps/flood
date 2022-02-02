import 'package:jlogical_utils/src/utils/collection_extensions.dart';
import 'package:jlogical_utils/src/utils/stream_extensions.dart';
import 'package:rxdart/rxdart.dart';

class Cache<K, V> {
  final BehaviorSubject<Map<K, V>> _valueByKeyX;

  Cache() : _valueByKeyX = BehaviorSubject.seeded({});

  late final ValueStream<Map<K, V>> valueByKeyX = _valueByKeyX;

  Map<K, V> get valueByKey => _valueByKeyX.value;

  set valueByKey(Map<K, V> value) {
    _valueByKeyX.value = value;
  }

  bool exists(K key) {
    return valueByKey.containsKey(key);
  }

  void save(K key, V value) {
    if (valueByKey[key] == value) {
      return;
    }

    valueByKey = valueByKey.copy()..set(key, value);
  }

  V? get(K key) {
    return valueByKey[key];
  }

  ValueStream<V?> getX(K key) {
    return _valueByKeyX.mapWithValue((valueByKey) => valueByKey[key]);
  }

  V putIfAbsent(K key, V ifAbsent()) {
    if (exists(key)) {
      return valueByKey[key]!;
    }

    final value = ifAbsent();
    save(key, value);

    return value;
  }

  void remove(K key) {
    if (!valueByKey.containsKey(key)) {
      return;
    }

    valueByKey = valueByKey.copy()..remove(key);
  }
}
