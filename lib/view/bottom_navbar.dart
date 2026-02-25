import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NewsBottomNavbar extends StatelessWidget {
  const NewsBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<GButton> _tabs = [
    GButton(icon: Icons.chrome_reader_mode_outlined, text: 'Read'),
    GButton(icon: Icons.videocam_outlined, text: 'Watch'),
    GButton(icon: Icons.auto_awesome_outlined, text: 'Premium'),
    GButton(icon: Icons.ballot_outlined, text: 'Elections'),
    GButton(icon: Icons.ondemand_video_outlined, text: 'Shorts'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEDEDED),
        border: Border(top: BorderSide(color: Color(0xFFDADADA))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            selectedIndex: currentIndex,
            onTabChange: onTap,
            gap: 6,
            iconSize: 22,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            tabBorderRadius: 12,
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 250),
            activeColor: const Color(0xFFD50000),
            color: const Color(0xFF6F6F6F),
            tabBackgroundColor: const Color(0x33D50000),
            textStyle: const TextStyle(
              color: Color(0xFFD50000),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            tabs: _tabs,
          ),
        ),
      ),
    );
  }
}
