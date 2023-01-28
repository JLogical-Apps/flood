import 'package:rxdart/rxdart.dart';

class DebugDialogContext {
  final BehaviorSubject<Map<String, dynamic>> _dataSubject;

  ValueStream<Map<String, dynamic>> get dataX => _dataSubject;

  DebugDialogContext() : _dataSubject = BehaviorSubject.seeded({});

  Map<String, dynamic> get data => dataX.value;

  set data(Map<String, dynamic> value) {
    _dataSubject.value = value;
  }
}
