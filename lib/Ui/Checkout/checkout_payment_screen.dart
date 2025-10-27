import 'package:ecommerce_store/Widget/custom_appbar.dart';
import 'package:ecommerce_store/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '../../APIs/payment_api/stripe_api.dart';
import '../../Providers/payment_value_provider.dart';
import '../../Widget/step_indicator.dart';
import '../../Providers/cart_api_and_provider.dart';

class CheckoutPaymentScreen extends ConsumerStatefulWidget {
  const CheckoutPaymentScreen({super.key,});

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Check out"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                                color: Colors.black.withValues(alpha: .05),
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
                ],
              ),
            ),
            
            /// 📄 Dynamic Payment Page Section
            if (selectedIndex == 0) const _CashPaymentView(),
            if (selectedIndex == 1) const _CreditCardView(),
            if (selectedIndex == 2) const _MoreOptionView(),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You selected Cash on Delivery.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                "Please keep the exact change ready when your order arrives.",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),
            ]
          ),
        ),

        CheckOutPayment(),
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
       Padding(
         padding: EdgeInsets.symmetric(horizontal: 20),

         child: Column(
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
             SizedBox(height: 20),
           ]
         ),
       ),
        CheckOutPayment(),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Other payment options coming soon!",
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 20),
            ],
          ),
        ),
        CheckOutPayment(),
      ],
    );
  }
}

class CheckOutPayment extends ConsumerStatefulWidget {
  const CheckOutPayment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckOutPaymentState();
}

class _CheckOutPaymentState extends ConsumerState<CheckOutPayment> {
  final stripeApi = StripePaymentApi();
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final selectedShipping = ref.watch(shippingProvider);


    // 🧮 Calculate Delivery Charges
    double deliveryCharge =
    selectedShipping == "standard" ? 14.99 : 0.0;

    // 🧮 Calculate Total Amount
    double totalAmount = cartNotifier.totalPrice + deliveryCharge;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 🧾 Total Product Price
            cartState.when(
              data: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(
                    text: "Product Price",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  TextWidget(
                    text: "\$${cartNotifier.totalPrice.toStringAsFixed(2)}",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              loading: () =>
              const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Text("Error: $err", style: const TextStyle(color: Colors.red)),
            ),

            const Divider(),
            const SizedBox(height: 10),

            /// 🚚 Delivery Charges
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  text: "Delivery Charges",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                TextWidget(
                  text: "\$${deliveryCharge.toStringAsFixed(2)}",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            const Divider(),
            const SizedBox(height: 10),

            /// 💰 Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  text: "Subtotal",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
                TextWidget(
                  text: "\$${totalAmount.toStringAsFixed(2)}",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ✅ Terms Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: checkBox,
                  onChanged: (value) {
                    setState(() {
                      checkBox = value!;
                    });
                  },
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextWidget(
                    text: "I agree to the Terms & Conditions",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

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


                  if(checkBox == true){
                    stripeApi.makeTestPayment(context, amountInCents: totalAmount.toInt() * 100);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please accept the terms and conditions."),
                      ),
                    );
                  }
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
