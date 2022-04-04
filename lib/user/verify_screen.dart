import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:loyalty_wallet/customer/customer_main_screen.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/admin/banned_user_screen.dart';
import 'package:loyalty_wallet/user/create_account_data_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../database_models/buisness_owner_database.dart';
import '../models/user_data.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen(
      {Key? key,
      required this.phoneNumber,
      required this.verificationID,
      required this.useCase})
      : super(key: key);
  static const id = 'Verify_Screen'; // Screen ID
  final String phoneNumber;
  final String verificationID;
  final String useCase;

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  // This is the entered code
  // It will be displayed in a Text widget
  late String _otp;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  bool inAsyncCall = false;

  @override
  void dispose() {
    super.dispose();
    _fieldOne.dispose();
    _fieldTwo.dispose();
    _fieldThree.dispose();
    _fieldFour.dispose();
    _fieldFive.dispose();
    _fieldSix.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Confirmation'),
      ),
      body: ModalProgressHUD(
        dismissible: false,
        inAsyncCall: inAsyncCall,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height / 6,
            ),
            //prompt
            Text(
              'Enter The Verification Code',
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            // OTP Field Numbers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OtpInput(_fieldOne, true),
                  const SizedBox(width: 2),
                  OtpInput(_fieldTwo, false),
                  const SizedBox(width: 2),
                  OtpInput(_fieldThree, false),
                  const SizedBox(width: 2),
                  OtpInput(_fieldFour, false),
                  const SizedBox(width: 2),
                  OtpInput(_fieldFive, false),
                  const SizedBox(width: 2),
                  OtpInput(_fieldSix, false),
                ],
              ),
            ),
            SizedBox(
              height: size.height / 3.4,
            ),
            // Verify Button
            SizedBox(
              height: size.height / 13,
              width: size.width / 2,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    inAsyncCall = true;
                  });
                  _otp = _fieldOne.text +
                      _fieldTwo.text +
                      _fieldThree.text +
                      _fieldFour.text +
                      _fieldFive.text +
                      _fieldSix.text;

                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationID, smsCode: _otp);

                  try {
                    UserCredential uc = await FirebaseAuth.instance
                        .signInWithCredential(credential);

                    if (FirebaseAuth.instance.currentUser != null) {
                      //check if user exist
                      UserData? user = await CloudDatabase.getUser(id: userId!);
                      if (user == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountDataScreen(
                              phoneNumber: widget.phoneNumber,
                              accountType:
                                  widget.useCase == 'Create Business Account'
                                      ? 'Business'
                                      : 'Normal',
                            ),
                          ),
                        );
                      } else {
                        if (user.businessOwner == false &&
                            widget.useCase == 'Create Business Account') {
                          await BusinessOwnerDatabase.turnAccountToBusiness(
                              id: userId!);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerMainScreen(user: user)));
                        } else {
                          setState(() {
                            inAsyncCall = false;
                          });

                          if (!user.band) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerMainScreen(user: user)));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BannedScreen()));
                          }
                        }
                      }
                    }
                  } catch (e) {
                    setState(() {
                      inAsyncCall = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Invalid OTP, try again',
                          style: TextStyle(color: Colors.white)),
                      backgroundColor: kMainColor,
                    ));
                    setState(() {
                      inAsyncCall = false;
                    });
                  }
                },
                child: Text(
                  "Verify",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
            //Create an Account
          ],
        ),
      ),
    );
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: TextFormField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        cursorColor: Theme.of(context).primaryColor,
        decoration: kTexFieldDecoration.copyWith(hintText: 'X'),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
