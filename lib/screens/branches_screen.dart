import 'package:flutter/material.dart';
import 'package:loyalty_wallet/database_models/buisness_owner_database.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/store.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({Key? key, required this.locations, required this.store})
      : super(key: key);
  final List<dynamic> locations;
  final Store store;
  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    List<dynamic> locations = widget.locations;
    // [
    //   {
    //     'branchBanner':
    //         'https://www.caffebene-loyalty.com/assets/images/stores/IMG_Store1610870130.png',
    //     'location': 'https://goo.gl/maps/Saz1Wa4cgbUkcN1f8',
    //     'description':
    //         'KFUPM Mall, Dhahran,KFUPM Mall, Dhahran,KFUPM Mall, Dhahran,KFUPM Mall, Dhahran,KFUPM Mall, Dhahran'
    //   },
    //   {
    //     'branchBanner':
    //         'https://lh3.googleusercontent.com/ovaHV5c73_2wWZ77bq3fpAzaFMsocqiMjeUbCWyvRzUIZSkQmnyD9Xak9iukH-9R430u4gWbZn8LOITdDrd2FKM2LQQ=w512',
    //     'location': 'https://goo.gl/maps/poE2Kyam2FxcSAHm6',
    //     'description': 'Dhahran Mall, Dhahran',
    //   },
    //   {
    //     'branchBanner':
    //         'https://img.jakpost.net/c/2016/09/14/2016_09_14_11905_1473852812._large.jpg',
    //     'location': 'https://goo.gl/maps/sas5SxTthC5627HUA',
    //     'description': 'Rashid Mall, Khobar',
    //   },
    //   {
    //     'branchBanner':
    //         'https://img.jakpost.net/c/2016/09/14/2016_09_14_11905_1473852812._large.jpg',
    //     'location': 'https://goo.gl/maps/sas5SxTthC5627HUA',
    //     'description': 'Rashid Mall, Khobar',
    //   }
    // ];

    Future doneAlert(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (BuildContext dialogcontext) {
            return AlertDialog(
              content: const Text(
                'The Store Is Deleted Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogcontext);
                  },
                  child: const Text('DONE'),
                ),
              ],
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        //Todo: improve the performance whenever go back
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Branches"),
          backgroundColor: kMainColor,
        ),
        body: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, int index) {
            return InkWell(
              child: Container(
                //padding: EdgeInsets.all(10),

                // height: size.height / 4.33,
                width: size.width - 20,
                margin: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white, width: 0)),
                child: Column(
                  children: [
                    Container(
                      height: 130,
                      width: size.width - 20,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  locations[index]['branchBanner']),
                              fit: BoxFit.fill)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width / 1.5,
                          child: Text(
                            locations[index]['description'],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const ImageIcon(
                          AssetImage('images/google Maps.png'),
                          color: kOrangeColor,
                          size: 35,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              onTap: () async {
                await launch(locations[index]['location'],
                    forceSafariVC: true, forceWebView: true);
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext dialogcontext) {
                      return AlertDialog(
                        content: const Text(
                          'are you sure you want to delete this Branch Location?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                        ),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                ),
                                child: const Text('DELETE'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await BusinessOwnerDatabase.deleteBranch(
                                      index, widget.store);
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.grey,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(dialogcontext);
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          )
                        ],
                      );
                    });
              },
            );
          },
        ),
      ),
    );
  }
}
