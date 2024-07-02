import 'package:admin/Screen/home/home_screen.dart';
import 'package:admin/color.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int cuttentIndex = 0;
  List screens = const [
    HomePage(),
    Scaffold(),
    Scaffold(),
    Scaffold(),
    Scaffold(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 70,
        color: primaryColor,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Atur sesuai kebutuhan
          ),
        ),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: cuttentIndex == 0
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(0, 0, 0, 0),
                  shape: BoxShape.circle),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.all(
                      8), // Pastikan padding IconButton diatur ke nol
                  constraints: BoxConstraints(),
                  onPressed: () {
                    setState(() {
                      cuttentIndex = 0;
                    });
                  },
                  icon: Icon(
                    Icons.home,
                    size: 30,
                    color: cuttentIndex == 0
                        ? primaryColor
                        : const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: cuttentIndex == 1
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(0, 0, 0, 0),
                  shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 1;
                  });
                },
                icon: Icon(
                  Icons.food_bank_outlined,
                  size: 30,
                  color: cuttentIndex == 1
                      ? primaryColor
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: cuttentIndex == 2
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(0, 0, 0, 0),
                  shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 2;
                  });
                },
                icon: Icon(
                  Icons.grid_view_outlined,
                  size: 30,
                  color: cuttentIndex == 2
                      ? primaryColor
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: cuttentIndex == 3
                      ? Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(0, 0, 0, 0),
                  shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 3;
                  });
                },
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                  color: cuttentIndex == 3
                      ? primaryColor
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: cuttentIndex == 4
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : const Color.fromARGB(0, 0, 0, 0),
                  shape: BoxShape.circle),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 4;
                  });
                },
                icon: Icon(
                  Icons.person,
                  size: 30,
                  color: cuttentIndex == 4
                      ? primaryColor
                      : const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
      body: screens[cuttentIndex],
    );
  }
}
