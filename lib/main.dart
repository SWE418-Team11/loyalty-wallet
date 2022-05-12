import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/User/create_account.dart';
import 'package:loyalty_wallet/User/start_screen.dart';
import 'package:loyalty_wallet/constants.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LoyaltyWallet());
}

class LoyaltyWallet extends StatelessWidget {
  const LoyaltyWallet({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: kMainMaterialColor,
        bottomAppBarColor: kMainMaterialColor,
      ),
      initialRoute: StartScreen.id,
      routes: {
        StartScreen.id: (context) => const StartScreen(),
        CreateAccountScreen.id: (context) => const CreateAccountScreen(),
      },
    );
  }
}
