import 'package:flutter/material.dart';
import 'package:loyalty_wallet/admin/reports_list.dart';
import 'package:loyalty_wallet/admin/unban_user.dart';
import 'package:loyalty_wallet/business_owner/add_branch_screen.dart';
import 'package:loyalty_wallet/business_owner/buisness_owner_store_screen.dart';
import 'package:loyalty_wallet/business_owner/choose_plan.dart';
import 'package:loyalty_wallet/business_owner/create_store.dart';
import 'package:loyalty_wallet/business_owner/scoial_media_links_screen.dart';
import 'package:loyalty_wallet/cashier/operations_screen.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/models/cloud_batabase.dart';
import 'package:loyalty_wallet/user/start_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../admin/ban_user.dart';
import '../models/user_data.dart';
import '../user/banner_rent_screen.dart';
import 'delete_account.dart';
// import 'package:loyalty_wallet/business_owner/rent_banner_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.user, Key? key}) : super(key: key);
  final UserData? user;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool inAsyncCall = false;
  String storeID = 'empty';

  @override
  Widget build(BuildContext context) {
    UserData? user = widget.user;
    return FutureBuilder(
        future: CloudDatabase.isCashier(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String storeID = snapshot.data as String;
            print(storeID);
            return ModalProgressHUD(
              inAsyncCall: inAsyncCall,
              child: SingleChildScrollView(
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
                            onPressed: () async {
                              setState(() {
                                inAsyncCall = true;
                              });
                              await CloudDatabase.signOut();
                              setState(() {
                                inAsyncCall = false;
                              });
                              Navigator.pushReplacementNamed(
                                  context, StartScreen.id);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      //Personal Section
                      const Text(
                        'Personal',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                      user!.businessOwner
                          ? ProfileButton(
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BusinessOwnerStoreScreen(),
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
                      user.businessOwner
                          ? ProfileButton(
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RentBanner(),
                                  ),
                                );
                              },
                              text: 'Rent Banner Advertisement')
                          : SizedBox(),

                      ProfileButton(
                        text: 'Point History',
                        function: () {},
                      ),
                      ProfileButton(
                        text: 'Search History',
                        function: () {},
                      ),
                      storeID != 'empty'
                          ? ProfileButton(
                              text: 'Cashier',
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OperationsScreen(),
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
                      user.admin
                          ? ProfileButton(
                              text: 'View Reports',
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ReportListScreen(),
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
                      user.admin
                          ? ProfileButton(
                              text: 'Ban User',
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BanUser(),
                                  ),
                                );
                              },
                            )
                          : SizedBox(),
                      user.admin
                          ? ProfileButton(
                              text: 'UnBan User',
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UnBan(),
                                  ),
                                );
                              },
                            )
                          : SizedBox(),
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
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DeleteAccount(user: user),
                            ),
                          );
                        },
                        color: const Color(0xffF25252),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: kMainColor),
            );
          }
        });
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
