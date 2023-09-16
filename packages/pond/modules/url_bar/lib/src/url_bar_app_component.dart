import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pond/pond.dart';
import 'package:style/style.dart';

class UrlBarAppComponent with IsAppPondComponent {
  @override
  Widget wrapPage(AppPondContext context, Widget page, AppPondPageContext pageContext) {
    return HookBuilder(builder: (context) {
      final isExpandedState = useState<bool>(false);
      final isExpanded = isExpandedState.value;

      final locationValue = useState<String>('/');

      return Stack(
        children: [
          page,
          Positioned(
            left: 0,
            right: isExpanded ? 0 : null,
            width: isExpanded ? null : 60,
            height: isExpanded ? 120 : 40,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            child: Material(
              color: Colors.transparent,
              child: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) {
                      return isExpandedState.value
                          ? StyledList.row(
                              children: [
                                Expanded(
                                  child: StyledTextField(
                                    text: locationValue.value,
                                    onChanged: (text) => locationValue.value = text,
                                  ),
                                ),
                                Column(
                                  children: [
                                    StyledButton.strong(
                                      labelText: 'Go',
                                      onPressed: () async {
                                        context.pushLocation(locationValue.value);
                                        isExpandedState.value = false;
                                      },
                                    ),
                                    StyledButton(
                                      labelText: 'Hide',
                                      onPressed: () async {
                                        isExpandedState.value = false;
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SizedBox(
                              width: 100,
                              height: 100,
                              child: GestureDetector(
                                onLongPress: () {
                                  locationValue.value = context.location;
                                  isExpandedState.value = true;
                                },
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
