import 'package:equatable/equatable.dart';

abstract class Timestamp extends Equatable {
  DateTime get time;

  static Timestamp now() => NowTimestamp();

  static Timestamp of(DateTime dateTime) => DateTimestamp(time: dateTime);
}

class NowTimestamp extends Timestamp {
  @override
  DateTime get time => DateTime.now();

  @override
  List<Object?> get props => [];
}

class DateTimestamp extends Timestamp {
  @override
  final DateTime time;

  DateTimestamp({required this.time});

  @override
  List<Object?> get props => [time];
}
