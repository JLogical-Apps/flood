import 'package:example_core/features/tag/tag_entity.dart';
import 'package:example_core/features/todo/todo_entity.dart';
import 'package:example_core/features/user/user_entity.dart';
import 'package:example_core/features/user/user_token.dart';
import 'package:example_core/utils/asset_provider_utils.dart';
import 'package:flood_core/flood_core.dart';

class Todo extends ValueObject {
  static const nameField = 'name';
  late final nameProperty = field<String>(name: nameField).withDisplayName('Name').isNotBlank();

  static const descriptionField = 'description';
  late final descriptionProperty =
      field<String>(name: descriptionField).withDisplayName('Description').multiline().nullIfBlank();

  static const completedField = 'completed';
  late final completedProperty = field<bool>(name: completedField).hidden().withFallback(() => false);

  static const tagsField = 'tags';
  late final tagsProperty = reference<TagEntity>(
    name: tagsField,
  ).list().withDisplayName('Tags');

  static const userField = 'user';
  late final userProperty = reference<UserEntity>(name: userField).hidden().required();

  static const assetsField = 'assets';
  late final assetsProperty = field<String>(name: assetsField)
      .asset(assetProvider: (context) => context.locate<TodoAssetProvider>())
      .list()
      .withDisplayName('Assets');

  static const tokensField = 'tokens';
  late final tokensProperty = field<UserToken>(name: tokensField).list().embedded().withDisplayName('Tokens');

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    descriptionProperty,
    completedProperty,
    tagsProperty,
    userProperty,
    assetsProperty,
    tokensProperty,
    creationTime(),
  ];
}

class TodoAssetProvider with IsAssetProviderWrapper {
  final AssetCoreComponent context;

  TodoAssetProvider(this.context);

  @override
  late final AssetProvider assetProvider = AssetProvider.static
      .syncingOrAdapting(context, (context) => 'todos/${context.entityId}/assets')
      .fromRepository<TodoEntity>(context);
}
