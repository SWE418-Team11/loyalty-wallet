import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/models/report_data.dart';

import '../database_models/admin_database.dart';
import 'admin_report_screen.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({Key? key}) : super(key: key);

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('report list'),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Report List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: AdminDatabase.getReports(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<ReportData> reports =
                        snapshot.data as List<ReportData>;
                    return ListView.separated(
                      itemCount: reports.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 20,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            AdminDatabase.updateReportStatus(
                                id: reports[index].reportID);
                            //Todo:here
                            //go to report details
                            Map<String, dynamic> reportDetails = {
                              'reportContent': reports[index].reportContent,
                              'reportType': reports[index].reportType,
                              'storeName': reports[index].storeName,
                              'userID': reports[index].userID
                            };
                            String reportID = reports[index].reportID;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Report(
                                  report: reportDetails,
                                  index: index,
                                  reportID: reportID,
                                ),
                              ),
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           ReportView(report: reports[index])),
                            // );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: reports[index].viewed
                                  ? Colors.grey[300]
                                  : Colors.grey[100],
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
                            height: 50,
                            child: Text(reports[index].reportContent),
                          ),
                        );
                      },
                    );
                  } else {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Text(
            //   'Total Number of reports $count',
            //   style: const TextStyle(fontWeight: FontWeight.bold),
            // )
          ],
        ),
      ),
    );
  }
}
