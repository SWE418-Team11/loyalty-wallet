import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/add_branch_screen.dart';
import 'package:loyalty_wallet/business_owner/cancel_plan.dart';
import 'package:loyalty_wallet/business_owner/computation_points_screen.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/customer/report_to_admin.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:url_launcher/url_launcher.dart';

import '../business_owner/cashier_list.dart';
import '../business_owner/customers_screen.dart';
import '../database_models/buisness_owner_database.dart';
import '../models/menu.dart';
import '../models/store.dart';
import '../screens/branches_screen.dart';

class CustomerStoreScreen extends StatefulWidget {
  const CustomerStoreScreen({Key? key, required this.store}) : super(key: key);
  final Store store;

  @override
  _CustomerStoreScreenState createState() => _CustomerStoreScreenState();
}

class _CustomerStoreScreenState extends State<CustomerStoreScreen> {
  @override
  Widget build(BuildContext context) {
    Store store = widget.store;
    final String _storeBackground =
        store.storeBanner; // Store Page Background Location, delete Link later
    final String _storeLogo =
        store.storeIcon; // Store Logo Image Location, Delete Link Later
    String storeName = store.name;
    String desc = store.description;
    String instagram = store.socialMedia['instagram']; // Instagram Account ID
    String snapchat = store.socialMedia['snapchat']; // snapchat Account ID
    String twitter = store.socialMedia['twitter']; // twitter Account ID
    String facebook = store.socialMedia['facebook']; // facebook Account ID
    List<dynamic> locations =
        store.locations; // Store Location using Google Maps
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenSpace = screenWidth * screenHeight;
    final avatarDiameter = sqrt(0.020 * screenSpace);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                // Store Banner
                Container(
                  height: screenHeight * .17,
                  width: screenWidth * 1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(_storeBackground),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  ), // Blur Effect to the Background
                ),
                //go back arrow
                Row(
                  children: [
                    IconButton(
                        // Back Arrow Button
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(
                                context); // to navigate to previous Screen (I dont know if this is the right way...)
                          });
                        }),
                  ],
                ),
                //Store Logo
                Container(
                  height: avatarDiameter,
                  width: avatarDiameter,
                  margin: EdgeInsets.only(
                      top: screenHeight * .14, left: screenWidth * .08),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      //borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      shape: BoxShape.circle,
                      border: Border.all(color: kMainColor, width: 1),
                      image: DecorationImage(
                          image: NetworkImage(_storeLogo), fit: BoxFit.fill)),
                ),
                //Row of buttons
                Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * .175, left: screenWidth * 0.5),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            //Todo: add branches screen here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BranchesScreen(
                                  store: store,
                                  locations: locations,
                                ),
                              ),
                            );
                            // await launch(googleMaps,
                            //     forceSafariVC: true, forceWebView: true);
                          },
                          icon: const Icon(
                            Icons.location_on,
                            color: kMainColor,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {
                            CloudDatabase.toggleNotification(
                                storeID: store.id ?? '');
                          },
                          icon: const Icon(Icons.notifications_active,
                              color: kMainColor, size: 30)),
                      IconButton(
                          onPressed: () async {
                            await CloudDatabase.addCard({
                              'cardType': 'points',
                              'storeID': store.id,
                              'storeName': storeName,
                              'total': 0,
                              'transactions': [],
                              'isNotificationOn': false,
                            }).whenComplete(() {
                              const ScaffoldMessenger(
                                child: SnackBar(
                                  content: Text('Card Has been Added'),
                                ),
                              );
                            });
                          },
                          icon: const Icon(Icons.card_membership_rounded,
                              color: kMainColor, size: 30)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportToAdmin(
                                  store: store,
                                  bo: false,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.report_problem_outlined,
                              color: kMainColor, size: 30))
                    ],
                  ),
                ),
                FutureBuilder(
                    future: BusinessOwnerDatabase.isTheOwner(store.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        bool isTheOwner = snapshot.data as bool;

                        return isTheOwner
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: screenHeight * .24,
                                    left: screenWidth * 0.265),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          //Todo: add branches screen here
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CashierList(store: store),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.person_add_alt_1,
                                          color: kMainColor,
                                          size: 30,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          //Todo: add branches screen here
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AddBranchScreen(
                                                      storeData: null,
                                                      isNew: false,
                                                      store: store),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_location_alt,
                                          color: kMainColor,
                                          size: 30,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ComputationPointsScreen(
                                                      isNew: false,
                                                      store: store,
                                                      data: const {}, //this field meant to createing new store
                                                    )),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.point_of_sale_outlined,
                                            color: kMainColor,
                                            size: 30)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CancelPlan(store: store)),
                                          );
                                        },
                                        icon: const Icon(Icons.cancel,
                                            color: kMainColor, size: 30)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyCostumersScreen(
                                                      store: store,
                                                    )),
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.supervisor_account_sharp,
                                            color: kMainColor,
                                            size: 30)),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportToAdmin(
                                                      store: store,
                                                      bo: true,
                                                    )),
                                          );
                                        },
                                        icon: const Icon(Icons.report_problem,
                                            color: kMainColor, size: 30)),
                                  ],
                                ),
                              )
                            : const SizedBox();
                      } else {
                        return const SizedBox();
                      }
                    })
              ],
            ),
            // Store Name and Description
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(
                  top: 20, left: 35, bottom: 10, right: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // Menu Expandable List
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(
                  top: 10, left: 35, bottom: 20, right: 35),
              child: const Text(
                "Menu",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
            ),
            Column(
              // expandable list
              children: [
                FutureBuilder(
                    future: CloudDatabase.getMenu(id: store.menuID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Menu menu = snapshot.data as Menu;
                        List<dynamic> products = menu.products;
                        return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ExpansionTile(
                                // Category Expandalbe list item (expansion tile)
                                expandedAlignment: Alignment.topLeft,
                                tilePadding:
                                    const EdgeInsets.only(left: 35, right: 35),
                                title: Text(products[index]
                                    ['category']), // Category Name
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 35, right: 35, bottom: 10),
                                    child: ProductsGrid(
                                        products: products[index]['products']),
                                  )
                                ],
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: kMainColor,
                          ),
                        );
                      }
                    })
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // ######################################################## Icons are Placeholder until proper Icons added.
                  SocialMediaButton(
                      url: "https://www.instagram.com/$instagram",
                      icon: 'images/instagram_icon.png'),
                  SocialMediaButton(
                    url: 'https://www.snapchat.com/add/$snapchat',
                    icon: 'images/snapchat_icon.png',
                  ),
                  SocialMediaButton(
                      url: 'https://www.twitter.com/$twitter',
                      icon: 'images/twitter_icon.png'),
                  SocialMediaButton(
                      url: 'https://www.facebook.com/$facebook',
                      icon: 'images/facebook_icon.png'),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    required this.products,
    Key? key,
  }) : super(key: key);
  final List<dynamic> products;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 15,
          mainAxisExtent: MediaQuery.of(context).size.width / 2,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      width: size.width / 3.5,
                      height: size.width / 3,
                      child: Image.network(
                        products[index]['image'],
                        fit: BoxFit.scaleDown,
                      )),
                  Flexible(
                    child: Text(
                      products[index]['productName'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Text(
                    products[index]['price'].toString(),
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(
                  color: kMainColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
          );
        });
  }
}

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({
    Key? key,
    required this.url,
    required this.icon,
  }) : super(key: key);

  final String url;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await launch(url, forceSafariVC: true, forceWebView: true);
      },
      icon: Image.asset(icon),
    );
  }
}
