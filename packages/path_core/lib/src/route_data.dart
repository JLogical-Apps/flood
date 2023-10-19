import 'package:utils_core/utils_core.dart';

class RouteData {
  final Uri uri;
  final Map<String, dynamic> hiddenState;

  RouteData({required this.uri, this.hiddenState = const {}});

  RouteData.uri(this.uri, {this.hiddenState = const {}});

  RouteData.path(String path, {this.hiddenState = const {}}) : uri = Uri.parse(path);

  @override
  String toString() {
    return [uri.toString(), hiddenState.isEmpty ? null : hiddenState].whereNonNull().join('');
  }
}
