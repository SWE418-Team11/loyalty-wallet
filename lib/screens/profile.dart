import 'package:flutter/material.dart';
import 'package:loyalty_wallet/admin/delete%20store.dart';
import 'package:loyalty_wallet/admin/reports_list.dart';
import 'package:loyalty_wallet/admin/unban_user.dart';
import 'package:loyalty_wallet/business_owner/create_store.dart';
import 'package:loyalty_wallet/cashier/operations_screen.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/user/start_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import '../admin/ban_user.dart';
import '../business_owner/special_offer_screen.dart';
import '../database_models/cahsier_database.dart';
import '../models/user_data.dart';
import '../user/banner_rent_screen.dart';
import '../user/notifications.dart';
import 'delete_account.dart';
import 'package:loyalty_wallet/admin/business_Owner_List.dart';

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
        future: CashierDatabase.isCashier(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String storeID = snapshot.data as String;
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
                                  const SizedBox(height: 5),
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
                              await CloudDatabase.signOut().then((value) =>
                                  Navigator.pushReplacementNamed(
                                      context, StartScreen.id));

                              setState(() {
                                inAsyncCall = false;
                              });
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
                        text: 'Notifications',
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Notifications(),
                            ),
                          );
                        },
                      ),

                      ProfileButton(
                        text: 'Contact US',
                        function: () {},
                      ),
                      //General Section
                      const SizedBox(height: 40),
                      const Text(
                        'Business Owner',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                      user!.businessOwner
                          ? ProfileButton(
                              function: () async {
                                await launch("https://wa.me/+966555555555",
                                    forceSafariVC: true, forceWebView: true);
                              },
                              text: 'Conact Admin')
                          : const SizedBox(),
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
                          : const SizedBox(),
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
                          : const SizedBox(),

                      user.businessOwner
                          ? ProfileButton(
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SpecialOfferScreen(
                                        businessOwnerID: user.id),
                                  ),
                                );
                              },
                              text: 'Make Special Offer')
                          : const SizedBox(),
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
                          ? const SizedBox(height: 40)
                          : const SizedBox(),
                      user.admin
                          ? const Text(
                              'Admin',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.start,
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
                          : const SizedBox(),
                      user.admin
                          ? ProfileButton(
                              text: 'Contact Business Owners',
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BOList(),
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),
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
                          : const SizedBox(),
                      user.admin
                          ? ProfileButton(
                              text: 'Delete Store',
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const DeleteStoreAccount(),
                                  ),
                                );
                              },
                            )
                          : const SizedBox(),

                      const SizedBox(
                        height: 40,
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
