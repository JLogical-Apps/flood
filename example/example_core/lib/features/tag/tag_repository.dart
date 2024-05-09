import 'package:example_core/features/tag/tag.dart';
import 'package:example_core/features/tag/tag_entity.dart';
import 'package:flood_core/flood_core.dart';

class TagRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<TagEntity, Tag>(
    TagEntity.new,
    Tag.new,
    entityTypeName: 'TagEntity',
    valueObjectTypeName: 'Tag',
  ).adapting('tags').withSecurity(RepositorySecurity.all(Permission.admin |
      Permission.equals(PermissionField.propertyName(Tag.ownerField), PermissionField.loggedInUserId)));
}
