import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;

  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    Color active = Colors.black;
    Color inactive = Colors.grey.shade300;

    return Row(
      spacing: 1,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIcon(Icons.location_on_rounded, 1, active, inactive),
        _buildLine(1),
        _buildStepIcon(Icons.credit_card_rounded, 2, active, inactive),
        _buildLine(2),
        _buildStepIcon(Icons.check_circle_rounded, 3, active, inactive),
      ],
    );
  }

  Widget _buildLine(int step) {
    bool isActive = currentStep > step;
    return CustomPaint(
      painter: DottedLinePainter(isActive ? Colors.black : Colors.grey.shade300),
      size: const Size(90, 2),
    );
  }


  Widget _buildStepIcon(IconData icon, int step, Color active, Color inactive) {
    bool isActive = currentStep == step;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? active : inactive,
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey.shade600,
        size: 22,
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2;

    double startX = 0;
    const double dashWidth = 4;
    const double dashSpace = 3;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2),
          Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
