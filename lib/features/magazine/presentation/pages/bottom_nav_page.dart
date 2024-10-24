import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magspot/core/common/cubits/app_user/app_user_cubit.dart';
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
    final user = context.read<AppUserCubit>().state as AppUserLoggedIn;
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
      floatingActionButton: BlocBuilder<AppUserCubit, AppUserState>(
        builder: (context, state) {
          return user.user.type == 'admin'
              ? FloatingActionButton(
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
                )
              : const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
