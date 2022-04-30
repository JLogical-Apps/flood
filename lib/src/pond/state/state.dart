import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/state/stateful.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';

import '../query/query.dart';

class State extends Equatable {
  final String? id;
  final String? type;
  final Map<String, dynamic> values;

  State({this.id, this.type, required this.values});

  Map<String, dynamic> get fullValues => {
        ...values,
        Query.id: id,
        Query.type: type,
      };

  static State? extractFromOrNull(dynamic value, {String? typeFallback, String? idOverride}) {
    if (value is State) {
      return value;
    } else if (value is Map) {
      value = value.copy();
      final type = value.remove(Query.type)?.toString();
      final id = value.remove(Query.id)?.toString();
      return State(
        id: idOverride ?? id,
        type: type ?? typeFallback,
        values: value.map((key, value) => MapEntry(key.toString(), value)),
      );
    } else if (value is Stateful) {
      return value.state;
    }

    return null;
  }

  static State extractFrom(dynamic value, {String? typeFallback, String? idOverride}) {
    return extractFromOrNull(value, typeFallback: typeFallback, idOverride: idOverride) ??
        (throw Exception('Cannot extract state from $value'));
  }

  operator [](String fieldName) {
    return fullValues[fieldName];
  }

  operator []=(String fieldName, dynamic value) {
    values[fieldName] = value;
  }

  State copyWith({String? id, Map<String, dynamic>? values, String? type}) {
    return State(
      id: id ?? this.id,
      values: values ?? this.values,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, type, values];
}
