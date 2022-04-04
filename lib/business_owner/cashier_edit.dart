// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/cashier_add.dart';
import 'package:loyalty_wallet/constants.dart';
import '../models/store.dart';
import 'package:loyalty_wallet/business_owner/cashier_remove.dart';

class EditCashier extends StatefulWidget {
  const EditCashier({Key? key, required this.store}) : super(key: key);
  final Store store;
  @override
  State<EditCashier> createState() => _EditCashierState();
}

class _EditCashierState extends State<EditCashier> {
  @override
  Widget build(BuildContext context) {
    Store store = widget.store;
    String? storeID = store.id;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    CollectionReference owners = FirebaseFirestore.instance.collection('Owner');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: Text("Edit Cashier"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: screenHeight / 4, left: screenWidth / 5),
          child: Column(
            children: [
              FutureBuilder(
                  future: owners.doc(storeID).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> cashlist =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Column(
                        children: [
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              height: 65,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: Text(
                                "Add Cashier",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              )),
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCashier(
                                    store: store,
                                    cashlist: cashlist,
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 15, bottom: 15),
                              height: 65,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: kOrangeColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  "Remove Cashier",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RemoveCashier(
                                    store: store,
                                    cashlist: cashlist,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Text("");
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
