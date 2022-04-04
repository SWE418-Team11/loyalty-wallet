// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/user/payment_page.dart';
import '../constants.dart';
import '../database_models/buisness_owner_database.dart';

class RentBanner extends StatefulWidget {
  const RentBanner({Key? key}) : super(key: key);

  @override
  State<RentBanner> createState() => _RentBannerState();
}

class _RentBannerState extends State<RentBanner> {
  final ImagePicker _picker = ImagePicker();
  XFile? _rentBanner;

  Future<void> choseBanner() async {
    var banner = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _rentBanner = banner;
    });
  }

  @override
  Widget build(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Request Submitted Sucessfully"),
      content: Text("Your Request is in Pending until Confirmation"),
      actions: [
        TextButton(
            onPressed: () {
              int count = 0;
              Navigator.of(context).popUntil((route) => count++ >= 2);
            },
            child: Text("Return"))
      ],
      elevation: 10,
    );
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    Size size = MediaQuery.of(context).size;
    Map<String, String> _rentPlan = {'planDuration': '', 'price': ''};

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text("Rent Banner"),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: users.doc(uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                Map<String, dynamic> rentBanner = data['rentBanner'];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(30),
                          margin: EdgeInsets.all(5),
                          child: Text(
                            "Upload Image",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            choseBanner();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              width: size.width,
                              height: size.height / 4,
                              color: Colors.grey,
                              child: _rentBanner == null
                                  ? Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: size.height / 4.5,
                                      color: Colors.white,
                                    )
                                  : Image.file(
                                      File(_rentBanner!.path),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ExpansionTile(
                        title: Center(
                            child: Text(
                          "       Choose Rent Plan", //Modern Problems requires modern Solutions :p
                          style: TextStyle(fontSize: 25, color: kMainColor),
                        )),
                        trailing: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.transparent,
                        ),
                        childrenPadding: EdgeInsets.only(left: 10, right: 10),
                        children: [
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: kMainColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "150 SR for 1 Week",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: kMainColor),
                              )),
                            ),
                            onTap: () async {
                              _rentPlan['planDuration'] = 'One Week';
                              _rentPlan['price'] = '150';
                              rentBanner['duration'] =
                                  _rentPlan['planDuration'];
                              rentBanner['price'] = _rentPlan['price'];
                              rentBanner['banner'] = '${_rentBanner?.path}';
                              await BusinessOwnerDatabase.bannerRequest(
                                      rentBanner, uid)
                                  .whenComplete(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Payment(type: "Rent Banner")));
                              });
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: kMainColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "250 SR for 2 Week",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: kMainColor),
                              )),
                            ),
                            onTap: () async {
                              _rentPlan['planDuration'] = 'Two Weeks';
                              _rentPlan['price'] = '250';
                              rentBanner['duration'] =
                                  _rentPlan['planDuration'];
                              rentBanner['price'] = _rentPlan['price'];
                              rentBanner['banner'] = '${_rentBanner?.path}';
                              await BusinessOwnerDatabase.bannerRequest(
                                      rentBanner, uid)
                                  .whenComplete(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Payment(type: "Rent Banner")));
                              });
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: kMainColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "500 SR for 1 Month",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: kMainColor),
                              )),
                            ),
                            onTap: () async {
                              _rentPlan['planDuration'] = 'One Month';
                              _rentPlan['price'] = '500';
                              rentBanner['duration'] =
                                  _rentPlan['planDuration'];
                              rentBanner['price'] = _rentPlan['price'];
                              rentBanner['banner'] = '${_rentBanner?.path}';

                              await BusinessOwnerDatabase.bannerRequest(
                                      rentBanner, uid)
                                  .whenComplete(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Payment(type: "Rent Banner")));
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              return Text("");
            }));
  }
}
