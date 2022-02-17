import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/screens/explore.dart';
import 'package:loyalty_wallet/screens/profile.dart';
import 'package:loyalty_wallet/screens/wallet.dart';

import '../models/user_data.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({required this.user, Key? key}) : super(key: key);
  final UserData user;
  static String id = 'Customer Main Screen';

  @override
  _CustomerMainScreenState createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    //Todo: take it out so it doesnt consume data
    List<Widget> _pages = <Widget>[
      WalletScreen(),
      ExploreScreen(),
      ProfileScreen(user: widget.user),
    ];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(_selectedIndex == 0
              ? 'My Wallet'
              : _selectedIndex == 1
                  ? 'Explore'
                  : 'Profile'),
          centerTitle: true,
        ),
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kMainColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_outlined),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
