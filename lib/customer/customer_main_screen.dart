import 'package:flutter/material.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({Key? key}) : super(key: key);

  static String id = 'Customer Main Screen';

  @override
  _CustomerMainScreenState createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Customer'),
          centerTitle: true,
        ),
        body: Center(
          child: Text(
            'Holla Customer',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
    );
  }
}
