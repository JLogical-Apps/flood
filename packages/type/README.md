# Type

This package exports utilities to handle generating instances of Runtime Types.

## Reflection

In many programming languages, you can simply provide a `Type` and have the programming language generate a new instance of that Type. For example, in Java, you can do this using reflection. The downside of this functionality is that the programs generated with that language are larger since they need to store all the information about every single type and how to instantiate it.

To combat this, Dart does not allow instantiating `Type`s in runtime. So, the `Type` package helps manage the runtime types you _need_ instantiated throughout the lifetime of your application.

## Context

The first thing you need to do is to create a `TypeContext`. This stores information about every Type you want instantiated, what Types it extends, and how to instantiate the type (if it's not abstract).

Here is an example of setting up a `TypeContext`:

```dart
    final context = TypeContext();
    context.registerAbstract<MyAbstractClass>(name: 'MyAbstractClass');
    context.register<MyConcreteClass>(MyConcreteClass.new, name: 'MyConcreteClass', parents: [MyAbstractClass]);
```

Notice that you need to specify a `name` for each of the Types. This is because when Dart is compiled to web, it is minified, so all the names of the Types are jumbled up. This can cause issues if you want to create an instance of a Type based on its name (for example: `context.getByName('MyConcreteClass').createInstance();`)

In addition, you need to specify how to generate concrete classes. In this case, a new instance of `MyConcreteClass` is just `MyConcreteClass.new` (which is Dart syntax sugar for `() => MyConcreteClass()`).

## RuntimeTypes

`RuntimeType` is a class that the `Type` package exports. It contains information about a single `Type`, such as how to instantiate it, what its parents or children are, and whether it is abstract,

Once you register a Type using a `TypeContext`, you can grab a `RuntimeType` of it with one of the following:

```dart
myConcreteRuntimeType = context.getRuntimeType<MyConcreteClass>();
myConcreteRuntimeType = context.getRuntimeTypeRuntime(MyConcreteClass);
myConcreteRuntimeType = context.getByName('MyConcreteClass');
```

Let's see what info you can find from a `RuntimeType`:

```dart
myConcreteRuntimeType.getAncestors() // [RuntimeType<MyAbstractClass>]
myConcreteRuntimeType.getChildren() // []
myConcreteRuntimeType.getDescendants() // []
myConcreteRuntimeType.isA(myAbstractRuntimeType) // true
```

## Generating Instances

You can generate an instance of a `RuntimeType` in two ways:

1. `myConcreteRuntimeType.createInstance()`: If you have a reference to the `RuntimeType`, you can create an instance like this.
2. `typeContext.construct(MyConcreteClass)`: If you have a reference to the `TypeContext`, you can just construct an instance like this.

Note that creating an instance of an abstract RuntimeType will throw an error.
