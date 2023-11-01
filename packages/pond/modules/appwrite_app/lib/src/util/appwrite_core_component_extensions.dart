import 'package:appwrite/appwrite.dart';
import 'package:appwrite_core/appwrite_core.dart';
import 'package:pond_core/pond_core.dart';

extension FlutterAppwriteCoreComponentExtensions on CorePondContext {
  Client get client => Client()
      .setProject(appwriteCoreComponent.config.projectId)
      .setEndpoint(appwriteCoreComponent.config.endpoint)
      .setSelfSigned(status: appwriteCoreComponent.config.selfSigned ?? false);
}
