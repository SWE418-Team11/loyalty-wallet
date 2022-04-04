import 'package:flutter/material.dart';
import 'package:loyalty_wallet/customer/customer_main_screen.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';

import '../constants.dart';

class CreateAccountDataScreen extends StatefulWidget {
  const CreateAccountDataScreen(
      {Key? key, required this.accountType, required this.phoneNumber})
      : super(key: key);
  final String accountType;
  final String phoneNumber;

  @override
  _CreateAccountDataScreenState createState() =>
      _CreateAccountDataScreenState();
}

class _CreateAccountDataScreenState extends State<CreateAccountDataScreen> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Personal Information'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 6,
                  ),
                  Center(
                    child: Text(
                      "Enter Your First Name",
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: fName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'this field is required';
                      } else if (value.length < 3) {
                        return 'the name is too short';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration:
                        kTexFieldDecoration.copyWith(hintText: 'First Name'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Enter Your Last Name",
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: lName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'this field is required';
                      } else if (value.length < 3) {
                        return 'the name is too short';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration:
                        kTexFieldDecoration.copyWith(hintText: 'Last Name'),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height / 5,
                  ),
                  SizedBox(
                    height: size.height / 13,
                    width: size.width / 2,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await CloudDatabase.createAccount(
                            accountType: widget.accountType,
                            firstName: fName.value.text,
                            lastName: lName.value.text,
                            phoneNumber: widget.phoneNumber,
                          ).then((user) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CustomerMainScreen(user: user),
                              ),
                            );
                          });
                        }
                      },
                      child: Text(
                        'Create',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
