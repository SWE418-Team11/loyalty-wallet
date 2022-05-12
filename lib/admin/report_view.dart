import 'package:flutter/material.dart';
import 'package:loyalty_wallet/models/report_data.dart';

class ReportView extends StatelessWidget {
  const ReportView({Key? key, required this.report}) : super(key: key);
  final ReportData report;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Report'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                color: report.viewed ? Colors.grey[300] : Colors.grey[200],
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Report id: ${report.reportID}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('User id: ${report.userID}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Store id: ${report.storeId}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Store name: ${report.storeName}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Store name: ${report.reportType}'),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Desctiption:\n${report.reportContent}'),
                ],
              )),
        ),
      ),
    );
  }
}
