import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/models/cloud_batabase.dart';

class BusinessOwnerStoreScreen extends StatefulWidget {
  const BusinessOwnerStoreScreen({Key? key}) : super(key: key);

  @override
  _BusinessOwnerStoreScreenState createState() =>
      _BusinessOwnerStoreScreenState();
}

class _BusinessOwnerStoreScreenState extends State<BusinessOwnerStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: CloudDatabase.getStore(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                body: SingleChildScrollView(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                backgroundColor: kMainColor,
              ));
            }
          }),
    );
  }
}
