// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/report_data.dart';
import 'package:loyalty_wallet/models/user_data.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';

class ReplyToReport extends StatefulWidget {
  const ReplyToReport({Key? key, required this.reportID}) : super(key: key);
  final String reportID;
  @override
  State<ReplyToReport> createState() => _ReplyToReportState();
}

class _ReplyToReportState extends State<ReplyToReport> {
  TextEditingController _reportContent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    String reportID = widget.reportID;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: Text("Reply"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          margin: EdgeInsets.only(top: 35, right: 20, left: 20),
          child: Column(
            children: [
              Text(
                "Enter your Reply",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _reportContent,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Message...',
                    fillColor: Color(0xfff9f9f9)),
                minLines: 6,
                maxLines: null,
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                child: Container(
                  height: 45,
                  width: 200,
                  decoration: BoxDecoration(
                    color: kMainColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 1,
                        color: Colors.black12,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Center(
                      child: Text(
                    "Send Reply",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  )),
                ),
                onTap: () async {
                  await CloudDatabase.sendReply(reportID, _reportContent.text)
                      .whenComplete(() {
                    int count = 0;
                    Navigator.of(context).popUntil((route) => count++ >= 2);
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
