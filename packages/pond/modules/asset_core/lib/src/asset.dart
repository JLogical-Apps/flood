import 'dart:typed_data';

import 'package:asset_core/asset_core.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:utils_core/utils_core.dart';
import 'package:uuid/uuid.dart';

class Asset extends Equatable {
  final String id;
  final Uint8List value;
  final AssetMetadata metadata;

  const Asset({
    required this.id,
    required this.value,
    required this.metadata,
  });

  factory Asset.upload({required String path, required Uint8List value, String? mimeType}) {
    mimeType ??= lookupMimeType(path, headerBytes: value.take(defaultMagicNumbersMaxLength).toList()) ??
        (throw Exception('Could not determine mime type for [$path]'));
    final assetExtension = extension(path).nullIfBlank ??
        (extensionFromMime(mimeType) == mimeType
            ? (throw Exception('Could not determine extension for [$path]'))
            : extensionFromMime(mimeType));

    final assetId = '${Uuid().v4()}$assetExtension';
    return Asset(
      id: assetId,
      value: value,
      metadata: AssetMetadata(size: value.length, mimeType: mimeType),
    );
  }

  @override
  List<Object?> get props => [id, value, metadata];
}
