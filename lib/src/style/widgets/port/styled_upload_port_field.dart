import 'package:flutter/material.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../content/styled_content.dart';
import '../input/styled_button.dart';
import '../misc/styled_icon.dart';
import '../misc/styled_loading_image.dart';
import '../misc/styled_loading_indicator.dart';
import '../text/styled_body_text.dart';
import '../text/styled_error_text.dart';
import '../text/styled_text_overrides.dart';

class StyledUploadPortField extends PortFieldWidget<AssetPortField, String?, String?> with WithPortExceptionTextGetter {
  static const double _imageWidth = 200;
  static const double _imageHeight = 200;

  final String? labelText;

  final Widget? leading;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledUploadPortField({
    super.key,
    required super.name,
    this.labelText,
    this.leading,
    this.exceptionTextGetterOverride,
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

    final initialValueModel = useModelOrNull(value.mapIfNonNull((value) => locate<AssetModule>().getAssetModel(value)));

    final assetValue = preview ?? initialValueModel?.getOrNull();

    return StyledContent(
      headerText: labelText ?? 'Upload',
      leading: leading ?? StyledIcon(Icons.image),
      children: [
        if (preview != null || (value != null && !isChanged))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (assetValue == null)
                SizedBox(
                  width: _imageWidth,
                  height: _imageHeight,
                  child: StyledLoadingIndicator(),
                ),
              if (assetValue != null)
                StyledLoadingImage(
                  image: MemoryImage(assetValue.value),
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
        if (preview == null && value == null)
          StyledButton.high(
            icon: Icons.upload,
            text: 'Upload',
            onTapped: () async {
              await upload(newAssetX: newAssetX, isChangedX: isChangedX);
            },
          ),
        if (preview == null && value != null && isChanged) ...[
          if (isChanged)
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
    final asset = await ImageAssetPicker.pickImageFromGallery();
    if (asset == null) {
      return;
    }

    newAssetX.value = asset;
    isChangedX.value = true;
  }
}
