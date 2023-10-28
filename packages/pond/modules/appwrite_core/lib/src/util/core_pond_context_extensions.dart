import 'package:appwrite_core/appwrite_implementation.dart';
import 'package:appwrite_core/src/appwrite_core_component.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

extension AppwriteCorePondContextExtensions on CorePondContext {
  AppwriteCoreComponent get appwriteCoreComponent => locate<AppwriteCoreComponent>();

  Client get client => appwriteCoreComponent.client;
}
