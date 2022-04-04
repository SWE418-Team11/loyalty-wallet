import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/cashier_edit.dart';
import 'package:loyalty_wallet/constants.dart';
import '../models/store.dart';

class CashierList extends StatefulWidget {
  const CashierList({Key? key, required this.store}) : super(key: key);
  final Store store;
  @override
  _CashierListState createState() => _CashierListState();
}

class _CashierListState extends State<CashierList> {
  @override
  Widget build(BuildContext context) {
    Store store = widget.store;
    String? storeID = store.id;
    List<String> cashierNO;
    CollectionReference owners = FirebaseFirestore.instance.collection('Owner');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kMainColor,
          title: const Text("Cashier List"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  //Todo: add branches screen here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCashier(
                        store: store,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 30,
                )),
          ],
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: FutureBuilder<DocumentSnapshot>(
              future: owners.doc(storeID).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> cashlist =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return cashlist['cashierList'].length != null
                      ? ListView.builder(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          itemCount: cashlist['cashierList'].length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: Text(
                                cashlist['cashierList'][i],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Add New Cashier From'),
                            Icon(
                              Icons.edit,
                              color: kMainColor,
                              size: 30,
                            )
                          ],
                        );
                }
                return const Center(child: Text("loading"));
              },
            ),
          ),
        ),
      ),
    );
  }
}
