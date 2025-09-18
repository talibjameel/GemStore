import 'package:ecommerce_store/Helper%20Funcation/cutom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Providers/category_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}
class _HomeState extends ConsumerState<Home> {
  bool isDarkMode = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    /// Riverpod se categories laa rahe hain
    final categoryAsync = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
        title: const Text(
          'GemStore',
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/NotificationUI');
              },
              icon: const Icon(Icons.notifications_none, color: Colors.black),
            ),
          ),
        ],
      ),

      drawer: _buildDrawer(),

      body: Column(
        children: [
          /// 🔹 Top Circular Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: categoryAsync.when(
              data: (categoryResponse) {
                final categories = categoryResponse.categories ?? [];

                if (categories.isEmpty) {
                  return const Center(child: Text("No categories"));
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(categories.length, (index) {
                    final cat = categories[index];
                    final bool isSelected = _selectedIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        debugPrint(
                            "Selected Tab: $index -> ${cat.name ?? "No Name"}");
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
                              child: const Icon(Icons.category,
                                  size: 20, color: Colors.black54),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cat.name ?? "No Name",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color:
                              isSelected ? Colors.black : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) =>
                  Center(child: Text("Error loading categories: $err")),
            ),
          ),

          const SizedBox(height: 30),

          /// 🔹 Placeholder for dynamic content
          Expanded(
            child: Center(
              child: Text(
                "Selected Tab: $_selectedIndex",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ✅ Drawer code same as tumhara hoga
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: const Center(child: Text("Drawer Placeholder")),
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
