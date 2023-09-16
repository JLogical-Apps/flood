import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

class NavigationAppComponent with IsAppPondComponent {
  String get location => PondApp.navigatorKey.currentState!.currentPath!;

  Uri get uri => Uri.parse(location);

  Future<T?> push<T>(Route route) async {
    return pushLocation(route.uri.toString());
  }

  Future<T?> pushUri<T>(Uri uri) async {
    return pushLocation<T>(uri.toString());
  }

  Future<T?> pushLocation<T>(String location) async {
    return await PondApp.navigatorKey.currentState!.pushNamed(location);
  }

  Future<void> pushReplacement(Route route) async {
    await pushReplacementUri(route.uri);
  }

  Future<void> pushReplacementUri(Uri uri) async {
    await pushReplacementLocation(uri.toString());
  }

  Future<void> pushReplacementLocation(String location) async {
    await PondApp.navigatorKey.currentState!.pushReplacementNamed(location);
  }

  Future<void> warpTo(Route route) async {
    await warpToUri(route.uri);
  }

  Future<void> warpToUri(Uri uri) async {
    await warpToLocation(uri.toString());
  }

  Future<void> warpToLocation(String location) async {
    await PondApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(location, (route) => false);
  }

  void pop<T>([T? result]) {
    return PondApp.navigatorKey.currentState!.pop(result);
  }
}
