import 'package:equatable/equatable.dart';

class DataMessage with EquatableMixin {
  final Map<String, dynamic> data;

  const DataMessage({required this.data});

  @override
  List<Object?> get props => [data];
}
