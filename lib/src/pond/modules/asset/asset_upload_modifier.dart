import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;

import 'asset.dart';

class AssetUploadModifier {
  final FutureOr<Asset> Function(Asset asset)? uploadModifier;
  final FutureOr<String?> Function(Asset asset)? exceptionGetter;

  const AssetUploadModifier({this.uploadModifier, this.exceptionGetter});

  Future<Asset> getModifiedAsset(Asset asset) async {
    return await uploadModifier?.call(asset) ?? asset;
  }

  Future<String?> getException(Asset asset) async {
    return await exceptionGetter?.call(asset) ?? null;
  }

  static AssetUploadModifier compressImages({int maxDimension = 512}) {
    return AssetUploadModifier(
      uploadModifier: (asset) async {
        if (!asset.isImage || asset.mimeType == 'image/gif') {
          return asset;
        }

        final compressedBytes = await compute(
          (Uint8List data) => _compressImage(data, maxDimension: maxDimension),
          asset.value,
        );
        if (compressedBytes == null) {
          return asset;
        }

        print(
            'Compressing image from ${asset.value.length / 1000 / 1000}MB to ${compressedBytes.length / 1000 / 1000}MB');

        return asset.copyWith(value: Uint8List.fromList(compressedBytes));
      },
    );
  }

  static AssetUploadModifier blockLargeUploads({int maxSizeMegabytes = 25}) {
    return AssetUploadModifier(
      exceptionGetter: (asset) async {
        if (asset.value.length > maxSizeMegabytes * 1000 * 1000) {
          return 'This asset is too large! Make sure it is less than ${maxSizeMegabytes}MB';
        }

        return null;
      },
    );
  }
}

Future<Uint8List?> _compressImage(Uint8List bytes, {required int maxDimension}) async {
  var img = image.decodeImage(bytes);
  if (img == null) {
    return null;
  }

  final targetDimensions = _getTargetDimensions(
    originalWidth: img.width,
    originalHeight: img.height,
    maxDimension: maxDimension,
  );

  img = image.copyResize(img, width: targetDimensions.width, height: targetDimensions.height);

  return Uint8List.fromList(image.encodeJpg(img, quality: 80));
}

Dimensions _getTargetDimensions({
  required int originalWidth,
  required int originalHeight,
  required int maxDimension,
}) {
  int targetWidth, targetHeight;

  if (originalWidth > maxDimension || originalHeight > maxDimension) {
    if (originalWidth > originalHeight) {
      targetWidth = maxDimension;
      targetHeight = (originalHeight / (originalWidth / maxDimension)).round();
    } else {
      targetHeight = maxDimension;
      targetWidth = (originalWidth / (originalHeight / maxDimension)).round();
    }
  } else {
    targetWidth = originalWidth;
    targetHeight = originalHeight;
  }

  return Dimensions(targetWidth, targetHeight);
}

class Dimensions {
  final int width;
  final int height;

  Dimensions(this.width, this.height);
}
