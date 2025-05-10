import 'package:flutter/material.dart';
import 'package:sugarsense/features/home/presentation/pages/home_page.dart';
import 'package:sugarsense/features/logs/presentation/pages/logs.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  __MainWrapperState createState() => __MainWrapperState();
}

class __MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomePage(), Logs()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'Logs'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
