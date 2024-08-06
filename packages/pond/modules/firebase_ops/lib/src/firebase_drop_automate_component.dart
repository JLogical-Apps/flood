import 'package:drop_core/drop_core.dart';
import 'package:firebase_ops/src/namespace.dart';
import 'package:persistence_core/persistence_core.dart';
import 'package:pond_cli/pond_cli.dart';
import 'package:runtime_type/type.dart';
import 'package:utils_core/utils_core.dart';

class FirebaseDropAutomateComponent with IsAutomatePondComponent {
  @override
  List<AutomateCommand> get commands => [DropFunctionsCommand()];
}

class DropFunctionsCommand extends AutomateCommand<DropFunctionsCommand> {
  @override
  String get name => 'drop_functions';

  @override
  String get description => 'Generates static fields for Firebase Functions based on Drop repositories.';

  @override
  DropFunctionsCommand copy() {
    return DropFunctionsCommand();
  }

  @override
  Future<void> onRun(AutomateCommandContext context) async {
    final functionSourceDirectory = context.coreDirectory / 'firebase' / 'functions' / 'src';
    if (!await functionSourceDirectory.exists()) {
      throw Exception('Firebase Functions must be initialized!');
    }

    final dropContext = context.automateContext.corePondContext.dropCoreComponent;
    final namespaces = [
      ...getRepositoryNamespaces(dropContext),
      ...getValueObjectNamespaces(dropContext),
    ];

    await DataSource.static
        .file(functionSourceDirectory - 'drop.ts')
        .set(namespaces.map((namespace) => namespace.toTypescriptString()).join('\n'));

    context.print('Success! Generated Drop Types');
  }

  @override
  AutomatePathDefinition get pathDefinition => AutomatePathDefinition.empty;

  List<Namespace> getRepositoryNamespaces(DropCoreContext context) {
    return context.repositories
        .map((repository) {
          final modifier = RepositoryMetaModifier.getModifierOrNull(repository);
          if (modifier == null) {
            return null;
          }
          final path = modifier.getPath(repository)!;
          return Namespace(
            name: '${path.pascalCase}Repository',
            fieldNameToField: {
              'path': path,
            },
          );
        })
        .whereNonNull()
        .toList();
  }

  List<Namespace> getValueObjectNamespaces(DropCoreContext context) {
    final valueObjectRuntimeType = context.getRuntimeType<ValueObject>();
    return context.runtimeTypes
        .where((runtimeType) => runtimeType.isA(valueObjectRuntimeType) && runtimeType.isConcrete)
        .map((runtimeType) {
          final valueObject = runtimeType.createInstance() as ValueObject;
          return Namespace(
            name: runtimeType.name.pascalCase,
            fieldNameToField: valueObject.behaviors
                .whereType<ValueObjectProperty>()
                .mapToMap((property) => MapEntry('${property.name}Field', property.name)),
          );
        })
        .whereNonNull()
        .toList();
  }
}
