import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intersperse/intersperse.dart';
import 'package:style/src/components/layout/styled_container.dart';
import 'package:style/src/components/layout/styled_list.dart';
import 'package:style/src/components/misc/styled_scrollbar.dart';
import 'package:style/src/components/text/styled_text.dart';
import 'package:style/src/style_renderer.dart';
import 'package:style/src/styleguide.dart';
import 'package:utils/utils.dart';

class FlatStyleListRenderer with IsTypedStyleRenderer<StyledList> {
  @override
  Widget renderTyped(BuildContext context, StyledList component) {
    var children = component.children;
    final ifEmpty = component.ifEmptyText?.mapIfNonNull((text) => StyledText.body(
              text,
              padding: EdgeInsets.all(8),
            )) ??
        component.ifEmpty;
    var usingEmpty = false;

    if (children.isEmpty && ifEmpty != null) {
      children = [ifEmpty];
      usingEmpty = true;
    }

    Widget widget = getBase(context, list: component, children: children, usingEmpty: usingEmpty);

    if (component.isCentered) {
      widget = Center(child: widget);
    }

    if (component.isScrollable) {
      final scrollController = ScrollController();

      widget = SingleChildScrollView(
        child: widget,
        controller: scrollController,
        scrollDirection: component.axis,
        physics: BouncingScrollPhysics(),
      );

      if (component.hasScrollbar) {
        widget = StyledScrollbar(
          child: widget,
          controller: scrollController,
        );
      }
    }

    if (component.children.isNotEmpty) {
      widget = Padding(
        padding: component.itemPadding,
        child: widget,
      );
    }

    return widget;
  }

  Widget getBase(
    BuildContext context, {
    required StyledList list,
    required List<Widget> children,
    required bool usingEmpty,
  }) {
    if (list.childMinSize == null || usingEmpty) {
      children = children
          .intersperse(SizedBox(
            width: list.itemPadding.horizontal,
            height: list.itemPadding.vertical,
          ))
          .toList();
      return list.axis == Axis.vertical
          ? Column(
              children: children,
              crossAxisAlignment: list.crossAxisAlignment,
              mainAxisAlignment: list.isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
            )
          : Row(
              children: children,
              crossAxisAlignment: list.crossAxisAlignment,
              mainAxisAlignment: list.isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
            );
    }

    return MasonryGridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      crossAxisCount: MediaQuery.of(context).size.width ~/ list.childMinSize!,
      mainAxisSpacing: list.itemPadding.vertical,
      crossAxisSpacing: list.itemPadding.horizontal,
      physics: NeverScrollableScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, i) => children[i],
    );
  }

  @override
  void modifyStyleguide(Styleguide styleguide) {
    styleguide
        .getTabByNameOrCreate('Containers', icon: Icons.layers_outlined)
        .getSectionByNameOrCreate('Staggered List')
        .add(StyledList.column.withMinChildSize(150)(
          children: [
            StyledContainer.subtle(
              child: StyledText.h5.centered('1'),
              width: double.infinity,
              height: 60,
            ),
            StyledContainer(
              child: StyledText.h5.centered('2'),
              width: double.infinity,
            ),
            StyledContainer.strong(
              child: StyledText.h5.centered('3'),
              width: double.infinity,
              height: 60,
            ),
            StyledContainer(
              color: Colors.blue,
              child: StyledText.h5.centered('4'),
              width: double.infinity,
            ),
          ],
        ));
  }
}
