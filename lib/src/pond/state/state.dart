import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/utils/collection_extensions.dart';

class State extends Equatable {
  final String? id;
  final String? type;
  final Map<String, dynamic> values;

  State({this.id, this.type, required this.values});

  late final Map<String, dynamic> fullValues = {
    ...values,
    Query.id: id,
    Query.type: type,
  };

  static State? extractFromOrNull(dynamic value) {
    if (value is State) {
      return value;
    } else if (value is Map) {
      value = value.copy();
      final type = value.remove(Query.type)?.toString();
      final id = value.remove(Query.id)?.toString();
      return State(id: id, type: type, values: value.map((key, value) => MapEntry(key.toString(), value)));
    } else if (value is Stateful) {
      return value.state;
    }

    return null;
  }

  operator [](String fieldName) {
    return fullValues[fieldName];
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
