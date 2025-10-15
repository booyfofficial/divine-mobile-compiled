// ABOUTME: AppShell widget providing bottom navigation bound to URL
// ABOUTME: currentIndex derived from URL, onTap navigates to canonical tab paths

import 'package:flutter/material.dart';
import 'package:openvine/theme/vine_theme.dart';

/// App shell with bottom navigation bar
/// URL determines active tab, tab taps navigate to canonical routes
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTap,
  });

  final Widget child;
  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: VineTheme.vineGreen,
        selectedItemColor: VineTheme.whiteText,
        unselectedItemColor: VineTheme.whiteText.withValues(alpha: 0.6),
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tag),
            label: 'Tags',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
