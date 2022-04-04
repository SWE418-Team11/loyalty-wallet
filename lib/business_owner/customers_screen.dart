import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/database_models/buisness_owner_database.dart';
import 'package:loyalty_wallet/models/my_customer_data.dart';

import '../models/store.dart';

class MyCostumersScreen extends StatefulWidget {
  const MyCostumersScreen({Key? key, required this.store}) : super(key: key);
  final Store store;

  @override
  State<MyCostumersScreen> createState() => _MyCostumersScreenState();
}

class _MyCostumersScreenState extends State<MyCostumersScreen> {
  List<TableRow> rows = [];

  @override
  Widget build(BuildContext context) {
    rows = [];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text('${widget.store.name}\'s Customers'),
            centerTitle: true),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: FutureBuilder(
              future: BusinessOwnerDatabase.getStoreCustomers(
                  storeID: widget.store.id!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MyCustomerData> myCustomers =
                      snapshot.data as List<MyCustomerData>;
                  addRows(customers: myCustomers);
                  return Column(
                    children: [
                      Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(1)
                        },
                        border: TableBorder.all(
                            color: kMainColor,
                            style: BorderStyle.solid,
                            width: 2),
                        children: rows,
                      ),
                      Text('${myCustomers.length.toString()} Cosutmers'),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: kMainColor),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void addRows({required List<MyCustomerData> customers}) {
    rows.add(
      const TableRow(children: [
        TableCell(
            child: Text(
          'Name',
          textAlign: TextAlign.center,
        )),
        TableCell(
          child: Text(
            'Phone',
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
            child: Text(
          'all time points',
          textAlign: TextAlign.center,
        )),
        TableCell(
            child: Text(
          'current points',
          textAlign: TextAlign.center,
        )),
      ]),
    );
    for (int i = 0; i < customers.length; i++) {
      TableRow row = TableRow(
        children: [
          TableCell(child: Text(customers[i].name)),
          TableCell(
            child: Text(customers[i].phoneNumber),
          ),
          TableCell(
              child: Text(
            '${customers[i].allTimes}',
            textAlign: TextAlign.center,
          )),
          TableCell(
              child: Text(
            '${customers[i].total}',
            textAlign: TextAlign.center,
          )),
        ],
      );
      rows.add(row);
    }
  }
}
