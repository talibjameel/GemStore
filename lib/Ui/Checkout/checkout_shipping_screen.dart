import 'package:ecommerce_store/Widget/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../../Widget/step_indicator.dart';
import 'checkout_payment_screen.dart';


class CheckoutShippingScreen extends StatefulWidget {
  const CheckoutShippingScreen({super.key});

  @override
  State<CheckoutShippingScreen> createState() => _CheckoutShippingScreenState();
}

class _CheckoutShippingScreenState extends State<CheckoutShippingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedShipping = "free";
  bool copyAddress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Check out"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const StepIndicator(currentStep: 1),
            const SizedBox(height: 30),
            const Text("STEP 1", style: TextStyle(color: Colors.grey, fontSize: 12)),
            const Text("Shipping", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField("First name *", true),
                  _buildTextField("Last name *", true),
                  _buildTextField("Country *", true),
                  _buildTextField("Street name *", true),
                  _buildTextField("City *", true),
                  _buildTextField("State / Province", false),
                  _buildTextField("Zip-code *", true),
                  _buildTextField("Phone number *", true),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("Shipping method", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _buildShippingOption("Free", "Delivery from 3 to 7 business days", "free"),
            _buildShippingOption("\$9.90", "Delivery from 4 to 6 business days", "standard"),
            _buildShippingOption("\$9.90", "Delivery from 2 to 3 business days", "fast"),
            const SizedBox(height: 25),
            const Text("Coupon Code", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Have a code? type it here...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Validate", style: TextStyle(color: Color(0xff1A1A7B), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("Billing Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Row(
              children: [
                Checkbox(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  value: copyAddress,
                  onChanged: (v) => setState(() => copyAddress = v ?? false),
                ),
                const Text("Copy address data from shipping"),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPaymentScreen()));
                  }
                },
                child: const Text("Continue to payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, bool required) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        validator: required ? (v) => (v == null || v.isEmpty) ? "Field is required" : null : null,
      ),
    );
  }

  Widget _buildShippingOption(String title, String subtitle, String value) {
    final isSelected = selectedShipping == value;
    return GestureDetector(
      onTap: () => setState(() => selectedShipping = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffF7F7F7) : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedShipping,
              activeColor: Colors.black,
              onChanged: (val) => setState(() => selectedShipping = val),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
