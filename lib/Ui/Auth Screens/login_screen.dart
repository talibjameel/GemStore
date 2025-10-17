import 'package:ecommerce_store/Helper%20Funcation/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../APIs/Auth Api/auth_api_services.dart';
import '../../Helper Funcation/cutom_button.dart';
import 'forgot_password.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ApiService apiService = ApiService();

  Future<void> login() async{
    final email = emailController.text;
    final password = passwordController.text;

    try{
      final response = await apiService.login(email, password);
      debugPrint("Login Success: $response");
      if(context.mounted){
        Navigator.pushReplacementNamed(context, '/MainNavigation');
      }
    }catch(e){
      debugPrint("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
            SizedBox(height: 100,),
            TextWidget(
               text:  'Login into\nyour Account',
              fontSize: 25,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            SizedBox(height: 45,),
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
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                },
                child: TextWidget(
                  text: 'Forgot Password?',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),

            ),
            SizedBox(height: 30,),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  CustomButton(
                    text: "Login",
                    width: 147,
                    height: 51,
                    backgroundColor: Color(0xFF2D201C),
                    borderRadius: 25,
                    onPressed: () {
                      login();
                    },
                  ),
                  SizedBox(height: 15,),
                  TextWidget(
                    text: 'Or login with',
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: [
                      SvgPicture.asset('res/Auth_Button/google.svg'),
                      SvgPicture.asset('res/Auth_Button/apple.svg'),
                      SvgPicture.asset('res/Auth_Button/facebook.svg'),
                    ],
                  ),
                  SizedBox(height: 150,),
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
                            Navigator.pushReplacementNamed(context, '/SignupScreen');
                          },
                          child: TextWidget(
                            text: 'Sign Up',
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
