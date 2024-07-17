import 'package:asset_core/src/asset_core_component.dart';
import 'package:drop_core/drop_core.dart';
import 'package:equatable/equatable.dart';
import 'package:pond_core/pond_core.dart';
import 'package:utils_core/utils_core.dart';

class AssetPathContext extends Equatable {
  final AssetCoreComponent context;
  final Map<String, dynamic> values;

  AssetPathContext({required this.context, this.values = const {}});

  @override
  List<Object?> get props => [values.where((key, value) => !key.startsWith('_'))];
}

extension AssetPathContextExtensions on AssetPathContext {
  CorePondContext get corePondContext => context.context;

  DropCoreComponent get dropCoreComponent => context.context.dropCoreComponent;
}
