import 'package:flutter/material.dart';
import 'transaction_screen.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({Key? key}) : super(key: key);

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ScannerScreen(
                          operation: 'redeem',
                        );
                      }),
                    );
                  },
                  child: const Text(
                    'Redeem Points ',
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const ScannerScreen(
                          operation: 'add', //either add or redeem
                        );
                      }),
                    );
                  },
                  child: const Text(
                    'Add Points',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
