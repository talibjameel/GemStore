import 'package:ecommerce_store/Auth/Api/auth_api_services.dart';
import 'package:ecommerce_store/Helper%20Funcation/custom_text_widget.dart';
import 'package:ecommerce_store/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Helper Funcation/cutom_button.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}
class _UpdatePasswordState extends State<UpdatePassword> {
  ApiService apiService = ApiService();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> updatePassword() async{
    FlutterSecureStorage storage = FlutterSecureStorage();
    final userEmail = await  storage.read(key: 'UserEmail');
    final email = userEmail.toString();
    final newPassword = passwordController.text;
    try{
      final response = await apiService.updatePassword(email, newPassword);
      debugPrint("Update Password Success: $response");
      showPasswordChangedBottomSheet(context);
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
                  text: 'Create new password',
                  fontSize: 22,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                SizedBox(height: 20,),
                TextWidget(
                  text: 'Your new password must be different\nfrom previously used password',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                SizedBox(height: 20,),
                TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      suffixIcon: Icon(Icons.visibility),
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    )
                ),
                SizedBox(height: 20,),
                TextField(
                    controller: confirmPasswordController,
                  decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      suffixIcon: Icon(Icons.visibility),
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                    ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.center,
                  child:  CustomButton(
                    text: "Update Password",
                    fontSize: 12,
                    width: 200,
                    height: 51,
                    backgroundColor: Color(0xFF2D201C),
                    borderRadius: 25,
                    onPressed: () {
                      updatePassword();
                    }
                  ),
                ),
              ]
          )
      ),
    );
  }
}


void showPasswordChangedBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            // ✅ Icon at top
            Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF6F6F6),
              ),
              child: const Icon(Icons.check_circle_outline,
                  size: 40, color: Colors.black),
            ),

            const SizedBox(height: 20),

            // ✅ Title
            const Text(
              "Your password has been changed",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // ✅ Subtitle
            const Text(
              "Welcome back! Discover now!",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            // ✅ Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: const Text(
                  "Browse home",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
