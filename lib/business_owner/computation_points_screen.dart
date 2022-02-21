import 'package:flutter/material.dart';
import 'package:loyalty_wallet/models/cloud_batabase.dart';

import '../models/store.dart';

class ComputationPointsScreen extends StatefulWidget {
  const ComputationPointsScreen({Key? key, required this.store})
      : super(key: key);

  final Store store;

  @override
  _ComputationPointsScreenState createState() =>
      _ComputationPointsScreenState();
}

class _ComputationPointsScreenState extends State<ComputationPointsScreen> {
  TextEditingController _point = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff00AF91),
          title: const Text('Points Computation'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  const Text(
                    'Enter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  const Text(
                    'Point Per 1 Riyal',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                  ),
                  const SizedBox(height: 50),
                  TextField(
                    controller: _point,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.5))),
                      filled: true,
                      fillColor: Color(0xfff9f9f9),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () async {
                  CloudDatabase.setPoints(
                          double.parse(_point.value.text), widget.store.id!)
                      .whenComplete(() => Navigator.pop(context));
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff00AF91),
                  minimumSize: const Size(200, 40),
                ),
                child: const Text(
                  'COMPUTE AND SAVE',
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
