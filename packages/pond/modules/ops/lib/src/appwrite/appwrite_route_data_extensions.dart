import 'package:path_core/path_core.dart';

extension AppwriteRouteDataExtensions on RouteData {
  String get trigger => hiddenState['x-appwrite-trigger'];

  String? get userId => hiddenState['x-appwrite-user-id'];
}
