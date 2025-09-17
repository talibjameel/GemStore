import 'package:ecommerce_store/Helper%20Funcation/custom_text_widget.dart';
import 'package:ecommerce_store/Helper%20Funcation/cutom_button.dart';
import 'package:ecommerce_store/Notification/notification_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';


/// 🔹  Bottom navigationBar
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Home(),
    const Center(child: Text("Search Screen", style: TextStyle(fontSize: 20))),
    const Center(child: Text("Notifications Screen", style: TextStyle(fontSize: 20))),
    const Profile(),
    ];
 /// 🔹Bottom navigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black54,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              elevation: 0,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.search, size: 28), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_checkout_sharp, size: 28), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person, size: 28), label: ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 🔹First Page Home
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  bool isDarkMode = false;
  int _selectedIndex = 0;

  final List<String> _icons = [
    "res/TopButton/Woman.svg",
    "res/TopButton/Men.svg",
    "res/TopButton/Accessories.svg",
    "res/TopButton/Beauty.svg",
  ];

  final List<String> _labels = [
    "Woman",
    "Man",
    "Accessories",
    "Beauty",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Correct Drawer Setup
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: TextWidget(
          text: 'GemStore',
          fontSize: 22,
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const NotificationUi()));
              },
              icon: const Icon(Icons.notifications_none, color: Colors.black),
            ),
          ),
        ],
      ),

      // ✅ Sidebar Drawer
      drawer: _buildDrawer(),

      body: Column(
        children: [
          // 🔹 Top Circular Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_icons.length, (index) {
                final bool isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    debugPrint("Selected Tab: $index -> ${_labels[index]}");
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFF3A2C27)
                              : Colors.transparent,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? const Color(0xFF3A2C27)
                                : const Color(0xFFF3F3F3),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: SvgPicture.asset(
                              _icons[index],
                              colorFilter: ColorFilter.mode(
                                  isSelected ? Colors.white : const Color(0xFF9D9D9D),
                                  BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextWidget(
                        text: _labels[index],
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: isSelected ? Colors.black : Colors.black54,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 30),

          // 🔹 Placeholder for dynamic content
          Expanded(
            child: Center(
              child: Text(
                "Selected Tab: $_selectedIndex (${_labels[_selectedIndex]})",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ✅ Drawer widget
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Profile Section
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("assets/profile.png"),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Sunie Pham",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "sunieux@gmail.com",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30),

              // 🔹 Menu Items
              buildMenuItem(icon: Icons.home_outlined, label: "Homepage", isSelected: true),
              buildMenuItem(icon: Icons.search, label: "Discover"),
              buildMenuItem(icon: Icons.shopping_bag_outlined, label: "My Order"),
              buildMenuItem(icon: Icons.person_outline, label: "My profile"),

              const SizedBox(height: 24),
              const Text("OTHER",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black54)),
              const SizedBox(height: 12),

              buildMenuItem(icon: Icons.settings_outlined, label: "Setting"),
              buildMenuItem(icon: Icons.mail_outline, label: "Support"),
              buildMenuItem(icon: Icons.info_outline, label: "About us"),

              const Spacer(),

              // 🔹 Light/Dark Toggle
              _buildThemeSwitcher()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(
      {required IconData icon, required String label, bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF3F3F3) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isSelected ? Colors.black : Colors.black54, size: 22),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.black87,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        dense: true,
      ),
    );
  }

  Widget _buildThemeSwitcher() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Light Button
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isDarkMode = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: !isDarkMode ? Colors.white : Colors.transparent,
                  boxShadow: !isDarkMode
                      ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wb_sunny_outlined,
                        size: 18, color: Colors.black),
                    SizedBox(width: 6),
                    Text("Light",
                        style: TextStyle(fontSize: 13, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
          // Dark Button
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isDarkMode = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: isDarkMode ? Colors.white : Colors.transparent,
                  boxShadow: isDarkMode
                      ? [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.nightlight_round,
                        size: 18, color: Colors.black),
                    SizedBox(width: 6),
                    Text("Dark",
                        style: TextStyle(fontSize: 13, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
