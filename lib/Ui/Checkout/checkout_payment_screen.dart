import 'package:ecommerce_store/Widget/custom_appbar.dart';
import 'package:ecommerce_store/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../Widget/step_indicator.dart';
import 'checkout_success_screen.dart';
import '../../Providers/cart_api_and_provider.dart';

class CheckoutPaymentScreen extends ConsumerStatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  ConsumerState<CheckoutPaymentScreen> createState() =>
      _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState
    extends ConsumerState<CheckoutPaymentScreen> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> paymentOptions = [
    {'icon': Icons.attach_money, 'label': 'Cash'},
    {'icon': Icons.credit_card, 'label': 'Credit Card'},
    {'icon': Icons.more_horiz, 'label': 'More Option'},
  ];

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Check out"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const StepIndicator(currentStep: 2),
            const SizedBox(height: 30),
            const Text("STEP 2", style: TextStyle(color: Colors.grey)),
            const Text("Payment Method",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            /// 💳 Payment Option Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(paymentOptions.length, (index) {
                final isSelected = selectedIndex == index;
                final option = paymentOptions[index];

                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    width: 100,
                    height: 65,
                    decoration: BoxDecoration(
                      color:
                      isSelected ? const Color(0xFF43484B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.shade300, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(option['icon'],
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6E768A),
                            size: 30),
                        const SizedBox(height: 5),
                        Text(option['label'],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                            )),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 25),

            /// 📄 Dynamic Payment Page Section
            if (selectedIndex == 0) const _CashPaymentView(),
            if (selectedIndex == 1) const _CreditCardView(),
            if (selectedIndex == 2) const _MoreOptionView(),

            const SizedBox(height: 30),

            /// 🧾 Total Amount (from Provider)
            cartState.when(
              data: (_) => Text(
                "Total: \$${cartNotifier.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Text("Error: $err", style: const TextStyle(color: Colors.red)),
            ),

            const SizedBox(height: 30),

            /// 🛒 Place Order Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CheckoutSuccessScreen()),
                  );
                },
                child: const Text(
                  "Place Order",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// 💰 Page 1 — Cash Payment
class _CashPaymentView extends StatelessWidget {
  const _CashPaymentView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "You selected Cash on Delivery.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        Text(
          "Please keep the exact change ready when your order arrives.",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

/// 💳 Page 2 — Credit Card Payment
class _CreditCardView extends StatelessWidget {
  const _CreditCardView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const TextWidget(
                text: "Choose your card",
                color: Colors.black,
                fontSize: 16),
            TextButton(
              onPressed: () {},
              child: const TextWidget(
                  text: "Add New +", color: Colors.red, fontSize: 16),
            ),
          ],
        ),
        SvgPicture.asset(
          "res/images/Card.svg",
          height: 200,
          width: double.infinity,
        ),
        const SizedBox(height: 20),
        const TextWidget(
          text: "Or checkout with",
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 20),
        SvgPicture.asset(
          "res/images/payments.svg",
          height: 40,
          width: double.infinity,
        ),
      ],
    );
  }
}

/// ⚙️ Page 3 — More Option
class _MoreOptionView extends StatelessWidget {
  const _MoreOptionView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Other payment options coming soon!",
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
