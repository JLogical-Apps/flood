# Drop (Core)

This package exports `DropCoreComponent`, which allows you to create Entities, ValueObjects, Repositories, and run Queries.

## Overview

Most applications need their data stored in a repository. This data needs to be queried and modifiable. Within the context of `Drop`, `ValueObject`s store the data for one record. For example, `User`. `Entity`s store a `ValueObject` but also provide an `id`. For example, `UserEntity`. The `UserEntity` is then passed to a `UserRepository` to be saved or deleted. You can create `Query`s to run against `UserRepository` to fetch `UserEntity`s.

## ValueObjects

The purpose of a `ValueObject` is to define what the format of data for a record is. They do this by defining `behaviors`. For example:

```dart
class User extends ValueObject {
  late final nameProperty = field<String>(name: 'name').withFallback(() => 'John');
  late final emailProperty = field<String>(name: 'email').isNotBlank();
  late final notesProperty = field<String>(name: 'notes');
  late final itemsProperty = field<String>(name: 'items').list();

  @override
  late final List<ValueObjectBehavior> behaviors = [
    nameProperty,
    emailProperty,
    notesProperty,
    itemsProperty,
    creationTime(),
  ];
}
```

A `User` is defined by:

- `name`: If it's null in the repository, a fallback of `John` will be used.
- `email`: Must be not non-null and non-blank. Otherwise an error will occur when saving or retrieving this ValueObject.
- `notes`: An optional String.
- `items`: A list of Strings.
- `creationTime`: A prebuilt behavior that stores the time the `User` was created.

You can see that there are `field` behaviors and a `creationTime` behavior. Some behaviors you should know of are:

- `field<T>()`: A simple behavior that stores a value of type `T`.
- `reference<EntityType>()`: A field that stores a String but indicates it references an `EntityType`.
- `computed()`: Computes a value to store in the repository.

You can see that the behaviors are modified. Some modifiers you should know of are:

- `.required()`: Cannot be null. Sets the field to be non-nullable.
- `.isNotBlank()`: Cannot be null or blank. Sets the field to be non-nullable.
- `.withFallback()`: If null, uses a fallback. Sets the field to be non-nullable.
- `.withValidator()`: Adds a `Validator` to the field.
- `.isEmail()`: Indicates the field must be an email.
- `.time()`: Parses Strings from the repository into `Timestamp` to be used in the code.
- `.embedded()`: Required for `field<ValueObjectType>()` so that it can internal data to the `ValueObjectType`.
- `.list()`: A list of the field type. For example, `field<String>().list()` is a `List<String>`
- `.mapTo<ValueType>()`: A map where the field type is the key and `ValueType` is the value type. For example, `field<String>().mapTo<int>()` is a `Map<String, int>`

## Entities

While `ValueObject`s are immutable, `Entity`s are mutable, so they are designed for their `value` to change.

Their purpose is to store `ValueObject`s over time and define lifecycle methods. For example, you can define `onBeforeSave`, `onAfterDelete`, etc. to customize the behavior of `Entity`s depending on where they are in the lifecycle.

## Repositories

The purpose of a `Repository` is to define where to store `Entity`s. For examle:

```dart

class UserRepository with IsRepositoryWrapper {
  @override
  late Repository repository = Repository.forType<UserEntity, User>(
    UserEntity.new,
    User.new,
    entityTypeName: 'UserEntity',
    valueObjectTypeName: 'User',
  ).adapting('user').withSecurity(RepositorySecurity(
        read: Permission.authenticated,
        create: Permission.authenticated,
        update: Permission.authenticated,
        delete: Permission.none,
      ));
}
```

`UserRepository` is a `Repository` for `UserEntity`s, adapting based on the [environment](../environment_core/README.md), with some security rules.

Some modifiers you should know of are:

- `.file(path)`: A `Repository` to the device file system at `path`.
- `.cloud(path)`: A `Repository` to a cloud provider at `path`.
- `.adapting(path)`: A `Repository` that adapts on the implementation based on the [environment](../environment_core/README.md).
- `.withSecurity(security)`: Ensures the user has permission to do actions. Otherwise throws an exception.
- `.withMemoryCache()`: Stores a cache of loaded `Entities` to use before executing a `Query` on the source `Repository`.

## Making Updates

If you have an `Entity` and want to update its `value` or delete it, use these commands:

- `context.updateEntity(entity, modifier)`: If `modifier` is not null, runs that first on the `entity`'s `value`. Then it will save `entity`. For example, `context.updateEntity(myUserEntity, (User user) => user..nameProperty.set('John'))` will update the `value` of `myUserEntity` to change the name to "John" before saving it.
- `context.delete(entity)`: Deletes the `entity`.

## Queries

To retrieve data from a `Repository`, you need to use `Query`s. Here are some examples:

```dart
Query.from<UserEntity>().where(User.emailField).isEqualTo('test@test.com').firstOrNull() // First UserEntity with an email of 'test@test.com' or null if not found.
Query.from<UserEntity>().orderByDescending(User.nameField).limit(20).all() // First 20 UserEntitys sorted based on their name descending.
Query.from<UserEntity>().where(User.nameField).isNotNull().paginate() // Pagination of 20 UserEntitys at a time that have a name.
Query.from<UserEntity>().all().map((userEntities) => userEnitites.map((userEntity) => userEntity.value.nameProperty.value).toList()) // Names of all UserEntitys.
```

These just create `Query`s without executing them. To execute a `query`, run `query.get(context)`;

## Implementations

Some `Repositories` depend on Flutter to function, so you may need to pass `implementations` to `DropCoreComponent` so that `DropCoreComponent` knows how to create a `Repository.cloud()`.
