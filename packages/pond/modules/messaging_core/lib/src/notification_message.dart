import 'package:equatable/equatable.dart';

class NotificationMessage with EquatableMixin {
  final String title;
  final String? body;
  final Map<String, dynamic> data;

  const NotificationMessage({required this.title, this.body, required this.data});

  @override
  List<Object?> get props => [title, body, data];
}
