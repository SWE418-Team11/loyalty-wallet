import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/models/store.dart';

import '../database_models/buisness_owner_database.dart';
import '../database_models/cahsier_database.dart';

class SpecialOfferScreen extends StatefulWidget {
  const SpecialOfferScreen({Key? key, required this.businessOwnerID})
      : super(key: key);
  final String businessOwnerID;

  @override
  State<SpecialOfferScreen> createState() => _SpecialOfferScreenState();
}

class _SpecialOfferScreenState extends State<SpecialOfferScreen> {
  String offerDetails = '';
  String startDate = '';
  String endDate = '';
  List<Store> stores = [];
  String current = '';
  String computation = '';

  void getStores() async {
    stores = await BusinessOwnerDatabase.getOwnerStores();
    //Todo:handle the case where there are no stores
    current = stores.first.id!;
    computation = (await CashierDatabase.getPointWeight(current)).toString();
    setState(() {});
  }

  Future<dynamic> failDialog(BuildContext context, String text) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogcontext) {
          return AlertDialog(
            content: Text(text),
            actions: [
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  Navigator.pop(dialogcontext);
                },
              ),
            ],
          );
        });
  }

  Future<dynamic> successDialog(BuildContext context, String content) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogcontext) {
          return AlertDialog(
            content: Text(content),
            actions: [
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.pop(dialogcontext);
                  Navigator.pop(context);
                  //pop from dialog and screen to return to operations screen
                },
              ),
            ],
          );
        });
  }

  Future<dynamic> setCompSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext sheetCotext) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter point per 1 Riyal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: kTexFieldDecoration.copyWith(
                      hintText: 'how much points per 1 Riyal'),
                  keyboardType: TextInputType.number,
                  toolbarOptions: const ToolbarOptions(),
                  initialValue: computation,
                  onChanged: (value) {
                    computation = value;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    child: const Text('Set Computation'),
                    style:
                        ElevatedButton.styleFrom(primary: kMainMaterialColor),
                    onPressed: () {
                      Navigator.pop(sheetCotext);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    getStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Make Offer'),
          centerTitle: true,
        ),
        body: SafeArea(
          minimum: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select Store',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  items: stores.map((Store store) {
                    return DropdownMenuItem(
                      value: store.id,
                      child: Text(store.name),
                    );
                  }).toList(),
                  onChanged: (choice) {
                    setState(() {
                      current = choice!;
                    });
                  },
                  value: current,
                  hint: const Text('Select User'),
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                const Text(
                  'Enter Offer Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: size.height / 5,
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 7,
                    maxLines: 10,
                    decoration: kTexFieldDecoration.copyWith(
                      hintText: 'Offer',
                    ),
                    onChanged: (value) {
                      offerDetails = value;
                    },
                  ),
                ),
                const Text(
                  'Start Date:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: size.height / 12,
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration:
                        kTexFieldDecoration.copyWith(hintText: 'dd/mm/yyyy'),
                    onChanged: (value) {
                      startDate = value;
                    },
                  ),
                ),
                const Text(
                  'End Date:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: size.height / 12,
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration:
                        kTexFieldDecoration.copyWith(hintText: 'dd/mm/yyyy'),
                    onChanged: (value) {
                      endDate = value;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height / 10,
                  child: ElevatedButton(
                    child: const Text('Edit computation'),
                    style:
                        ElevatedButton.styleFrom(primary: kMainMaterialColor),
                    onPressed: () {
                      setCompSheet(context);
                    },
                  ),
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                SizedBox(
                  height: size.height / 10,
                  child: ElevatedButton(
                    child: const Text('Apply Offer'),
                    style:
                        ElevatedButton.styleFrom(primary: kMainMaterialColor),
                    onPressed: () {
                      if (startDate.isEmpty ||
                          endDate.isEmpty ||
                          offerDetails.isEmpty ||
                          computation.isEmpty) {
                        failDialog(context,
                            'please make sure all the fields are filled');
                      } else {
                        double comp = double.parse(computation);
                        BusinessOwnerDatabase.setOffer(
                                current, offerDetails, startDate, endDate, comp)
                            .whenComplete(() {
                          successDialog(
                              context, 'Offer has been made successfully');
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
