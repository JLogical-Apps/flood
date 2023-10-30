import 'package:appwrite_core/appwrite_implementation.dart';
import 'package:appwrite_core/src/appwrite_config.dart';
import 'package:pond_core/pond_core.dart';

class AppwriteCoreComponent with IsCorePondComponent {
  final AppwriteConfig config;

  late Client client;

  late final Account account = Account(client);
  late final Databases databases = Databases(client);
  late final Functions functions = Functions(client);

  AppwriteCoreComponent({required this.config});

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(onLoad: (context, _) async {
          client = Client()
              .setEndpoint(config.endpoint)
              .setProject(config.projectId)
              .setSelfSigned(status: config.selfSigned ?? false);
          if (config.apiKey != null) {
            client.setKey(config.apiKey);
          }
        }),
      ];
}
