import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentApi {
  final String stripeSecretKey = dotenv.env['STRIPE_SECRET']!;

  /// 🔁 Create PaymentIntent on Stripe
  Future<String?> createPaymentIntent({required int amountInCents}) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': 'usd',
          'payment_method_types[]': 'card',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('✅ PaymentIntent created: ${response.body}');
        return data['client_secret'];
      } else {
        debugPrint('❌ Failed to create PaymentIntent: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Exception during PaymentIntent creation: $e');
      return null;
    }
  }

  /// 🧾 Make Test Payment using Stripe PaymentSheet
  Future<void> makeTestPayment(BuildContext context,
      {required int amountInCents}) async {
    try {
      // 1️⃣ Create PaymentIntent and get client_secret
      final clientSecret =
      await createPaymentIntent(amountInCents: amountInCents);

      if (clientSecret == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to get client_secret')),
        );
        return;
      }

      // 2️⃣ Initialize PaymentSheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Pay to Talib',
          style: ThemeMode.light,
        ),
      );

      // 3️⃣ Show PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/CheckoutSuccessfully",
            (route) => false,
      );

    } catch (e) {
      debugPrint('❌ Stripe Payment Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Payment Failed')),
      );
    }
  }
}
