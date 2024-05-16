import 'package:asset/src/asset_builders/asset_builder.dart';
import 'package:asset_core/asset_core.dart';
import 'package:environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:model/model.dart';
import 'package:persistence/persistence.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class VideoAssetBuilder extends AssetBuilder {
  @override
  Widget build(BuildContext context, Asset asset, double? width, double? height, BoxFit? fit) {
    if (context.corePondContext.environmentCoreComponent.platform == Platform.web) {
      return StyledText.body.centered('Memory Video Players are disabled for web.');
    }

    final videoPlayerControllerModel = useMemoized(
      () => Model(loader: () async {
        final videoFileDataSource = DataSource.static.rawFile(
            context.corePondContext.environmentCoreComponent.fileSystem.tempIoDirectory! / 'videos' - asset.id);
        await videoFileDataSource.set(asset.value);
        return VideoPlayerController.file(videoFileDataSource.file);
      }),
      [asset.value.hashCode],
    );
    return ModelBuilder(
      model: videoPlayerControllerModel,
      builder: (VideoPlayerController videoPlayerController) {
        return StyledVideo(
          videoPlayerController: videoPlayerController,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }

  @override
  bool shouldModify(Asset input) {
    return input.metadata.mimeType?.startsWith('video/') ?? false;
  }
}
