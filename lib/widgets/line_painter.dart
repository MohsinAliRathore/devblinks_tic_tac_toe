import 'package:flutter/material.dart';

import '../Theme/app_colors.dart';

class LinePainter extends StatelessWidget {
  final List<int> winningCombo;

  const LinePainter({super.key, required this.winningCombo});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
      painter: _WinningLinePainter(winningCombo),
    );
  }
}

class _WinningLinePainter extends CustomPainter {
  final List<int> combo;

  _WinningLinePainter(this.combo);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.yellowColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    double cellSize = size.width / 3;
    Offset start = _getCenter(combo.first, cellSize);
    Offset end = _getCenter(combo.last, cellSize);

    canvas.drawLine(start, end, paint);
  }

  Offset _getCenter(int index, double cellSize) {
    int row = index ~/ 3;
    int col = index % 3;
    return Offset(
      col * cellSize + cellSize / 2,
      row * cellSize + cellSize / 2,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}