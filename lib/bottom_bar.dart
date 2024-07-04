import 'package:admin/Screen/home/home_screen.dart';
import 'package:admin/Screen/menu/list_menu.dart';
import 'package:admin/Screen/profile/profile.dart';
import 'package:admin/color.dart';
import 'package:admin/Screen/kategori/list_kategori.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  final int toPage;

  const BottomBar({super.key, this.toPage = 0});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  List<Widget> screens = [
    HomePage(),
    ListMenu(),
    ListKategori(),
    Scaffold(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.toPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(35),
              topLeft: Radius.circular(35),
            ),
            color: primaryColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.home, "Home", 0),
                _buildNavItem(Icons.food_bank_outlined, "Food", 1),
                _buildNavItem(Icons.grid_view_outlined, "Grid", 2),
                _buildNavItem(Icons.shopping_bag_outlined, "Shop", 3),
                _buildNavItem(Icons.person, "Profile", 4),
              ],
            ),
          )),
      body: screens[currentIndex],
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentIndex = index;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: (currentIndex == index)
                  ? EdgeInsets.all(8)
                  : EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(0, 0, 0, 0),
                  shape: BoxShape.circle),
              child: Icon(
                icon,
                size: (currentIndex == index) ? 35 : 30,
                color: currentIndex == index
                    ? primaryColor
                    : const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            (currentIndex == index)
                ? SizedBox()
                : Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
