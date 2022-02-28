import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loyalty_wallet/User/create_account.dart';
import 'package:loyalty_wallet/User/verify_screen.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.useCase}) : super(key: key);
  static const id = 'login_Screen'; // Screen ID
  final String useCase;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phone = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool error = false;
  late String verificationID;
  String authStatus = '';
  bool inAsyncCall = false;

  //will be used later to indicate that the page is loading
  @override
  Widget build(BuildContext context) {
    final String useCase = widget.useCase;
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        //this helps exiting the keyboard by clicking anywhere
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            useCase == 'Create Normal Account'
                ? 'Create Normal Account'
                : useCase == 'Create Business Account'
                    ? 'Create Business Account'
                    : 'Sing In',
          ),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          inAsyncCall: inAsyncCall,
          dismissible: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              //singlechild... prevents the overflow and the physics prevents scrolling while the keyboard is shown
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: size.height / 10,
                    ),
                    //Title
                    Center(
                      child: Text(
                        "Enter Your Phone Number",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Phone Number Input
                    Row(
                      children: [
                        const Text(
                          '+966',
                          style: TextStyle(fontSize: 20),
                        ),
                        Flexible(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                error = false;
                              });
                              phone = value;
                            },
                            validator: (phoneNumber) {
                              if (phone.isEmpty || phone.length < 9) {
                                return 'Please check Your Phone Number';
                              } else if (error) {
                                return 'Error, please try again later';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(9),
                            ],
                            decoration: kTexFieldDecoration.copyWith(
                                hintText: '5 XXX XX XXX'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    //Spacer
                    SizedBox(
                      height: size.height / 3.4,
                    ),
                    // Sign in button
                    SizedBox(
                      height: size.height / 13,
                      width: size.width / 2,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            inAsyncCall = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            await FirebaseAuth.instance
                                .verifyPhoneNumber(
                                  phoneNumber: '+966$phone',
                                  timeout: const Duration(seconds: 60),
                                  verificationCompleted:
                                      (AuthCredential authCredential) {
                                    setState(() {
                                      authStatus =
                                          "Your account is successfully verified";
                                    });
                                  },
                                  verificationFailed:
                                      (Exception authException) {
                                    // setState(() {
                                    //   authStatus = "Authentication failed";
                                    // });
                                  },
                                  codeSent: (String verificationId,
                                      [int? forceCodeResent]) {
                                    verificationID = verificationId;
                                    // setState(() {
                                    //   authStatus = "OTP has been successfully send";
                                    // });
                                    // Navigate according to the use of the page
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyScreen(
                                          phoneNumber: '+966$phone',
                                          verificationID: verificationID,
                                          useCase: useCase ==
                                                  'Create Business Account'
                                              ? 'Create Business Account'
                                              : useCase ==
                                                      'Create Normal Account'
                                                  ? 'Create Normal Account'
                                                  : 'Sign In',
                                        ),
                                      ),
                                    );
                                  },
                                  codeAutoRetrievalTimeout: (String verId) {
                                    // setState(() {
                                    //   authStatus = "TIMEOUT";
                                    // });
                                  },
                                )
                                .then((value) => setState(() {
                                      inAsyncCall = false;
                                    }));
                          }
                        },
                        child: Text(
                          widget.useCase == 'Sign In' ? 'Sign In' : 'Sign Up',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Create an Account
                    useCase == 'Sign In'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('To Create an Account'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, CreateAccountScreen.id);
                                  },
                                  child: const Text(
                                    'Click Here',
                                    style: TextStyle(color: kMainColor),
                                  ))
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
