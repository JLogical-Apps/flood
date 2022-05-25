import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jlogical_utils/src/pond/export.dart';
import 'package:jlogical_utils/src/port/model/fields/asset_port_field.dart';
import 'package:jlogical_utils/src/style/export.dart';
import 'package:jlogical_utils/src/utils/export.dart';
import 'package:jlogical_utils/src/utils/export_core.dart';
import 'package:rxdart/rxdart.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../content/styled_content.dart';
import '../input/styled_button.dart';
import '../misc/styled_icon.dart';
import '../misc/styled_loading_indicator.dart';
import '../text/styled_body_text.dart';
import '../text/styled_error_text.dart';

class StyledUploadPortField extends PortFieldWidget<AssetPortField, String?> with WithPortExceptionTextGetter {
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
    final previewX = useObservable<Uint8List?>(() => null);
    final preview = previewX.value;
    useListen(previewX, (Uint8List? value) {
      field.preview = value;
    });

    final isChangedX = useObservable<bool>(() => false);
    final isChanged = isChangedX.value;
    useListen(isChangedX, (bool value) {
      field.isChanged = value;
    });

    final loadedInitialValue = useState<Uint8List?>(null);
    useOneTimeEffect(() {
      () async {
        final asset =
            value.mapIfNonNull((value) => locate<AssetModule>().getAssetProviderRuntime(field.assetType).from(value));
        final data = await asset?.model.ensureLoadedAndGet();
        loadedInitialValue.value = data as Uint8List?;
      }();
    });

    final assetValue = preview ?? loadedInitialValue.value;

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
                Image.memory(
                  assetValue,
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

                      previewX.value = null;
                      isChangedX.value = isChanged;
                    },
                  ),
                  IconButton(
                    icon: StyledIcon(Icons.swap_horiz),
                    onPressed: () async {
                      await upload(previewX: previewX, isChangedX: isChangedX);
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
              await upload(previewX: previewX, isChangedX: isChangedX);
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
                        await upload(previewX: previewX, isChangedX: isChangedX);
                      },
                    ),
                    IconButton(
                      icon: StyledIcon(Icons.unarchive),
                      onPressed: () async {
                        previewX.value = null;
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
    required BehaviorSubject<Uint8List?> previewX,
    required BehaviorSubject<bool> isChangedX,
  }) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }

    final imageBytes = await imageFile.readAsBytes();
    previewX.value = imageBytes;
    isChangedX.value = true;
  }
}
