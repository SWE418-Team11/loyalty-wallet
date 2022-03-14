import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/user_data.dart';

class UnBan extends StatefulWidget {
  const UnBan({Key? key}) : super(key: key);

  @override
  _UnBanState createState() => _UnBanState();
}

class _UnBanState extends State<UnBan> {
  @override
  Widget build(BuildContext context) {
    Future doneAlert(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (BuildContext dialogcontext) {
            return AlertDialog(
              content: const Text(
                'the user have been Unbanned',
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
          title: const Text('Unban Users'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Banned Users List',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: CloudDatabase.getBanedUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<UserData> users = snapshot.data as List<UserData>;
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: users.length,
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
                                          'are you sure you want to Unban this user?',
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
                                                child: const Text('Unban'),
                                                onPressed: () {
                                                  CloudDatabase.unBanUser(
                                                      users[index].phoneNumber);
                                                  Navigator.pop(dialogcontext);
                                                  doneAlert(context);
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
                                    Text(
                                        users[index].firstName +
                                            ' ' +
                                            users[index].lastName,
                                        style: TextStyle(fontSize: 18.0)),
                                    Text(users[index].phoneNumber.toString(),
                                        style: TextStyle(fontSize: 18.0))
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
