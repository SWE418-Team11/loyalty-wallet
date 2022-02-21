import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/add_branch_screen.dart';
import 'package:loyalty_wallet/business_owner/buisness_owner_store_screen.dart';
import 'package:loyalty_wallet/business_owner/create_store.dart';
import 'package:loyalty_wallet/business_owner/scoial_media_links_screen.dart';
import 'package:loyalty_wallet/constants.dart';

import '../models/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.user, Key? key}) : super(key: key);
  final UserData? user;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    UserData? user = widget.user;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                    ),
                    const SizedBox(width: 5),
                    Column(
                      children: [
                        Text('${user?.firstName} ${user?.lastName}'),
                        SizedBox(height: 5),
                        Text('${user?.phoneNumber.toString()}'),
                      ],
                    ),
                  ],
                ),
                OutlinedButton(
                  child: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kMainColor)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            //Personal Section
            const Text(
              'Personal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.start,
            ),
            ProfileButton(
              text: 'Profile',
              function: () {},
            ),
            ProfileButton(
              text: 'Password',
              function: () {},
            ),
            ProfileButton(
              text: 'Contact Info',
              function: () {},
            ),
            //General Section
            const SizedBox(height: 40),
            const Text(
              'General',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              textAlign: TextAlign.start,
            ),
            user!.businessOwner
                ? ProfileButton(
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessOwnerStoreScreen(),
                        ),
                      );
                    },
                    text: 'Stores')
                : SizedBox(),
            user.businessOwner
                ? ProfileButton(
                    function: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateStore(),
                        ),
                      );
                    },
                    text: 'Create Store')
                : SizedBox(),

            ProfileButton(
              text: 'Point History',
              function: () {},
            ),
            ProfileButton(
              text: 'Search History',
              function: () {},
            ),
            ProfileButton(
              text: 'Contact Us',
              function: () {},
            ),
            ProfileButton(
              text: 'Help',
              function: () {},
            ),
            ProfileButton(
              text: 'Delete Account',
              function: () {},
              color: const Color(0xffF25252),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    required this.function,
    required this.text,
    this.color,
    Key? key,
  }) : super(key: key);
  final Function()? function;
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: function,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                text,
                style: TextStyle(
                    color: color ?? Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        const Divider(
          height: 0,
          thickness: 2,
        )
      ],
    );
  }
}
