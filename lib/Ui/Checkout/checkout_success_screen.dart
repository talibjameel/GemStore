import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../Widget/custom_appbar.dart';
import '../../Widget/step_indicator.dart';

class CheckoutSuccessScreen extends StatefulWidget {
  const CheckoutSuccessScreen({super.key});

  @override
  State<CheckoutSuccessScreen> createState() => _CheckoutSuccessScreenState();
}

class _CheckoutSuccessScreenState extends State<CheckoutSuccessScreen> {

  bool showSuccessAnimation = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Checkout Success"),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.9),
              Colors.white.withValues(alpha: 0.7)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 🎯 Background / Main Content
            Column(
              children: [
                const StepIndicator(currentStep: 3),
                const SizedBox(height: 200),
                SvgPicture.asset(
                  "res/images/successOrder.svg",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Order Complete!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Thank you for your purchase.You can view your order in ‘My Orders’ section. Continue shopping",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            // 🎉 Success Animation Overlay (top layer)
            if (showSuccessAnimation)
              Positioned.fill(
                child: Center(
                  child: Lottie.asset(
                    "res/congratulation.json",
                    height: 500,
                    repeat: true,
                    fit: BoxFit.contain,
                    onLoaded: (_) {
                      Future.delayed(const Duration(seconds: 90), () {
                        if (mounted) setState(() => showSuccessAnimation = false);
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
