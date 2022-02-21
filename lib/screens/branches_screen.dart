import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({Key? key, required this.locations}) : super(key: key);
  final List<dynamic> locations;
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
                );
              })),
    );
  }
}
