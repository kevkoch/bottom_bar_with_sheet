library bottom_bar_with_sheet;

import 'dart:math' as math;

import 'src/main_action_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/bottom_bar_with_sheet_item.dart';
import 'src/bottom_bar_with_sheet_theme.dart';
import 'src/main_action_button_theme.dart';
import 'src/positions.dart';
import 'src/size_helper.dart';

export 'src/bottom_bar_with_sheet_item.dart';
export 'src/bottom_bar_with_sheet_theme.dart';
export 'src/main_action_button_theme.dart';
export 'src/positions.dart';
export 'src/main_action_button.dart';

const constCurve = Curves.linear;
const constDuration = Duration(milliseconds: 500);

// ignore: must_be_immutable
class BottomBarWithSheet extends StatefulWidget {
  /// navigation buttons of [BottomBarWithSheet]
  final List<BottomBarWithSheetItem> items;

  /// theme of [BottomBarWithSheet]
  final BottomBarTheme bottomBarTheme;

  /// theme of [MainActionButtonTheme]
  final MainActionButtonTheme mainActionButtonTheme;

  /// Callback [Function] works by clicking on one of [items]
  ///
  /// Return int [index] of selected button
  final Function onSelectItem;

  /// index of selected [BottomBarWithSheetItem] from [items]
  final int selectedIndex;

  /// Widget that displayed on bottom of [BottomBarWithSheet]
  /// when [isOpened] == true
  final Widget sheetChild;

  /// animation time of closing / opening [BottomBarWithSheet]
  final Duration duration;

  /// the style of animation from the suggested ones of [Curve]
  final Curve curve;

  /// The direction in which the widget content will line up
  final MainAxisAlignment bottomBarMainAxisAlignment;

  /// Responsible for the open / closed state of the widget
  bool isOpened;

  /// This field can replace mainActionButton
  final bool disableMainActionButton;

  /// Widget [MainActionButton] to create custom mainActionButton
  final MainActionButton mainActionButton;

  BottomBarWithSheet({
    Key key,
    this.selectedIndex = 0,
    this.isOpened = false,
    this.bottomBarMainAxisAlignment = MainAxisAlignment.center,
    this.duration = constDuration,
    this.curve = constCurve,
    this.disableMainActionButton = false,
    this.mainActionButton,
    @required this.sheetChild,
    this.items,
    @required this.bottomBarTheme,
    this.mainActionButtonTheme,
    @required this.onSelectItem,
  }) {
    assert(bottomBarTheme.mainButtonPosition != MainButtonPosition.Middle ||
        items.length % 2 == 0);
    assert(mainActionButton != null || mainActionButtonTheme != null);
  }

  @override
  _BottomBarWithSheetState createState() => _BottomBarWithSheetState(
        selectedIndex: selectedIndex,
        isOpened: isOpened,
        bottomBarMainAxisAlignment: bottomBarMainAxisAlignment,
        duration: duration,
        curve: curve,
        sheetChild: sheetChild,
      );
}

