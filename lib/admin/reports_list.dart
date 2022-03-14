import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/report_data.dart';

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
                future: CloudDatabase.getReports(),
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
                          onTap: () {
                            //go to report details
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
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
