import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';

class BannedScreen extends StatelessWidget {
  const BannedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Banned'), centerTitle: true, primary: false),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.15,
                child: Text(
                  'You were banned, please contact us for more information',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: kMainColor,
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
