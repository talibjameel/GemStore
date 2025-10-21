import 'package:ecommerce_store/APIs/Auth%20Api/auth_api_services.dart';
import 'package:ecommerce_store/Widget/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Widget/cutom_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  ApiService apiService = ApiService();
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());

  Future<void> otpVerification() async{
    FlutterSecureStorage storage = FlutterSecureStorage();
    final userEmail = await  storage.read(key: 'UserEmail');
    final email = userEmail.toString();
    final String otp = _controllers.map((controller) => controller.text).join();
    try{
      final response = await apiService.otpVerification(email, otp);
      debugPrint("OTP Verification Success: $response");
      debugPrint("User Email: $email \n OTP: $otp");
      Navigator.pushReplacementNamed(context, '/UpdatePasswordScreen');
    }catch(e){
      throw Exception("Error: $e");
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: _controllers[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Colors.black26, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Material(
            color: Colors.white,
            elevation: 3,
            shape: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 16),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextWidget(
            text: 'Verification code',
            fontSize: 22,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          TextWidget(
            text: 'Please enter the verification code we sent to your email address',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          const SizedBox(height: 30),

          // OTP FIELDS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => _buildOtpField(index)),
          ),

          const SizedBox(height: 40),
          Align(
            alignment: Alignment.center,
            child: CustomButton(
              text: "Verify",
              fontSize: 12,
              width: 200,
              height: 51,
              backgroundColor: const Color(0xFF2D201C),
              borderRadius: 25,
              onPressed: () {
                otpVerification();
              },
            ),
          ),
        ]),
      ),
    );
  }
}
