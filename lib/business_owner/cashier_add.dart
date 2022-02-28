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

class AddCashier extends StatefulWidget {
  const AddCashier({Key? key, required this.store, required this.cashlist})
      : super(key: key);
  final Store store;
  final Map<String, dynamic> cashlist;
  @override
  State<AddCashier> createState() => _AddCashierState();
}

class _AddCashierState extends State<AddCashier> {
  @override
  final TextEditingController _cashierController = TextEditingController();

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Store store = widget.store;
    Map<String, dynamic> cashmap = widget.cashlist;
    List<dynamic> cashList = cashmap['cashierList'];
    String? storeID = store.id;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Cashier"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(
                  height: 90,
                ),
                const Text(
                  'Enter Cashier Phone Number',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: size.width,
                  child: TextFormField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: _cashierController,
                    decoration: kTexFieldDecoration.copyWith(
                        hintText: 'e.g 05xxxxxxxx'),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  child: Container(
                    height: 65,
                    width: 250,
                    decoration: BoxDecoration(
                        color: kMainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text("Add Cashier",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400))),
                  ),
                  onTap: () async {
                    if (_cashierController.value.text.isEmpty ||
                        _cashierController.value.text.length < 10)
                      return; // add alertdialog
                    await CloudDatabase.addNewCashier(
                            _cashierController.value.text, storeID!, cashList)
                        .whenComplete(() {
                      int count = 0;
                      Navigator.of(context).popUntil((route) => count++ >= 3);
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
