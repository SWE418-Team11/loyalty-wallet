import 'package:flutter/material.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';

import '../models/store.dart';

class ReportToAdmin extends StatefulWidget {
  const ReportToAdmin({required this.store, Key? key, required this.bo})
      : super(key: key);
  final Store store;
  final bool bo;

  @override
  _ReportToAdminState createState() => _ReportToAdminState();
}

class _ReportToAdminState extends State<ReportToAdmin> {
  var reportTypes = ['type1', 'type2', 'type3'];
  var boReportTypes = ['BO type1', 'BO type2', 'BO type3'];
  late String reportTypeV;

  @override
  void initState() {
    super.initState();
    if (widget.bo) {
      reportTypes = boReportTypes;
    }
    reportTypeV = reportTypes.first;
  }

  final TextEditingController _reportContent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Store store = widget.store;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Report a Store'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Please fill the Form Below To Submit Your Reoport',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Store Name",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: size.width,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          color: const Color(0xfff9f9f9),
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        store.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Type of Report",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xfff9f9f9),
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          items: reportTypes.map((String reportType) {
                            return DropdownMenuItem(
                              value: reportType,
                              child: Text(reportType),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              reportTypeV = newValue!;
                            });
                          },
                          icon: const Icon(Icons.arrow_drop_down),
                          value: reportTypeV,
                          hint: const Text('Please Choose A Type'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Describe The Problem',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _reportContent,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Please Describe Your Problem...',
                          fillColor: Color(0xfff9f9f9)),
                      minLines: 6,
                      maxLines: null,
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        CloudDatabase.reportToAdmin(
                            store: store,
                            reportType: reportTypeV,
                            reportContent: _reportContent.value.text);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xff00AF91),
                        minimumSize: const Size(200, 40),
                      ),
                      child: const Text(
                        'Submit Report',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
