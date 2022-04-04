import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../database_models/cahsier_database.dart';
import '../models/card_data.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen(
      {Key? key,
      required this.operation,
      required this.cardID,
      required this.storeID,
      required this.storeComputation,
      required this.points,
      required this.card})
      : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();

  final String operation;
  final CardData card;
  final String? cardID;
  final double points;
  final String storeID;
  final double storeComputation;
}

class _TransactionScreenState extends State<TransactionScreen> {
  late String? cardID = widget.cardID;
  late double points = widget.points;
  late double amount;
  late String storeID = widget.storeID;
  late double storeComputation = widget.storeComputation;
  int length = 0;
  late String appBarText, enterValueText, dialogText, buttonText;

  double compute(double points, double amount, double weight) {
    //in case of adding points, each ryal is equivalent to RsEqualsTo that is
    // set by the store, then the number of points
    // is the price or amount times the weight.
    if (widget.operation == 'add') {
      points += amount * weight;
    } else {
      if (points - amount >= 0) {
        points -= amount;
      } else {
        return points;
      }
    }
    return points;
  }

  Future<dynamic> successDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogcontext) {
          return AlertDialog(
            content: Text(dialogText),
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

  @override
  void initState() {
    super.initState();
    if (widget.operation == 'add') {
      appBarText = 'Add points';
      enterValueText = 'Enter the Total Cost';
      dialogText = 'Points have been added to Card Successfuly';
      buttonText = 'Add';
    } else {
      appBarText = 'redeem points';
      enterValueText = 'Enter Points';
      dialogText = 'Points have been redeemed Successfuly';
      buttonText = 'redeem';
    }
  }

  @override
  Widget build(BuildContext context) {
    CardData card = widget.card;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        //to hide the keyboard when pressed anywhere outside the TextFormField
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarText),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(card.id),
              const SizedBox(
                height: 50,
              ),
              Text(
                enterValueText,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 6,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                toolbarOptions:
                    const ToolbarOptions(), //to disable pasting unacceptable values (by default it allows characters to be pasted)
                decoration: kTexFieldDecoration,
                onChanged: (amount) {
                  /*change variable amount to this amount */
                  length = amount.length;
                  this.amount = double.parse(amount);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (length > 0) {
                      points = compute(points, amount, 0);
                      if (points < 0) {
                        failDialog(context,
                            'cannot redeem more than available points.');
                      }
                      card.transactions.add({
                        'amount': amount,
                        'state': widget.operation == 'add' ? 'add' : 'remove',
                        'date': DateTime.now()
                      });
                      await CashierDatabase.setCardPoints(
                              cardID, points, card.transactions)
                          .whenComplete(() {
                        successDialog(context)
                            .then((value) => Navigator.pop(context));
                      });
                    } else {
                      failDialog(context, 'please enter amount first.');
                    }
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key, required this.operation}) : super(key: key);
  final String operation;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late String? cardID;
    late double points;
    late String storeID;
    late double storeComputation;

    bool inAsyncCall = false;

    return ModalProgressHUD(
      dismissible: false,
      inAsyncCall: inAsyncCall,
      child: Scaffold(
        body: cameraController.isStarting
            ? WillPopScope(
                onWillPop: () async {
                  Navigator.pop(context);
                  //this pops twice insead of hiding the camera and staying in the same page
                  return true;
                },
                child: Stack(
                  alignment: const Alignment(-1, -0.9),
                  children: [
                    MobileScanner(
                      controller: cameraController,
                      onDetect: (barcode, args) async {
                        setState(() {
                          cameraController.stop();
                          inAsyncCall = true;
                        });

                        if (barcode.rawValue!.startsWith('id=')) {
                          cardID = barcode.rawValue;
                          cardID = cardID!.substring(3);
                          CardData card =
                              await CloudDatabase.getCardPoints(cardID);
                          String cashierStoreID =
                              await CashierDatabase.isCashier();
                          if (cashierStoreID != card.storeID) {
                            Navigator.pop(context);
                          }
                          //returns a map with the points and the storeID
                          storeID = card.storeID;
                          points = card.total;
                          storeComputation =
                              await CashierDatabase.getPointWeight(
                                  card.storeID);
                          setState(() {
                            inAsyncCall = false;
                          });

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionScreen(
                                  operation: widget.operation,
                                  cardID: cardID,
                                  storeID: storeID,
                                  storeComputation: storeComputation,
                                  points: points,
                                  card: card),
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      //return button that appears in top of the scanner
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : ModalProgressHUD(
                inAsyncCall: true,
                child: Center(
                    child: Text(
                  'Waiting...',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: Colors.black),
                ))),
      ),
    );
  }
}
