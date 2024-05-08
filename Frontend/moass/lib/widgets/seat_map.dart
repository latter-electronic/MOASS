import 'package:flutter/material.dart';

class SeatMap extends CustomPainter {
  static const gridWidth = 50.0;
  static const gridHeight = 50.0;
  // size에 현재 캔버스의 크기 들어감
  // Container width & height로 크기 지정해줘야 함

  var _width = 0.0;
  var _height = 0.0;

  void _drawBackground(Canvas canvas) {
    var background = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.lime
      ..isAntiAlias = true;

    Rect rect = Rect.fromLTWH(0, 0, _width, _height);
    canvas.drawRect(rect, background);
  }

  // 선 형식 설정
  void _drawGrid(Canvas canvas) {
    var paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black38
      ..isAntiAlias = true;
    // 그리드의 높이 너비 정하기
    final rows = _height / gridHeight;
    final cols = _width / gridWidth;

    for (int row = 0; row < rows; row++) {
      final y = row * gridHeight;
      final p1 = Offset(0, y);
      final p2 = Offset(_width, y);

      canvas.drawLine(p1, p2, paint);
    }

    for (int col = 0; col < cols; col++) {
      final x = col * gridWidth;
      final p1 = Offset(x, 0);
      final p2 = Offset(x, _height);

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _width = size.width;
    _height = size.height;

    _drawBackground(canvas);
    _drawGrid(canvas);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
