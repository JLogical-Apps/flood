import 'package:flutter/material.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/style.dart';
import 'package:utils/utils.dart';

class DeltaStyleCheckboxRenderer with IsTypedStyleRenderer<StyledCheckbox> {
  @override
  Widget renderTyped(BuildContext context, StyledCheckbox component) {
    final label = component.label ?? component.labelText?.mapIfNonNull((text) => StyledText.body(text));
    final leading = component.leading ?? component.leadingIcon?.mapIfNonNull((icon) => StyledIcon(icon));

    return StyledList.column(
      itemPadding: EdgeInsets.zero,
      children: [
        StyledList.row.shrink.centered(
          itemPadding: EdgeInsets.zero,
          children: [
            if (leading != null)
              GestureDetector(
                child: leading,
                onTap: () => component.onChanged?.call(!component.value),
              ),
            if (label != null || component.showRequiredIndicator)
              GestureDetector(
                onTap: () => component.onChanged?.call(!component.value),
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: StyledList.row(
                    itemPadding: EdgeInsets.all(2),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (label != null) label,
                      if (component.showRequiredIndicator)
                        StyledIcon.strong(
                          Icons.emergency,
                          size: 8,
                        ),
                    ],
                  ),
                ),
              ),
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              fillColor: MaterialStateProperty.resolveWith(
                (states) {
                  if (component.errorText != null && states.contains(MaterialState.selected)) {
                    return Colors.red;
                  }
                  if (states.contains(MaterialState.selected)) {
                    if (states.contains(MaterialState.disabled)) {
                      return context.colorPalette().background.regular;
                    } else {
                      return context.colorPalette().background.strong;
                    }
                  }
                  return Colors.transparent;
                },
              ),
              side: BorderSide(
                width: 1.2,
                color: component.errorText != null
                    ? Colors.red
                    : component.onChanged == null
                        ? context.colorPalette().foreground.subtle
                        : context.colorPalette().foreground.regular,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              overlayColor: MaterialStateProperty.all(context.colorPalette().background.regular.withOpacity(0.5)),
              value: component.value,
              onChanged: component.onChanged == null ? null : (value) => component.onChanged!(value ?? false),
            ),
          ],
        ),
        if (component.errorText != null) StyledText.body.error.bold(component.errorText!),
      ],
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide.getTabByNameOrCreate('Input', icon: Icons.input).getSectionByNameOrCreate('Checkbox')
      ..add(StyledCheckbox(
        value: true,
        labelText: 'Checkbox On',
        onChanged: (value) {},
      ))
      ..add(StyledCheckbox(
        value: false,
        labelText: 'Checkbox Off',
        onChanged: (value) {},
      ))
      ..add(StyledCheckbox(
        value: false,
        labelText: 'Uh Oh',
        errorText: 'There was an error',
        leadingIcon: Icons.ac_unit_outlined,
        onChanged: (value) {},
      ))
      ..add(StyledCheckbox(
        value: true,
        labelText: 'Disabled',
      ))
      ..add(StyledCheckbox(
        value: true,
        labelText: 'Disabled Error',
        errorText: 'Here is an error',
      ))
      ..add(StyledContainer.strong(
        child: StyledList.column(children: [
          StyledCheckbox(
            value: true,
            labelText: 'Checkbox On',
            onChanged: (value) {},
          ),
          StyledCheckbox(
            value: false,
            labelText: 'Checkbox Off',
            onChanged: (value) {},
          ),
          StyledCheckbox(
            value: false,
            labelText: 'Uh Oh',
            errorText: 'There was an error',
            leadingIcon: Icons.ac_unit_outlined,
            onChanged: (value) {},
          ),
          StyledCheckbox(
            value: true,
            labelText: 'Disabled',
          ),
          StyledCheckbox(
            value: true,
            labelText: 'Disabled Error',
            errorText: 'Here is an error',
          ),
        ]),
      ));
  }
}
