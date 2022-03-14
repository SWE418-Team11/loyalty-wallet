// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/cashier_add.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/customer/report_to_admin.dart';
import 'package:loyalty_wallet/models/cloud_batabase.dart';
import '../models/store.dart';

class RemoveCashier extends StatefulWidget {
  const RemoveCashier({Key? key, required this.store, required this.cashlist})
      : super(key: key);
  final Store store;
  final Map<String, dynamic> cashlist;
  @override
  State<RemoveCashier> createState() => _RemoveCashierState();
}

class _RemoveCashierState extends State<RemoveCashier> {
  @override
  String? cashierNO = "";

  Widget build(BuildContext context) {
    Store store = widget.store;
    String? storeID = store.id;
    Map<String, dynamic> cashmap = widget.cashlist;
    List<dynamic> cashList = cashmap['cashierList'];
    String? valueChoice;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Remove Cashier"),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.only(top: 70),
            child: Column(
              children: [
                Text(
                  "Select Cashier Number to Remove",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50),
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: DropdownButtonFormField<dynamic>(
                    hint: Text("Select Number"),
                    value: valueChoice,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(width: 1))),
                    items: cashList.map((valueItem) {
                      return DropdownMenuItem(
                        child: Text(valueItem),
                        value: valueItem,
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() => valueChoice = newValue);
                      this.cashierNO = newValue;
                    },
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    height: 65,
                    width: 250,
                    decoration: BoxDecoration(
                        color: kOrangeColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text("Remove Cashier",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400))),
                  ),
                  onTap: () async {
                    if (cashierNO!.isEmpty) return;
                    await CloudDatabase.removeCashier(
                            cashierNO!, storeID!, cashList)
                        .whenComplete(() {
                      int count = 0;
                      Navigator.of(context).popUntil((route) => count++ >= 2);
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
