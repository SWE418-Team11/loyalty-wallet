import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database_models/admin_database.dart';

class BanUser extends StatelessWidget {
  const BanUser({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future doneAlert(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (BuildContext dialogcontext) {
            return AlertDialog(
              content: const Text(
                'the user have been banned',
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

    late String _phoneNumber;
    bool error = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ban users"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Users List',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  onChanged: (value) {
                    error = false;
                    _phoneNumber = value;
                  },
                  validator: (value) {
                    if (_phoneNumber.isEmpty || _phoneNumber.length < 9) {
                      return 'Please check Your Phone Number';
                    } else if (error) {
                      return 'Error, please try again later';
                    }

                    return null;
                  },
                  decoration:
                      const InputDecoration(labelText: "Enter user number"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ], // Only numbers can be entered
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext dialogcontext) {
                          return AlertDialog(
                            content: const Text(
                              'are you sure you want to banned this user?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                              ),
                            ),
                            actions: [
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                    ),
                                    child: const Text('Ban'),
                                    onPressed: () {
                                      AdminDatabase.banUser(_phoneNumber);
                                      Navigator.pop(dialogcontext);
                                      Navigator.pop(context);
                                      doneAlert(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
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
                  child: Text(
                    "BAN USER",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
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
