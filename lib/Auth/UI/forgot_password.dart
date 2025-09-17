import 'package:ecommerce_store/Auth/Api/auth_api_services.dart';
import 'package:ecommerce_store/Helper%20Funcation/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Helper Funcation/cutom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ApiService apiService = ApiService();
  TextEditingController emailController = TextEditingController();
  FlutterSecureStorage storage = FlutterSecureStorage();




  Future<void> forgotPassword() async{

    final email = emailController.text;
    try{
      final response = await apiService.forgotPassword(email);
      storage.write(key: 'UserEmail', value: emailController.text);
      debugPrint("Forgot Password Success: $response");
      debugPrint("User Email: $email");
      Navigator.pushReplacementNamed(context, '/OtpVerificationScreen');
    }catch(e){
      throw Exception("Error: $e");
    }
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
              padding: EdgeInsets.only(left: 5),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: 'Forgot Password?',
                fontSize: 22,
                fontWeight: FontWeight.normal,
                color: Colors.black,
            ),
            SizedBox(height: 20,),
            TextWidget(
                text: 'Enter email associated with your account and we’ll send and email with instructions to reset your password',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black,
            ),
            SizedBox(height: 20,),
            TextField(
              controller: emailController,
                decoration: InputDecoration(
                  hintText: 'enter your email address here',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.center,
              child:  CustomButton(
                text: "Forgot Password",
                fontSize: 12,
                width: 200,
                height: 51,
                backgroundColor: Color(0xFF2D201C),
                borderRadius: 25,
                onPressed: () {
                  forgotPassword();
                },
              ),
            ),
          ]
        )
      ),
    );
  }
}

