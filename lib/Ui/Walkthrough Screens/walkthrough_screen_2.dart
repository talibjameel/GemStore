import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Widget/cutom_button.dart';

class WalkthroughScreen2 extends StatefulWidget {
  const WalkthroughScreen2({super.key});

  @override
  State<WalkthroughScreen2> createState() => _WalkthroughScreen2State();
}
class _WalkthroughScreen2State extends State<WalkthroughScreen2> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> images = [
    "res/images/Walkthrough_images/model1.png",
    "res/images/Walkthrough_images/model2.png",
    "res/images/Walkthrough_images/model3.png",
  ];

  // 👉 Add titles & subtitles for each page
  final List<String> titles = [
    "Discover something new",
    "Find your perfect style",
    "Enjoy easy shopping",
  ];

  final List<String> subtitles = [
    "Special new arrivals just for you",
    "Trendy outfits crafted for comfort",
    "Fast delivery at your doorstep",
  ];

  Future<void> completeWalkthrough() async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'walkthroughSeen', value: 'true');
    Navigator.pushReplacementNamed(context, '/MiddleWare');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top (white + black background)
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(flex: 3, child: Container(color: Colors.white)),
                    Expanded(flex: 2, child: Container(color: Color(0xFF464447))),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 60),

                    Text(
                      titles[_currentIndex],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      subtitles[_currentIndex],
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),


                    // PageView Cards
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                              width: 240,
                              height: 340,
                              padding: const EdgeInsets.only(top: 30, left: 0, right: 20,),
                              decoration: BoxDecoration(
                                color: Color(0XFFE7E8E9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  images[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),




                    // Page Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        images.length,
                            (index) {
                          final bool isActive = _currentIndex == index;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isActive ? 10 : 8,
                            height: isActive ? 10 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? Colors.grey : Colors.transparent,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: CustomButton(
                        text: "Shopping Now",
                        textColor: Colors.white,
                        fontSize: 13,
                        width: 210,
                        height: 53,
                        borderColor: Colors.white,
                        backgroundColor: Color(0xFF747375),
                        borderRadius: 25,
                        onPressed: () {
                          completeWalkthrough();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
