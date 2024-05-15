import 'package:equatable/equatable.dart';

class AssetMetadata extends Equatable {
  final String? mimeType;
  final int size;

  AssetMetadata({required this.mimeType, required this.size});

  @override
  List<Object?> get props => [mimeType, size];
}
