import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_app/resumer/boarding.dart';
import 'package:my_app/resumer/cv.dart';
import 'package:my_app/resumer/page_one.dart';
import 'package:my_app/resumer/page_two.dart';
import 'package:my_app/resumer/page_three.dart';

class FillForm extends ConsumerStatefulWidget {
  const FillForm({super.key});

  @override
  ConsumerState<FillForm> createState() => _FillFormState();
}

class _FillFormState extends ConsumerState<FillForm> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  // Map page index to bottom nav index
  int _getBottomNavIndex() {
    // Pages 0-3 (Boarding, Personal, Education, Experience) → Home (0)
    // Page 4 (CV) → CV (1)
    return _currentPageIndex >= 4 ? 1 : 0;
  }

  void _onBottomNavTapped(int navIndex) {
    // Logic removed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getBottomNavIndex(),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'CV'),
        ],
        onTap: _onBottomNavTapped,
        backgroundColor: Colors.indigo,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          const BoardingScreen(),
          const ScreenOne(),
          const ScreenTwo(),
          const ScreenThree(),
          const MyCvScreen(),
        ],
      ),
    );
  }
}
