import 'package:flutter/material.dart';

class ResumeBottomNav extends StatelessWidget {
  final int currentIndex;

  const ResumeBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.description), label: 'CV'),
      ],
      onTap: (index) {
        if (index == 0) {
          // Navigate to Personal Info screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/personal_info',
            (route) => false,
          );
        } else if (index == 1) {
          // Navigate to CV screen
          Navigator.pushNamedAndRemoveUntil(context, '/cv', (route) => false);
        }
      },
      backgroundColor: Colors.indigo,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.5),
    );
  }
}
