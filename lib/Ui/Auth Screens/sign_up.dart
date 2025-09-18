import 'package:ecommerce_store/Helper%20Funcation/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Helper Funcation/cutom_button.dart';
import '../../APIs/Auth Api/auth_api_services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final apiService = ApiService();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    try {
      final response = await apiService.signUp(name, email, password, confirmPassword);
      debugPrint("Signup Success: $response");
      if(mounted){
        Navigator.pushReplacementNamed(context, '/MainNavigation');
      }
    } catch (e) {
      debugPrint("Signup Error: $e");
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            TextWidget(
              text:  'Create \nyour Account',
              fontSize: 25,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            SizedBox(height: 20,),
            TextField(
              controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )
            ),
            SizedBox(height: 20,),
            TextField(
              controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )
            ),

            SizedBox(height: 20,),
            TextField(
              controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )
            ),
            SizedBox(height: 30,),
            TextField(
              controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )
            ),
            SizedBox(height: 30,),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  CustomButton(
                    text: "SignUp",
                    width: 147,
                    height: 51,
                    backgroundColor: Color(0xFF2D201C),
                    borderRadius: 25,
                    onPressed: () {
                      signUp();
                    },
                  ),
                  SizedBox(height: 15,),
                  TextWidget(
                    text: 'Or sign up with',
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      SvgPicture.asset('res/Auth Screens Button/Frame 12.svg'),
                      SvgPicture.asset('res/Auth Screens Button/Frame 13.svg'),
                      SvgPicture.asset('res/Auth Screens Button/Frame 14.svg'),
                    ],
                  ),
                  SizedBox(height: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: 'Don\'t have an account?',
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.pushNamed(context, '/LoginScreen');
                          },
                          child: TextWidget(
                            text: 'Log in',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF2D201C),
                            decoration: TextDecoration.underline,
                          )
                      ),
                    ],
                  )

                ],
              ),)
          ],
        ),
      ),
    );
  }
}
