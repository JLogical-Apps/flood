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
        'application/octet-stream';
    final assetExtension = extension(path).nullIfBlank ??
        (extensionFromMime(mimeType) == mimeType
            ? (throw Exception('Could not determine extension for [$path]'))
            : extensionFromMime(mimeType));

    final assetId = '${Uuid().v4()}$assetExtension';
    return Asset(
      id: assetId,
      value: value,
      metadata: AssetMetadata(
        size: value.length,
        mimeType: mimeType,
        createdTime: DateTime.now(),
        updatedTime: DateTime.now(),
      ),
    );
  }

  Asset copyWith({String? id, Uint8List? value, AssetMetadata? metadata}) {
    return Asset(
      id: id ?? this.id,
      value: value ?? this.value,
      metadata: metadata ?? this.metadata,
    );
  }

  Asset withNewId() {
    final ext = extension(id);
    return copyWith(id: '${Uuid().v4()}$ext');
  }

  Asset withMetadata(AssetMetadata metadata) {
    return copyWith(metadata: metadata);
  }

  @override
  List<Object?> get props => [id, value, metadata];
}
