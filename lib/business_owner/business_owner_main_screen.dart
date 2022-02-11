import 'package:flutter/material.dart';

class BusinessOwnerMainScreen extends StatefulWidget {
  const BusinessOwnerMainScreen({Key? key}) : super(key: key);
  static String id = 'Business Owner Main Screen';

  @override
  _BusinessOwnerMainScreenState createState() =>
      _BusinessOwnerMainScreenState();
}

class _BusinessOwnerMainScreenState extends State<BusinessOwnerMainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Business Owner'),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Holla BO',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    );
  }
}
