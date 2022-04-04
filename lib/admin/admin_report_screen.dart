// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore: prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:loyalty_wallet/admin/admin_report_reply_screen.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/report_data.dart';
import 'package:loyalty_wallet/models/user_data.dart';

class Report extends StatefulWidget {
  const Report(
      {Key? key,
      required this.report,
      required this.index,
      required this.reportID})
      : super(key: key);
  final Map<String, dynamic> report;
  final int index;
  final String reportID;
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int index = widget.index;
    Map<String, dynamic> report = widget.report;
    String reportID = widget.reportID;
    return Scaffold(
        appBar: AppBar(
          title: Text("Report #${index + 1}"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: screenWidth - 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 2,
                    spreadRadius: 0.5,
                    color: Colors.black12,
                    offset: Offset(0.5, 1),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(top: 20, bottom: 20),
              padding:
                  EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User: ${report["userID"]}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Store Name: ${report["storeName"]}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Report Type: ${report["reportType"]}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 60,
                  ),
                  Text("Report Message: \n ${report["reportContent"]}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Center(
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 15),
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
                          "Reply",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        )),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReplyToReport(
                              reportID: reportID,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
