// SPDX-FileCopyrightText: 2023 Iconica
//
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  DashedBorderPainter({
    this.color = Colors.black,
    this.dashWidth = 2.0,
    this.dashLength = 6.0,
    this.space = 3.0,
  });
  final Color color;
  final double dashWidth;
  final double dashLength;
  final double space;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = dashWidth;

    var x = 0.0;
    var y = 0.0;

    // Top border
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashLength, 0), paint);
      x += dashLength + space;
    }

    // Right border
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width, y),
        Offset(size.width, y + dashLength),
        paint,
      );
      y += dashLength + space;
    }

    x = size.width;
    // Bottom border
    while (x > 0) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x - dashLength, size.height),
        paint,
      );
      x -= dashLength + space;
    }

    y = size.height;
    // Left border
    while (y > 0) {
      canvas.drawLine(Offset(0, y), Offset(0, y - dashLength), paint);
      y -= dashLength + space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
