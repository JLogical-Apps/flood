import 'port.dart';

abstract class PortComponent {
  late Port port;

  void onInitialize() {}

  void initialize(Port port) {
    this.port = port;
    onInitialize();
  }
}
