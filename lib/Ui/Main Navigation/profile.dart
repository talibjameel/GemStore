import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Helper Funcation/cutom_button.dart';

/// 🔹Last Page Profile
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child:   CustomButton(
        text: "LogOut",
        width: 147,
        height: 51,
        backgroundColor: Color(0xFF2D201C),
        borderRadius: 25,
        onPressed: () async {
          // clear flutter secure storage
          await storage.delete(key: 'jwt_token');

          // navigate to splash screen
          if(context.mounted){
            Navigator.pushReplacementNamed(context, '/MiddleWare');
          }
        },),
    );
  }
}
