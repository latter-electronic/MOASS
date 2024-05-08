import 'package:flutter/material.dart';
import 'package:moass/model/seat.dart';

class SeatMapWidget extends StatelessWidget {
  final List<Seat> seatList;
  final Function() openButtonWidget;
  final TransformationController _transformationController =
      TransformationController();

  SeatMapWidget(
      {super.key, required this.seatList, required this.openButtonWidget}) {
    _transformationController.value = Matrix4.diagonal3Values(0.5, 0.5, 0.4);
  }
  late bool isOpenedButtonWidget = false;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      InteractiveViewer(
        transformationController: _transformationController,
        constrained: false,
        boundaryMargin: const EdgeInsets.all(50),
        minScale: 0.3,
        maxScale: 3.0,
        child: Stack(children: [
          CustomPaint(
            painter: SeatMap(seatList),
            size: const Size(942, 1495),
          ),
          for (final seat in seatList)
            Positioned(
              left: seat.coordX,
              top: seat.coordY,
              child: GestureDetector(
                onTap: () {
                  // 각 사각형을 터치했을 때의 동작 처리
                  // print('사각형 클릭됨: ${seat.coordX}, ${seat.coordY}');
                  openButtonWidget();
                },
                child: Container(
                  width: 85,
                  height: 85,
                  color: Colors.transparent,
                ),
              ),
            ),
        ]),
      ),
      isOpenedButtonWidget
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xFF3DB887),
                  foregroundColor: Colors.white,
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_on),
                  label: const Text(
                    '호출',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          : const SizedBox()
    ]);
  }
}

class SeatMap extends CustomPainter {
  final List<Seat> seatList;
  SeatMap(this.seatList);

  static const gridWidth = 50.0;
  static const gridHeight = 50.0;

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    _drawBackground(canvas, width, height);
    _drawGrid(canvas, width, height);
    _drawSeats(canvas);
  }

  void _drawBackground(Canvas canvas, double width, double height) {
    final background = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.grey.shade200
      ..isAntiAlias = true;

    const rect = Rect.fromLTWH(0, 0, 942, 1495);
    canvas.drawRect(rect, background);
  }

  void _drawGrid(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black38
      ..isAntiAlias = true;

    final rows = height / gridHeight;
    final cols = width / gridWidth;

    for (int row = 0; row < rows; row++) {
      final y = row * gridHeight;
      final p1 = Offset(0, y);
      final p2 = Offset(width, y);

      canvas.drawLine(p1, p2, paint);
    }

    for (int col = 0; col < cols; col++) {
      final x = col * gridWidth;
      final p1 = Offset(x, 0);
      final p2 = Offset(x, height);

      canvas.drawLine(p1, p2, paint);
    }
  }

  void _drawSeats(Canvas canvas) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.amber // 나중에 Seat Model 안에 착석 여부 넣어두고 착석했으면 분기처리 해줄 것.
      ..isAntiAlias = true;

    final fixedPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black // 나중에 Seat Model 안에 착석 여부 넣어두고 착석했으면 분기처리 해줄 것.
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    final teamNamePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white
      ..isAntiAlias = true;

    const teamNameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    const userNameTextStyle = TextStyle(
        color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800);

    RRect consultantSeat = RRect.fromRectAndRadius(
      const Rect.fromLTRB(700, 20, 885, 105),
      const Radius.circular(20),
    );
    canvas.drawRRect(consultantSeat, fixedPaint);
    _drawText(canvas, 792.5, 62.5, '컨설턴트석', userNameTextStyle);

    RRect coachSeat1 = RRect.fromRectAndRadius(
      const Rect.fromLTRB(50, 20, 200, 105),
      const Radius.circular(20),
    );
    canvas.drawRRect(coachSeat1, fixedPaint);
    _drawText(canvas, 125, 62.5, '코치석1', userNameTextStyle);
    RRect coachSeat2 = RRect.fromRectAndRadius(
      const Rect.fromLTRB(210, 20, 360, 105),
      const Radius.circular(20),
    );
    canvas.drawRRect(coachSeat2, fixedPaint);
    _drawText(canvas, 285, 62.5, '코치석2', userNameTextStyle);

    RRect door = RRect.fromRectAndRadius(
      const Rect.fromLTRB(341, 1475, 601, 1495),
      const Radius.circular(0),
    );
    canvas.drawRRect(door, fixedPaint);
    _drawText(canvas, 471, 1485, '출입구', userNameTextStyle);

    // seatList에 따라 그리기
    for (final seat in seatList) {
      // final c = Offset(seat.coordX, seat.coordY);
      // canvas.drawCircle(c, radius, paint);
      RRect rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(seat.coordX, seat.coordY, 85, 85),
          const Radius.circular(20));

      var teamNameRect = RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(seat.coordX + 42.5, seat.coordY + 24),
              width: 60,
              height: 22),
          const Radius.circular(20));
      canvas.drawRRect(rect, paint);
      canvas.drawRRect(teamNameRect, teamNamePaint);
      _drawText(canvas, seat.coordX + 42.5, seat.coordY + 24, '팀코드',
          teamNameTextStyle);
      _drawText(canvas, seat.coordX + 42.5, seat.coordY + 48, '이름',
          userNameTextStyle);
    }
  }

  void _drawText(Canvas canvas, double centerX, double centerY, String text,
      TextStyle style) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );

    final textPainter = TextPainter()
      ..text = textSpan
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center
      ..layout();

    final xCenter = (centerX - textPainter.width / 2);
    final yCenter = (centerY - textPainter.height / 2);
    final offset = Offset(xCenter, yCenter);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
