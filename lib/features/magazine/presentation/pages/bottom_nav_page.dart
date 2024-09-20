import 'package:flutter/material.dart';
import 'package:magspot/core/theme/app_pallete.dart';
import 'package:magspot/features/magazine/presentation/pages/magazine_add_page.dart';
import 'package:magspot/features/magazine/presentation/pages/magazine_page.dart';
import 'package:magspot/features/profile/presentation/pages/profile_page.dart';

class BottomNavPage extends StatefulWidget {
  const BottomNavPage({super.key});

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int _selectedIndex = 0;
  List<Widget> pages = [MagazinePage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppPallete.gradient4,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppPallete.backgroundColor,
        backgroundColor: AppPallete.gradient4,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MagazineAddPage(),
              ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
