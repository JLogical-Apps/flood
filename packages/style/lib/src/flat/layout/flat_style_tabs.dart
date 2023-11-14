import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:style/src/components/layout/styled_tabs.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_build_context_extensions.dart';
import 'package:style/src/style_renderer.dart';

class FlatStyleTabsRenderer with IsTypedStyleRenderer<StyledTabs> {
  @override
  Widget renderTyped(BuildContext context, StyledTabs component) {
    return HookBuilder(builder: (context) {
      final pageController = usePageController();
      final pageState = useState<int>(0);
      return Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              children: component.tabs.map((tab) => tab.child).toList(),
              onPageChanged: (page) => pageState.value = page,
            ),
          ),
          BottomNavigationBar(
            backgroundColor: context.colorPalette().background.regular,
            selectedItemColor: context.colorPalette().foreground.strong,
            unselectedItemColor: context.colorPalette().foreground.regular,
            selectedLabelStyle: context.style().getTextStyle(context, StyledText.body.empty),
            unselectedLabelStyle: context.style().getTextStyle(context, StyledText.body.empty),
            onTap: (index) => pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            ),
            currentIndex: pageState.value,
            items: component.tabs
                .map((tab) => BottomNavigationBarItem(
                      backgroundColor: context.colorPalette().background.subtle,
                      icon: Icon(tab.icon, color: context.colorPalette().foreground.subtle),
                      activeIcon: Icon(tab.icon, color: context.colorPalette().foreground.strong),
                      label: tab.titleText,
                    ))
                .toList(),
          ),
        ],
      );
    });
  }
}
