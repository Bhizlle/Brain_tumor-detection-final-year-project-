import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/scan.dart';
import 'pages/history.dart';
import 'pages/learn.dart';
import 'pages/settings.dart';
import 'package:provider/provider.dart';
import 'pages/ThemeManager.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    return MaterialApp(
      title: 'Brain Tumor Detection',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeManager.currentTheme,
      home: MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
  }

  void _updateStatsAndRefresh() {
    setState(() {}); // Rebuilds HomePage with updated AppStats
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage(); // Always build a new HomePage
      case 1:
        return ScanPage(onScanComplete: _updateStatsAndRefresh);
      case 2:
        return HistoryPage();
      case 3:
        return LearnPage();
      case 4:
        return SettingsPage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}