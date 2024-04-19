import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/style/widgets/port/with_required_label_getter.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/export_core.dart';
import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../content/styled_content.dart';
import '../input/styled_button.dart';
import '../misc/styled_icon.dart';
import '../misc/styled_loading_asset.dart';
import '../text/styled_body_text.dart';
import '../text/styled_content_header_text.dart';
import '../text/styled_error_text.dart';
import '../text/styled_text_overrides.dart';

class StyledUploadPortField extends PortFieldWidget<AssetPortField, String?, String?>
    with WithPortExceptionTextGetter, WithRequiredLabelGetter {
  static const double _imageWidth = 200;
  static const double _imageHeight = 200;

  final UploadType uploadType;

  final List<AssetAction> assetActionBuilders;

  @override
  final String? labelText;

  @override
  final Widget? label;

  @override
  final bool? showRequiredIndicator;

  final Widget? leading;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledUploadPortField({
    super.key,
    required super.name,
    required this.uploadType,
    this.labelText,
    this.label,
    this.showRequiredIndicator,
    this.leading,
    this.exceptionTextGetterOverride,
    this.assetActionBuilders = const [],
  });

  @override
  Widget buildField(BuildContext context, AssetPortField field, String? value, Object? exception) {
    final newAssetX = useObservable<Asset?>(() => null);
    final preview = newAssetX.value;
    useListen(newAssetX, (Asset? value) {
      field.newAsset = value;
    });

    final isChangedX = useObservable<bool>(() => false);
    final isChanged = isChangedX.value;
    useListen(isChangedX, (bool value) {
      field.isChanged = value;
    });

    final initialValueAsset = useAssetOrNull(value);

    final assetValue = preview.mapIfNonNull((value) => FutureValue.loaded(value: value)) ?? initialValueAsset;

    return StyledContent(
      header: getRequiredLabel(context, field: field, labelTextBuilder: StyledContentHeaderText.new),
      leading: leading ?? StyledIcon(Icons.image),
      children: [
        if (preview != null || (value != null && !isChanged))
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (assetValue != null)
                    StyledLoadingAsset(
                      key: ValueKey(preview != null ? 'preview:${preview.name}' : 'value:$value'),
                      maybeAsset: assetValue,
                      width: _imageWidth,
                      height: _imageHeight,
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: StyledIcon(Icons.remove_circle),
                        onPressed: () async {
                          final isChanged = field.initialValue != null;

                          newAssetX.value = null;
                          isChangedX.value = isChanged;
                        },
                      ),
                      IconButton(
                        icon: StyledIcon(Icons.swap_horiz),
                        onPressed: () async {
                          await upload(newAssetX: newAssetX, isChangedX: isChangedX);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              if (assetValue != null && assetValue.getOrNull() != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: assetActionBuilders
                      .map((actionBuilder) => actionBuilder.assetBuilder(
                            assetValue.getOrNull()!,
                            (asset) {
                              newAssetX.value = asset;
                              isChangedX.value = true;
                            },
                          ))
                      .toList(),
                ),
            ],
          ),
        if (preview == null && value == null)
          StyledButton.high(
            icon: Icons.upload,
            text: 'Upload',
            onTapped: () async {
              await upload(newAssetX: newAssetX, isChangedX: isChangedX);
            },
          ),
        if (preview == null && value != null && isChanged) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledBodyText('Removed', textOverrides: StyledTextOverrides(fontStyle: FontStyle.italic)),
              Column(
                children: [
                  IconButton(
                    icon: StyledIcon(Icons.add_photo_alternate),
                    onPressed: () async {
                      await upload(newAssetX: newAssetX, isChangedX: isChangedX);
                    },
                  ),
                  IconButton(
                    icon: StyledIcon(Icons.unarchive),
                    onPressed: () async {
                      newAssetX.value = null;
                      isChangedX.value = false;
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
        if (exception != null) StyledErrorText(getExceptionText(exception) ?? ''),
      ],
    );
  }

  Future<void> upload({
    required BehaviorSubject<Asset?> newAssetX,
    required BehaviorSubject<bool> isChangedX,
  }) async {
    final asset = await _pickAsset();
    if (asset == null) {
      return;
    }

    newAssetX.value = asset;
    isChangedX.value = true;
  }

  Future<Asset?> _pickAsset() {
    switch (uploadType) {
      case UploadType.image:
        return ImageAssetPicker.pickImageFromGallery();
      case UploadType.video:
        return VideoAssetPicker.pickVideoFromGallery();
    }
  }
}

enum UploadType {
  image,
  video,
}

class AssetAction {
  Widget Function(Asset asset, void Function(Asset asset) updater) assetBuilder;

  AssetAction(this.assetBuilder);
}
