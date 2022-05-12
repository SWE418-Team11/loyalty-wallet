import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/user_data.dart';
import 'package:url_launcher/url_launcher.dart';

class BOList extends StatefulWidget {
  const BOList({Key? key}) : super(key: key);

  @override
  State<BOList> createState() => _BOListState();
}

class _BOListState extends State<BOList> {
  @override
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Business Owners"),
        centerTitle: true,
        backgroundColor: kMainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Business Owners List',
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
              future: CloudDatabase.getBO(),
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
                            onTap: () async {
                              // redirect to whatsapp
                              await launch(
                                  "https://wa.me/${users[index].phoneNumber.toString()}",
                                  forceSafariVC: true,
                                  forceWebView: true);
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
                                      style: const TextStyle(fontSize: 18.0)),
                                  Text(users[index].phoneNumber.toString(),
                                      style: const TextStyle(fontSize: 18.0))
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
    );
  }
}
// StreamBuilder<QuerySnapshot>(
//       stream: users.snapshots().where('isBusinessOwner', ),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text("Loading");
//         }

//         if(snapshot.connectionState==ConnectionState.done){

//           Map<String,dynamic> BODetails = snapshot.data!.data
//         }

//       },
//       )
