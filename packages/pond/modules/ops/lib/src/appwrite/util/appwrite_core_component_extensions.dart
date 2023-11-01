import 'package:appwrite_core/appwrite_core.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:pond_core/pond_core.dart';

extension DartAppwriteCoreComponentExtensions on CorePondContext {
  Client get client => Client()
      .setProject(appwriteCoreComponent.config.projectId)
      .setEndpoint(appwriteCoreComponent.config.endpoint)
      .setSelfSigned(status: appwriteCoreComponent.config.selfSigned ?? false)
      .setKey(appwriteCoreComponent.config.apiKey);
}
