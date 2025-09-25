import 'package:ecommerce_store/Helper%20Funcation/custom_appBar.dart';
import 'package:ecommerce_store/Ui/Main%20Navigation/home_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}
class _SearchScreenState extends State<SearchScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Discover'),
      drawer: const CustomNavigationDrawer(),
      endDrawer: const FilterDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(25),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xFF777E90)),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: const TextStyle(color: Color(0xFF777E90)),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF777E90)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: const Icon(Icons.settings, color: Color(0xFF777E90)),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}


class FilterDrawer extends StatelessWidget {
  const FilterDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Filter",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Icon(Icons.settings, color: Colors.black),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Price Range
              const Text("Price",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              RangeSlider(
                values: const RangeValues(10, 80),
                min: 0,
                max: 100,
                activeColor: Colors.black,
                inactiveColor: Colors.grey[300],
                onChanged: (RangeValues values) {},
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$10", style: TextStyle(color: Colors.black)),
                    Text("\$80", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Color Selection
              const Text("Color",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildColorCircle(Colors.orange),
                  _buildColorCircle(Colors.red),
                  _buildColorCircle(Colors.black87),
                  _buildColorCircle(Colors.grey),
                  _buildColorCircle(Colors.brown),
                  _buildColorCircle(Colors.pink),
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Star Rating
              const Text("Star Rating",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildStarButton("1", false),
                  _buildStarButton("2", false),
                  _buildStarButton("3", false),
                  _buildStarButton("4", false),
                  _buildStarButton("5", true), // active
                ],
              ),
              const SizedBox(height: 20),

              // 🔹 Category Dropdown
              const Text("Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: "Crop Tops",
                  decoration: const InputDecoration(border: InputBorder.none),
                  items: const [
                    DropdownMenuItem(value: "Crop Tops", child: Text("Crop Tops")),
                    DropdownMenuItem(value: "Shirts", child: Text("Shirts")),
                    DropdownMenuItem(value: "Jeans", child: Text("Jeans")),
                  ],
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Discount Tags
              const Text("Discount",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildDiscountChip("50% off"),
                  _buildDiscountChip("40% off"),
                  _buildDiscountChip("30% off"),
                  _buildDiscountChip("25% off"),
                ],
              ),
              const Spacer(),

              // 🔹 Buttons (Reset / Apply)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Reset",
                        style: TextStyle(color: Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    onPressed: () {},
                    child: const Text("Apply",
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper Widgets
  static Widget _buildColorCircle(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 30,
      height: 30,
      decoration:
      BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2))
      ]),
    );
  }

  static Widget _buildStarButton(String text, bool selected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: selected ? Colors.white : Colors.black, fontSize: 14),
      ),
    );
  }

  static Widget _buildDiscountChip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.black26),
      ),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () {},
    );
  }
}
