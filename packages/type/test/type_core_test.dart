import 'package:test/test.dart';
import 'package:runtime_type/type.dart';

void main() {
  test('registering and creating an instance of a runtime type.', () {
    final context = TypeContext();
    context.register<MyConcreteClass>(MyConcreteClass.new, name: 'MyConcreteClass');

    final myConcreteClassType = MyConcreteClass;
    expect(context.construct(myConcreteClassType), isA<MyConcreteClass>());
  });

  test('cannot construct abstract runtime type.', () {
    final context = TypeContext();
    context.registerAbstract<MyAbstractClass>(name: 'MyConcreteClass');

    final myAbstractClassType = MyAbstractClass;
    expect(context.constructOrNull(myAbstractClassType), null);
  });

  test('concrete class is an instance of its parent.', () {
    final context = TypeContext();
    context.registerAbstract<MyAbstractClass>(name: 'MyAbstractClass');
    context.register<MyConcreteClass>(MyConcreteClass.new, name: 'MyConcreteClass', parents: [MyAbstractClass]);

    final abstractRuntimeType = context.getRuntimeType<MyAbstractClass>();
    final concreteRuntimeType = context.getRuntimeType<MyConcreteClass>();

    expect(abstractRuntimeType.getAncestors(), isEmpty);
    expect(concreteRuntimeType.getAncestors(), [abstractRuntimeType]);

    expect(abstractRuntimeType.getChildren(), [concreteRuntimeType]);
    expect(concreteRuntimeType.getChildren(), isEmpty);

    expect(abstractRuntimeType.getDescendants(), [concreteRuntimeType]);
    expect(concreteRuntimeType.getDescendants(), isEmpty);

    expect(abstractRuntimeType.isA(abstractRuntimeType), true);
    expect(concreteRuntimeType.isA(abstractRuntimeType), true);

    expect(abstractRuntimeType.isA(concreteRuntimeType), false);
    expect(concreteRuntimeType.isA(concreteRuntimeType), true);
  });

  test('grandparent classes.', () {
    final context = TypeContext();
    context.registerAbstract<MyAbstractClass>(name: 'MyAbstractClass');
    context.register<MyConcreteClass>(MyConcreteClass.new, name: 'MyConcreteClass', parents: [MyAbstractClass]);
    context
        .register<MySubConcreteClass>(MySubConcreteClass.new, name: 'MySubConcreteClass', parents: [MyConcreteClass]);

    final abstractRuntimeType = context.getRuntimeType<MyAbstractClass>();
    final concreteRuntimeType = context.getRuntimeType<MyConcreteClass>();
    final subConcreteRuntimeType = context.getRuntimeType<MySubConcreteClass>();

    expect(abstractRuntimeType.getAncestors(), isEmpty);
    expect(concreteRuntimeType.getAncestors(), [abstractRuntimeType]);
    expect(subConcreteRuntimeType.getAncestors(), containsAll([abstractRuntimeType, concreteRuntimeType]));

    expect(abstractRuntimeType.getChildren(), [concreteRuntimeType]);
    expect(concreteRuntimeType.getChildren(), [subConcreteRuntimeType]);
    expect(subConcreteRuntimeType.getChildren(), isEmpty);

    expect(abstractRuntimeType.getDescendants(), [concreteRuntimeType, subConcreteRuntimeType]);
    expect(concreteRuntimeType.getDescendants(), [subConcreteRuntimeType]);
    expect(subConcreteRuntimeType.getDescendants(), isEmpty);

    expect(abstractRuntimeType.isA(abstractRuntimeType), true);
    expect(concreteRuntimeType.isA(abstractRuntimeType), true);
    expect(subConcreteRuntimeType.isA(abstractRuntimeType), true);

    expect(abstractRuntimeType.isA(concreteRuntimeType), false);
    expect(concreteRuntimeType.isA(concreteRuntimeType), true);
    expect(subConcreteRuntimeType.isA(concreteRuntimeType), true);

    expect(abstractRuntimeType.isA(subConcreteRuntimeType), false);
    expect(concreteRuntimeType.isA(subConcreteRuntimeType), false);
    expect(subConcreteRuntimeType.isA(subConcreteRuntimeType), true);
  });
}

abstract class MyAbstractClass {}

class MyConcreteClass extends MyAbstractClass {}

class MySubConcreteClass extends MyConcreteClass {}
