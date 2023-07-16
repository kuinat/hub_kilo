import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../color_constants.dart';

class BannerWidget extends StatelessWidget {
  final Color color;
  final double size;
  final Widget child;
  final String title;
  final double iconSize;
  final Color iconColor;

  BannerWidget({
    this.color = validateColor,
    this.size = 80,
    @required this.child,
    this.iconSize = 24,
    @required this.title,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          right: 0,
          child: CustomPaint(
            painter: _TrianglePainter(color),
            size: Size(size, size),
          ),
        ),
        Positioned(
          top: 15,
          right: 0,
          child: Transform.rotate(
              angle: 120,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(title, style: Get.textTheme.headline2.merge(TextStyle(color: Colors.white, fontSize: 15))
                )
              )
          )
        ),
      ],
    );
  }
}
class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrianglePainter oldDelegate) => false;
}