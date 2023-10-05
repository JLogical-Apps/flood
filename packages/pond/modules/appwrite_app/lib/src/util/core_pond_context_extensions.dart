import 'package:appwrite/appwrite.dart';
import 'package:appwrite_app/src/appwrite_core_component.dart';
import 'package:pond/pond.dart';
import 'package:utils/utils.dart';

extension AppwriteCorePondContextExtensions on CorePondContext {
  AppwriteCoreComponent get appwriteCoreComponent => locate<AppwriteCoreComponent>();

  Client get client => appwriteCoreComponent.client;
}
