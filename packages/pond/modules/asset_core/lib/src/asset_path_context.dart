import 'package:asset_core/src/asset_core_component.dart';
import 'package:drop_core/drop_core.dart';
import 'package:equatable/equatable.dart';
import 'package:pond_core/pond_core.dart';

class AssetPathContext extends Equatable {
  final AssetCoreComponent context;
  final Map<String, dynamic> values;
  final Map<String, dynamic> metadata;

  AssetPathContext({required this.context, this.values = const {}, this.metadata = const {}});

  @override
  List<Object?> get props => [values];
}

extension AssetPathContextExtensions on AssetPathContext {
  CorePondContext get corePondContext => context.context;

  DropCoreComponent get dropCoreComponent => context.context.dropCoreComponent;
}
