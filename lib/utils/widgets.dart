import 'package:flutter/material.dart';
import 'package:design_request_app/screens/drawing_page.dart';

//制御盤の描画関数
void drawControlBoard(Canvas canvas, Paint paint, double x, double y,
    double width, double height) {
  canvas.drawRect(
    Rect.fromLTWH(x - width / 2, y - height, width, height),
    paint,
  );
}

//RS盤の描画関数
void drawRSBoard(Canvas canvas, Paint paint, double x, double y, double width,
    String label, double boardHeight) {
  // 枠線の描画
  canvas.drawRect(
    Rect.fromLTWH(x - width / 2, y - boardHeight, width, boardHeight),
    paint,
  );

  // ラベルの描画
  final textSpan = TextSpan(
    text: label,
    style: TextStyle(color: Colors.black, fontSize: 14),
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();
  final offset = Offset(x - 10, y - boardHeight + (boardHeight / 2) - 10);
  textPainter.paint(canvas, offset);
}

//機器の描画関数
void drawDevice(Canvas canvas, Paint paint, double x, double y, double width,
    double height, DeviceType deviceType) {
  canvas.drawRect(
    Rect.fromCenter(center: Offset(x, y), width: width, height: height),
    paint,
  );

  if (deviceType == DeviceType.HEX) {
    drawXInsideBox(canvas, paint, x, y, width, height);
  }
}

void drawXInsideBox(Canvas canvas, Paint paint, double x, double y,
    double width, double height) {
  canvas.drawLine(Offset(x - width / 2, y - height / 2),
      Offset(x + width / 2, y + height / 2), paint);
  canvas.drawLine(Offset(x + width / 2, y - height / 2),
      Offset(x - width / 2, y + height / 2), paint);
}
