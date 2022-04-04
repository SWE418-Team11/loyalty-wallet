import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/choose_plan.dart';

import '../database_models/buisness_owner_database.dart';
import '../models/store.dart';

class ComputationPointsScreen extends StatefulWidget {
  const ComputationPointsScreen(
      {Key? key, required this.store, required this.data, required this.isNew})
      : super(key: key);

  final Store? store;
  final bool isNew;
  final Map<String, dynamic> data;

  @override
  _ComputationPointsScreenState createState() =>
      _ComputationPointsScreenState();
}

class _ComputationPointsScreenState extends State<ComputationPointsScreen> {
  final TextEditingController _point = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pData = widget.data;
    bool isNew = widget.isNew;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff00AF91),
          title: Text(isNew ? 'Create Business Account' : 'Points Computation'),
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
                  if (isNew) {
                    double points = 1;

                    try {
                      points = double.parse(_point.value.text);
                    } catch (e) {
                      points = 1;
                    }

                    Map<String, dynamic> data = {
                      'name': pData['name'],
                      'description': pData['description'],
                      'storeIcon': pData['storeIcon'],
                      'storeBanner': pData['storeBanner'],
                      'socialMedia': {
                        'instagram': pData['socialMedia']['instagram'],
                        'twitter': pData['socialMedia']['twitter'],
                        'facebook': pData['socialMedia']['facebook'],
                        'snapchat': pData['socialMedia']['snapchat'],
                      },
                      'locations': [
                        {
                          'branchBanner': pData['locations'][0]['branchBanner'],
                          'location': pData['locations'][0]['location'],
                          'description': pData['locations'][0]['description'],
                        },
                      ],
                      'RsEqualsTo': points,
                    };
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChoosePlan(data: data)),
                    );
                  } else {
                    BusinessOwnerDatabase.setPoints(
                            double.parse(_point.value.text),
                            widget.store?.id ?? '')
                        .whenComplete(() => Navigator.pop(context));
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff00AF91),
                  minimumSize: const Size(200, 40),
                ),
                child: Text(
                  isNew ? 'Next' : 'COMPUTE AND SAVE',
                  style: const TextStyle(fontSize: 30.0, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
