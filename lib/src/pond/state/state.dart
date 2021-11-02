import 'package:equatable/equatable.dart';

class State extends Equatable {
  final String? id;
  final Map<String, dynamic> values;

  const State({this.id, required this.values});

  @override
  List<Object?> get props => [id, values];
}
