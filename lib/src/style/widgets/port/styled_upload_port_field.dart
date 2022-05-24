import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../port/export.dart';
import '../../../port/export_core.dart';
import '../content/styled_content.dart';
import '../input/styled_button.dart';
import '../misc/styled_icon.dart';
import '../text/styled_body_text.dart';
import '../text/styled_error_text.dart';

class StyledUploadPortField extends PortFieldWidget<RawPortField, Uint8List?> with WithPortExceptionTextGetter {
  /// The field name to set to true when the field is changed.
  /// The way assets are uploaded in a form are like this:
  /// There is the regular field name, such as "image". The default value is the current value in the asset.
  /// There is another field name, such as "imageChanged". The default value is false.
  /// Whenever the user uploads a new image, it changes this regular field name to the data of the new image,
  /// and sets the other field name to true.
  /// That way, when the port is submitted, you can validate whether the user uploaded a new image and upload it.
  final String changedFieldName;

  final String? labelText;

  final Widget? leading;

  @override
  final ExceptionTextGetter? exceptionTextGetterOverride;

  StyledUploadPortField({
    super.key,
    required super.name,
    String? changedFieldName,
    this.labelText,
    this.leading,
    this.exceptionTextGetterOverride,
  }) : this.changedFieldName = changedFieldName ?? '${name}Changed';

  @override
  Widget buildField(BuildContext context, RawPortField field, Uint8List? value, Object? exception) {
    final isChanged = getPort(context)[changedFieldName];
    return StyledContent(
      headerText: labelText ?? 'Upload',
      leading: leading ?? StyledIcon(Icons.image),
      children: [
        if (exception != null) StyledErrorText(getExceptionText(exception) ?? ''),
        if (value != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.memory(
                value,
                width: 200,
                height: 200,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: StyledIcon(Icons.remove_circle),
                    onPressed: () async {
                      final isChanged = field.initialValue != null;

                      setValue(context, null);
                      getPort(context).set(changedFieldName, isChanged);
                    },
                  ),
                  IconButton(
                    icon: StyledIcon(Icons.swap_horiz),
                    onPressed: () async {
                      await upload(getPort(context));
                    },
                  ),
                ],
              ),
            ],
          ),
        if (value == null) ...[
          if (isChanged)
            Row(
              children: [
                StyledBodyText('Removed'),
                IconButton(
                  icon: StyledIcon(Icons.add_photo_alternate),
                  onPressed: () async {
                    await upload(getPort(context));
                  },
                ),
                IconButton(
                  icon: StyledIcon(Icons.unarchive),
                  onPressed: () async {
                    final imageBytes = field.initialValue;
                    setValue(context, imageBytes);
                    getPort(context).set(changedFieldName, false);
                  },
                ),
              ],
            ),
          if (!isChanged)
            StyledButton.high(
              icon: Icons.upload,
              text: 'Upload',
              onTapped: () async {
                await upload(getPort(context));
              },
            ),
        ],
      ],
    );
  }

  Future<void> upload(Port port) async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile == null) {
      return;
    }

    final imageBytes = await imageFile.readAsBytes();
    port[name] = imageBytes;
    port[changedFieldName] = true;
  }
}
