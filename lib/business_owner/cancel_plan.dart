import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../database_models/buisness_owner_database.dart';
import '../models/store.dart';

class CancelPlan extends StatefulWidget {
  const CancelPlan({Key? key, required this.store}) : super(key: key);
  final Store store;

  @override
  _CancelPlan createState() => _CancelPlan();
}

class _CancelPlan extends State<CancelPlan> {
  final TextEditingController _cancelationReason = TextEditingController();
  bool value = false;
  bool inAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    Store store = widget.store;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: inAsyncCall,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff00AF91),
            title: const Text('Cancel Plan'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Alret',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 19.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffF58634),
                    ),
                    // ignore: prefer_const_constructors
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 19.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Enter Cancelation Reason',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  const Text(
                    '(Optional)',
                    style: TextStyle(
                      fontSize: 17.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cancelationReason,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Please Describe Your Reason...',
                        fillColor: Color(0xfff9f9f9)),
                    minLines: 6,
                    maxLines: null,
                  ),
                  const SizedBox(height: 50),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value!;
                      });
                    },
                    title: const Text(
                      'I Agree To Cancel My Current Subscribtion Plan.',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 70,
                    child: TextButton(
                      onPressed: () async {
                        if (value) {
                          setState(() {
                            inAsyncCall = true;
                          });
                          await BusinessOwnerDatabase.changePlanOfStore(
                              id: store.id!, plan: 'canceled');
                        }
                        setState(() {
                          inAsyncCall = false;
                        });
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffF25252),
                        minimumSize: const Size(200, 40),
                      ),
                      child: const Text(
                        'CANCEL PLAN',
                        style: TextStyle(fontSize: 30.0, color: Colors.white),
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