class _BottomBarWithSheetState extends State<BottomBarWithSheet>
    with SingleTickerProviderStateMixin {
  int selectedIndex;
  final bool isOpened;
  final Duration duration;
  final Curve curve;
  final MainAxisAlignment bottomBarMainAxisAlignment;
  final Widget sheetChild;

  _BottomBarWithSheetState({
    this.selectedIndex,
    this.isOpened,
    this.bottomBarMainAxisAlignment,
    this.duration,
    this.curve,
    this.sheetChild,
  });

  Widget _actionButtonIcon;
  AnimationController _arrowAnimationController;
  Animation _arrowAnimation;
  double _iconOpacity = 1;
  DragStartDetails startVerticalDragDetails;
  DragUpdateDetails updateVerticalDragDetails;

  @override
  void initState() {
    super.initState();
    MainActionButtonTheme(icon: Icon(Icons.arrow_upward));
    _arrowAnimationController =
        AnimationController(vsync: this, duration: duration);
    _arrowAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_arrowAnimationController);
    _actionButtonIcon = widget.mainActionButtonTheme?.icon ?? null;
    super.initState();
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BottomBarTheme bottomBarTheme = widget.bottomBarTheme;
    final backgroundColor =
        bottomBarTheme.backgroundColor ?? Theme.of(context).bottomAppBarColor;
    final leftPadding = widget.bottomBarTheme.contentPadding.left;
    final rightPadding = widget.bottomBarTheme.contentPadding.right;
    final itemWidth = _calculateItemWidth(
        context, rightPadding, leftPadding, widget.disableMainActionButton);

    return MultiProvider(
      providers: [
        Provider<BottomBarTheme>.value(value: bottomBarTheme),
        Provider<int>.value(value: widget.selectedIndex),
        Provider<bool>.value(value: widget.isOpened),
        Provider<MainAxisAlignment>.value(
            value: widget.bottomBarMainAxisAlignment),
      ],
      child: AnimatedContainer(
        duration: duration,
        curve: curve,
        height: _calculateWidgetHeight + 24,
        padding: widget.bottomBarTheme.contentPadding,
        decoration: widget.bottomBarTheme.decoration.copyWith(
          color: backgroundColor,
        ),
        child: Column(
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isOpened = !widget.isOpened;
                  });
                },
                onVerticalDragStart: (dragDetails) {
                  startVerticalDragDetails = dragDetails;
                },
                onVerticalDragUpdate: (dragDetails) {
                  setState(() {
                    updateVerticalDragDetails = dragDetails;
                  });
                },
                onVerticalDragEnd: (endDetails) {
                  setState(() {
                    double dx = updateVerticalDragDetails.globalPosition.dx -
                        startVerticalDragDetails.globalPosition.dx;
                    double dy = updateVerticalDragDetails.globalPosition.dy -
                        startVerticalDragDetails.globalPosition.dy;
                    double velocity = endDetails.primaryVelocity;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;

                    if (velocity < 0) {
                      widget.isOpened = true;
                    } else {
                      widget.isOpened = false;
                    }
                  });
                },
                child: Container(
                    height: 24,
                    width: MediaQuery.of(context).size.width * 1,
                    child: !widget.isOpened
                        ? Icon(
                            Icons.keyboard_arrow_up_rounded,
                            size: 24,
                          )
                        : Icon(
                            Icons.keyboard_arrow_down,
                            size: 24,
                          ))),
            widget.isOpened ? Container():Row(
              mainAxisAlignment: widget.bottomBarTheme.mainButtonPosition ==
                      MainButtonPosition.Middle
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildBody(itemWidth, widget.disableMainActionButton),
            ),
            widget.isOpened ? Expanded(child: sheetChild) : Container()
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody(itemWidth, bool disableMainActionButton) {
    switch (widget.bottomBarTheme.mainButtonPosition) {
      case MainButtonPosition.Right:
        return [
          _buildButtonsRow(itemWidth, disableMainActionButton),
          _buildMainActionButtton(disableMainActionButton)
        ];
        break;
      case MainButtonPosition.Left:
        return [
          _buildMainActionButtton(disableMainActionButton),
          _buildButtonsRow(itemWidth, disableMainActionButton)
        ];
        break;
      case MainButtonPosition.Middle:
        return _buildCentredBody(itemWidth, disableMainActionButton);
        break;
      default:
        return [
          _buildButtonsRow(itemWidth, disableMainActionButton),
          _buildMainActionButtton(disableMainActionButton)
        ];
        break;
    }
  }

  List<Widget> _buildCentredBody(itemWidth, bool disableMainActionButton) {
    final count = widget.items.length;
    final isEven = count % 2 == 0;
    return [
      isEven
          ? _buildButtonsRow(itemWidth, disableMainActionButton,
              leftCount: count ~/ 2, rightCount: count ~/ 2)
          : _buildButtonsRow(itemWidth, disableMainActionButton,
              leftCount: count ~/ 2 - 1, rightCount: count ~/ 2 + 1)
    ];
  }

  Container _buildButtonsRow(double itemWidth, bool disableMainActionButton,
      {int leftCount, int rightCount}) {
    if (leftCount != null && rightCount != null) {
      for (var i = 0; i < widget.items.length; i++) {
        if (i < leftCount) widget.items[i].isLeft = true;
        widget.items[i].setIndex(i);
      }
      return _buildCenteredView(
          itemWidth, leftCount, rightCount, disableMainActionButton);
    } else
      return _buildStandartView(itemWidth);
  }

  Container _buildStandartView(double itemWidth) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.items == null
            ? []
            : widget.items.map((item) {
                var i = widget.items.indexOf(item);
                item.setIndex(i);
                return _buildItem(i, itemWidth, item);
              }).toList(),
      ),
    );
  }

  Container _buildCenteredView(double itemWidth, int leftCount, int rightCount,
      bool disableMainActionButton) {
    final rowWidth =
        SizeHelper.getRowWidth(disableMainActionButton, widget, context);
    List<Widget> childrenLine = [];
    childrenLine.add(_getSeporatedItems(RowPosition.Left, rowWidth));
    childrenLine.add(_buildMainActionButtton(disableMainActionButton));
    childrenLine.add(_getSeporatedItems(RowPosition.Right, rowWidth));

    return Container(
      width: _calculateInnerWidth(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: childrenLine,
      ),
    );
  }

  double _calculateInnerWidth() =>
      MediaQuery.of(context).size.width -
      widget.bottomBarTheme.contentPadding.left -
      widget.bottomBarTheme.contentPadding.right;

  Container _getSeporatedItems(RowPosition position, double rowWidth) {
    final isLeft = position == RowPosition.Left;
    return Container(
      width: rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.items
            .where((item) => isLeft
                ? item.isLeft != null && item.isLeft
                : item.isLeft == null || !item.isLeft)
            .map((item) {
          var i = widget.items.indexOf(item);
          item.setIndex(i);
          return _buildItem(i, rowWidth / 2, item);
        }).toList(),
      ),
    );
  }

  GestureDetector _buildItem(
      int i, double itemWidth, BottomBarWithSheetItem item) {
    return GestureDetector(
      onTap: () {
        if (widget.isOpened) {
          _animateIcon();
          _changeWidgetState();
        }
        setState(() {
          widget.onSelectItem(i);
          selectedIndex = i;
        });
      },
      child: _buildItemSizedBox(itemWidth, item),
    );
  }

  SizedBox _buildItemSizedBox(double itemWidth, BottomBarWithSheetItem item) {
    return SizedBox(
      width: itemWidth,
      height: widget.bottomBarTheme.height,
      child: item,
    );
  }

  Widget _buildMainActionButtton(bool disableMainActionButton) {
    if (disableMainActionButton)
      return SizedBox();
    else
      return Container(
        color: Colors.transparent,
        transform: widget.mainActionButtonTheme?.transform ??
            Matrix4.translationValues(0.0, 0.0, 0.0),
        child: widget.mainActionButton != null
            ? _buildMainActionButton(widget.mainActionButton)
            : _buildDefaultMainActionButton(),
      );
  }

  Widget _buildMainActionButton(Widget button) {
    return InkWell(
      splashColor: widget.mainActionButtonTheme?.splash ?? Colors.transparent,
      child: AnimatedBuilder(
        animation: _arrowAnimationController,
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
            angle: _arrowAnimation.value * 2.0 * math.pi,
            child: child,
          );
        },
        child: button,
      ),
      onTap: () {
        _changeWidgetState();
      },
    );
  }

  Widget _buildDefaultMainActionButton() {
    return Padding(
      padding: widget.mainActionButtonTheme.margin,
      child: ClipOval(
        child: Material(
          color: widget.mainActionButtonTheme.color,
          child: InkWell(
            splashColor: widget.mainActionButtonTheme.splash,
            child: AnimatedBuilder(
              animation: _arrowAnimationController,
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(
                  angle: _arrowAnimation.value * 2.0 * math.pi,
                  child: child,
                );
              },
              child: SizedBox(
                width: widget.mainActionButtonTheme.size,
                height: widget.mainActionButtonTheme.size,
                child: Opacity(
                  opacity: _iconOpacity,
                  child: _actionButtonIcon,
                ),
              ),
            ),
            onTap: () {
              _animateIcon();
              _changeWidgetState();
            },
          ),
        ),
      ),
    );
  }

  void _changeWidgetState() {
    setState(() => widget.isOpened = !widget.isOpened);
    _arrowAnimationController.isCompleted
        ? _arrowAnimationController.reverse().then(
            (value) {
              // Call back in future version
            },
          )
        : _arrowAnimationController.forward().then(
            (value) {
              // Call back in future version
            },
          );
  }

  // TODO: simplify math

  double get _calculateWidgetHeight => widget.isOpened
      ? widget.bottomBarTheme.heightOpened +
          widget.bottomBarTheme.contentPadding.bottom +
          widget.bottomBarTheme.contentPadding.top
      : widget.bottomBarTheme.heightClosed +
          widget.bottomBarTheme.contentPadding.bottom +
          widget.bottomBarTheme.contentPadding.top;

  double _calculateItemWidth(BuildContext context, double rightPadding,
      double leftPadding, bool disableMainActionButton) {
    final screenWidth = MediaQuery.of(context).size.width;
    final count = widget.items != null ? widget.items.length : 1.0;
    final mainActionButtonPaddings = widget.mainActionButtonTheme == null
        ? 0.0
        : widget.mainActionButtonTheme.margin.left +
            widget.mainActionButtonTheme.margin.right;
    final mainActionButtonSize = disableMainActionButton
        ? 0.0
        : widget.mainActionButtonTheme?.size ?? 0.0;
    final sideSize = rightPadding +
        mainActionButtonSize +
        mainActionButtonPaddings +
        leftPadding;
    final itemWidth = (screenWidth - sideSize) / count;
    return itemWidth;
  }

  _animateIcon() async {
    setState(() {
      _iconOpacity = 1;
    });

    var animationTime = widget.duration.inMilliseconds / 50;
    var halfAnimationTime = animationTime / 2;
    var opacityPart = 1 / halfAnimationTime;

    for (var i = 0; i < halfAnimationTime; i++) {
      _iconOpacity -= opacityPart;
      if (_iconOpacity > 0.03 && i > halfAnimationTime / 3) {
        setState(() {
          _iconOpacity = _iconOpacity;
        });
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }

    setState(() {
      _actionButtonIcon = _actionButtonIcon == widget.mainActionButtonTheme.icon
          ? widget.mainActionButtonTheme.iconOpened ??
              widget.mainActionButtonTheme.icon
          : widget.mainActionButtonTheme.icon;
    });

    for (var i = 0; i < halfAnimationTime; i++) {
      _iconOpacity += opacityPart;
      if (_iconOpacity > 0.03 && i > halfAnimationTime / 3) {
        setState(() {
          _iconOpacity = _iconOpacity;
        });
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
}
