import 'package:ap_news/view/bottom_navbar.dart';
import 'package:ap_news/view/election_result_screen.dart';
import 'package:ap_news/view/news_shorts_screen.dart';
import 'package:ap_news/view/premium_screen.dart';
import 'package:ap_news/view/read_screen.dart';
import 'package:ap_news/view/watch_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ApNewsApp());
}

class ApNewsApp extends StatelessWidget {
  const ApNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ap News',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      const ReadScreen(),
      const WatchScreen(),
      const PremiumScreen(),
      const ElectionResultScreen(),
      const NewsShortsScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NewsBottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
