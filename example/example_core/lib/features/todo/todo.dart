import 'package:example_core/features/tag/tag_entity.dart';
import 'package:example_core/features/user/user_entity.dart';
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

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    descriptionProperty,
    completedProperty,
    tagsProperty,
    userProperty,
    assetsProperty,
    creationTime(),
  ];
}

class TodoAssetProvider with IsAssetProviderWrapper {
  @override
  late final AssetProvider assetProvider = AssetProvider.static.memory;
}
