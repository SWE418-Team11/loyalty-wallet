import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/database_models/buisness_owner_database.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/store.dart';

import '../database_models/cloud_batabase.dart';

class DeleteStoreAccount extends StatefulWidget {
  const DeleteStoreAccount({Key? key}) : super(key: key);

  @override
  _DeleteStoreAccountState createState() => _DeleteStoreAccountState();
}

class _DeleteStoreAccountState extends State<DeleteStoreAccount> {
  @override
  Widget build(BuildContext context) {
    Future doneAlert(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (BuildContext dialogcontext) {
            return AlertDialog(
              content: const Text(
                'The Store Is Deleted Successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogcontext);
                  },
                  child: const Text('DONE'),
                ),
              ],
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff00AF91),
          title: const Text('Delete Store'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Stores List',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: CloudDatabase.getStores(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Store> stores = snapshot.data as List<Store>;
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: stores.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext dialogcontext) {
                                      return AlertDialog(
                                        content: const Text(
                                          'are you sure you want to delete this user?',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            children: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.redAccent,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                ),
                                                child: const Text('DELETE'),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  BusinessOwnerDatabase
                                                      .deleteSTORE(
                                                          store: stores[index]);

                                                  Navigator.pop(context);
                                                },
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  primary: Colors.grey,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 20),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(dialogcontext);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                          )
                                        ],
                                      );
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Text(stores[index].name,
                                        style: TextStyle(fontSize: 18.0)),
                                    // Text(stores[index].phoneNumber.toString(),
                                    //     style: TextStyle(fontSize: 18.0))
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
