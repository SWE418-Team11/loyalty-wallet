import 'package:flutter/material.dart';
import 'package:loyalty_wallet/User/login_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({
    Key? key,
  }) : super(key: key);
  static const id = 'Create_Account_Screen'; // Screen ID
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

// ignore: camel_case_types
class _CreateAccountScreenState extends State<CreateAccountScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Screen current size
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Start Page.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),

                //Title
                const Text(
                  'Loyalty\nWallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Slackey',
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.9,
                ),

                SizedBox(
                  height: size.height / 10,
                  width: size.width / 1.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(
                            useCase: 'Create Normal Account',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "CREATE NORMAL ACCOUNT",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: size.height / 10,
                  width: size.width / 1.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(
                            useCase: 'Create Business Account',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "CREATE BUSINESS ACCOUNT",
                      textAlign: TextAlign.center,
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
    );
  }
}
