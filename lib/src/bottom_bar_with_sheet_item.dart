import 'package:bottom_bar_with_sheet/src/bottom_bar_with_sheet_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Hello !
// ----------------------------------------------------------------------
// You can check all widget annotation
// In package repository: https://github.com/Frezyx/bottom_bar_with_sheet
// ----------------------------------------------------------------------

const defaultDuration = Duration(milliseconds: 500);

// ignore: must_be_immutable
class BottomBarWithSheetItem extends StatelessWidget {
  final String label;
  final String pngPath;
  final IconData icon;
  final Duration animationDuration;
  Color selectedBackgroundColor;
  Color selectedLabelColor;
  bool isLeft;
  Color itemIconColor;
  int _index;
  int _selectedIndex;
  BottomBarTheme _bottomBarTheme;
  double itemWidth;
  MainAxisAlignment _bottomBarMainAxisAlignment;

  BottomBarWithSheetItem({
    Key key,
    this.label,
    this.pngPath,
    this.itemWidth = 60,
    this.selectedBackgroundColor,
    @required this.icon,
    this.animationDuration = defaultDuration,
    this.itemIconColor,
  }) : super(key: key);

  Widget _buildText(String label) {
    bool isSelected = _checkItemState();
    return label == null
        ? Container()
        : Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? _bottomBarTheme.selectedItemLabelColor
                    : _bottomBarTheme.itemLabelColor,
                fontSize: isSelected
                    ? _bottomBarTheme.selectedItemTextStyle.fontSize
                    : _bottomBarTheme.itemTextStyle.fontSize,
                fontWeight: isSelected
                    ? _bottomBarTheme.selectedItemTextStyle.fontWeight
                    : _bottomBarTheme.itemTextStyle.fontWeight,
              ),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget _buildOpenedButton(png, IconData icon, double padding,
      Color selectedItemIconColor, double selectedItemIconSize) {
    return Center(
      child: ClipOval(
        child: CustomPaint(
          painter: ShapePainter(
            color: selectedItemIconColor,
            radius: selectedItemIconSize-5,
            shadowSpread: 6,
            strokeWidth: 5,
            spreadValue: 10,
          ),
          child:SizedBox(
                child: Padding(
              padding: EdgeInsets.all(padding),
              child: icon == null
                  ? Image.asset(
                      png,
                      height: selectedItemIconSize,
                      width: selectedItemIconSize,
                    )
                  : Icon(
                      icon,
                      size: selectedItemIconSize,
                      color: selectedItemIconColor,
                    ),
            )),
          //),
        ),
      ),
    );
  }

  Widget _buildClosedButton(png, IconData icon, double padding,
      Color selectedItemIconColor, double selectedItemIconSize) {
    return Center(
        child: ClipOval(
            child: Material(
                color: selectedItemIconColor,
                child: Ink(
                    child: SizedBox(
                        child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: icon == null
                      ? Image.asset(
                          png,
                          height: selectedItemIconSize,
                          width: selectedItemIconSize,
                        )
                      : Icon(
                          icon,
                          size: 20,
                          color: _bottomBarTheme.itemIconColor,
                        ),
                ))))));
  }

  void setIndex(int index) {
    this._index = index;
  }

  bool _checkItemState() {
    return _index == _selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    _bottomBarTheme = Provider.of<BottomBarTheme>(context);
    _selectedIndex = Provider.of<int>(context);
    _bottomBarMainAxisAlignment = Provider.of<MainAxisAlignment>(context);

    itemIconColor = itemIconColor ?? _bottomBarTheme.itemIconColor;
    selectedBackgroundColor =
        selectedBackgroundColor ?? _bottomBarTheme.selectedItemBackgroundColor;

    bool isSelected = _checkItemState();
    double iconTopSpacer = isSelected ? 0 : 2;
    Widget labelWidget = _buildText(label);
    Widget iconAreaWidget = isSelected
        ? _buildOpenedButton(
            pngPath,
            icon,
            _bottomBarTheme.selectedItemPadding,
            _bottomBarTheme.selectedItemIconColor,
            _bottomBarTheme.selectedItemIconSize)
        : _buildClosedButton(
            pngPath,
            icon,
            _bottomBarTheme.nonselectedItemPadding,
            _bottomBarTheme.itemIconColor,
            _bottomBarTheme.nonselectedItemIconSize);

    return AnimatedContainer(
      duration: animationDuration,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: _bottomBarMainAxisAlignment,
          children: <Widget>[
            SizedBox(height: iconTopSpacer),
            iconAreaWidget,
            labelWidget,
            SizedBox(height: 2),
          ]),
    );
  }
}

class ShapePainter extends CustomPainter {
  final Color color;
  final double radius;
  final int shadowSpread;
  final double strokeWidth;
  final int spreadValue;
  ShapePainter(
      {this.strokeWidth,
        this.radius,
        this.color,
        this.shadowSpread,
        this.spreadValue});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    List shadows = [];
    for (var i = 1; i <= shadowSpread; i++) {
      var shadow = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..maskFilter = MaskFilter.blur(
            BlurStyle.outer, convertRadiusToSigma((i * spreadValue).toDouble()))
        ..strokeCap = StrokeCap.round;
      shadows.add(shadow);
    }

    var stroke = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    shadows.forEach((element) {
      canvas.drawCircle(center, radius, element);
    });
    canvas.drawCircle(center, radius, stroke);
    canvas.drawCircle(center, radius, paint);
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
