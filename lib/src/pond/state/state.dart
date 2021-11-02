import 'package:equatable/equatable.dart';
import 'package:jlogical_utils/src/pond/export.dart';

class State extends Equatable {
  final String? id;
  final Map<String, dynamic> values;

  const State({this.id, required this.values});

  static State? extractFrom(dynamic value) {
    if (value is State) {
      return value;
    } else if (value is Map<String, dynamic>) {
      return State(values: value);
    } else if (value is Map) {
      return State(values: value.map((key, value) => MapEntry(key.toString(), value)));
    } else if (value is Stateful) {
      return value.state;
    }

    return null;
  }

  @override
  List<Object?> get props => [id, values];
}
