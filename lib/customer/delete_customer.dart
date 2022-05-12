import 'package:flutter/material.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../User/start_screen.dart';
import '../models/user_data.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key, required this.user}) : super(key: key);
  final UserData user;
  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool inAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    UserData user = widget.user;
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      dismissible: false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff00AF91),
            title: const Text('Delete Account'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('images/UserImage.jpg'),
                      radius: 65,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0,
                      ),
                    ),
                    Text(
                      user.phoneNumber,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19.0,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Deleting your account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'you are about to start the process of deleting your Loyalty Wallet account. all your information and points in your account will no longer be exist. you can restore your account if you login into the app in the next 30 days.',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Extra information you should know',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'some account information may still be visible to the admins and the stores owners. \nafter your account is deleted, you can recreate another account with the same phone number.',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          inAsyncCall = true;
                        });
                        await CloudDatabase.deleteUser(user);
                        setState(() {
                          inAsyncCall = false;
                        });
                        Navigator.pushReplacementNamed(context, StartScreen.id);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffF25252),
                        minimumSize: const Size(200, 40),
                      ),
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
