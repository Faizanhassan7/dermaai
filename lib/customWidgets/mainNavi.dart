// import 'package:dermaai/veiws/historyScreen.dart';
// import 'package:dermaai/veiws/resultScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:dermaai/veiws/homeScreen.dart';
// import 'package:dermaai/veiws/scanScreen.dart';
// // import 'package:dermaai/veiws/historyScreen.dart';
// // import 'package:dermaai/veiws/profileScreen.dart';
//
// class MainNav extends StatefulWidget {
//   const MainNav({super.key});
//
//   @override
//   State<MainNav> createState() => _MainNavState();
// }
//
// class _MainNavState extends State<MainNav> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = const [
//     Homescreen(),
//     // Scanscreen(),
//      HistoryScreen(),
//     // Profilescreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: Clip
import 'package:dermaai/veiws/historyScreen.dart';
import 'package:dermaai/veiws/resultScreen.dart';
import 'package:dermaai/veiws/settingScreen.dart';
import 'package:flutter/material.dart';
import 'package:dermaai/veiws/homeScreen.dart';
import 'package:dermaai/veiws/scanScreen.dart';

class MainNav extends StatefulWidget {
  const MainNav({super.key});

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Homescreen(),
    // Scanscreen(),
    HistoryScreen(),
    SettingsScreen(),

    // Profilescreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Screen body
      body: _screens[_selectedIndex],

      // Modern VIP Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
          // borderRadius: const BorderRadius.only(
          //   topLeft: Radius.circular(5),
          //   topRight: Radius.circular(25),
          // ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.cyanAccent,
            unselectedItemColor: Colors.white70,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.document_scanner_outlined),
              //   label: 'Scan',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Setting',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

