import 'package:flutter/material.dart';
import 'custom_text_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: showBackButton
          ? Padding(
        padding: const EdgeInsets.all(8),
        child: Material(
          color: Colors.white,
          elevation: 3,
          shape: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 16,
              ),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
            ),
          ),
        ),
      )
          : null,
      title: TextWidget(text: title,fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black,),
      centerTitle: true,
      actions: actions,
    );
  }
}
