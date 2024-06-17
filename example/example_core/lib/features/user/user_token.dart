import 'package:example_core/features/todo/todo_entity.dart';
import 'package:flood_core/flood_core.dart';

class UserToken extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const assetField = 'asset';
  late final assetProperty = field<String>(name: assetField)
      .asset(assetProvider: (context) => context.locate<UserTokenAssetProvider>())
      .withDisplayName('Asset');

  @override
  List<ValueObjectBehavior> get behaviors => [nameProperty, assetProperty];
}

class UserTokenAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  UserTokenAssetProvider(this.context);

  @override
  late final AssetProvider assetProvider = AssetProvider.static
      .adapting(context, (context) => 'todos/${context.entityId}/tokens')
      .fromRepository<TodoEntity>(context);
}
