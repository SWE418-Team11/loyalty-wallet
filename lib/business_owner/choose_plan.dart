import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../database_models/buisness_owner_database.dart';

class ChoosePlan extends StatefulWidget {
  const ChoosePlan({required this.data, Key? key}) : super(key: key);
  final Map<String, dynamic> data;

  @override
  _ChoosePlanState createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  bool inAsyncCall = false;
  bool _isVisible = true;
  bool _isVisible12 = false;

  bool _isVisible2 = true;
  bool _isVisible22 = false;

  bool _isVisible3 = true;
  bool _isVisible32 = false;

  void _selectPlan(String plan) async {
    Map<String, dynamic> pData = widget.data;
    setState(() {
      inAsyncCall = true;
    });
    Map<String, dynamic> data = {
      'name': pData['name'],
      'description': pData['description'],
      'storeIcon': pData['storeIcon'],
      'storeBanner': pData['storeBanner'],
      'socialMedia': {
        'instagram': pData['socialMedia']['instagram'],
        'twitter': pData['socialMedia']['twitter'],
        'facebook': pData['socialMedia']['facebook'],
        'snapchat': pData['socialMedia']['snapchat'],
      },
      'locations': [
        {
          'branchBanner': pData['locations'][0]['branchBanner'],
          'location': pData['locations'][0]['location'],
          'description': pData['locations'][0]['description'],
        },
      ],
      'RsEqualsTo': pData['RsEqualsTo'],
      'plan': plan
    };

    await BusinessOwnerDatabase.addStore(data);
    setState(() {
      inAsyncCall = false;
    });
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 5);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Create Business Account'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text('Enter Your Plan',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  PlanButton(
                    isVisible: _isVisible,
                    isVisible2: _isVisible12,
                    buttonTitle: 'STARTUP BUSNINNES PLAN',
                    title: 'STARTUP\nBUSNINNES PLAN',
                    content:
                        '199SR/ Month\nUp To 250 Cards\nUp To 3 Notification/Week',
                    size: size,
                    onPressed: () {
                      setState(() {
                        _isVisible = false;
                        _isVisible12 = true;
                        _isVisible2 = true;
                        _isVisible22 = false;
                        _isVisible3 = true;
                        _isVisible32 = false;
                      });
                    },
                    onAction: () {
                      _selectPlan('STARTUP');
                    },
                  ),
                  const SizedBox(height: 28),
                  PlanButton(
                    isVisible: _isVisible2,
                    isVisible2: _isVisible22,
                    buttonTitle: 'SMALL BUSINESS PLAN',
                    title: 'SMALL\nBUSINESS PLAN',
                    content:
                        '499SR/ Month\nUp To 2500 Cards\nUp To 100 Notification/Week',
                    size: size,
                    onPressed: () {
                      setState(() {
                        setState(() {
                          _isVisible2 = false;
                          _isVisible22 = true;
                          _isVisible = true;
                          _isVisible12 = false;
                          _isVisible3 = true;
                          _isVisible32 = false;
                        });
                      });
                    },
                    onAction: () {
                      _selectPlan('SMALL');
                    },
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  PlanButton(
                      isVisible: _isVisible3,
                      isVisible2: _isVisible32,
                      size: size,
                      buttonTitle: 'Advanced\nBusiness Plan',
                      title: 'Advanced\nBusiness Plan',
                      content:
                          '999SR/ Month\nUp To Infinite Cards\nUp To Infinite Notification/Week',
                      onPressed: () {
                        setState(() {
                          _isVisible3 = false;
                          _isVisible32 = true;
                          _isVisible2 = true;
                          _isVisible22 = false;
                          _isVisible = true;
                          _isVisible12 = false;
                        });
                      },
                      onAction: () {
                        _selectPlan('ADVANCED');
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlanButton extends StatelessWidget {
  const PlanButton({
    Key? key,
    required bool isVisible,
    required bool isVisible2,
    required Size size,
    required String buttonTitle,
    required String title,
    required String content,
    required VoidCallback onPressed,
    required VoidCallback onAction,
  })  : _isVisible = isVisible,
        _isVisible12 = isVisible2,
        _buttonTitle = buttonTitle,
        _title = title,
        _content = content,
        _size = size,
        _onPressed = onPressed,
        _onAction = onAction,
        super(key: key);

  final bool _isVisible;
  final bool _isVisible12;
  final String _buttonTitle;
  final String _title;
  final String _content;
  final Size _size;
  final VoidCallback _onPressed;
  final VoidCallback _onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: _isVisible,
          child: SizedBox(
            child: ElevatedButton(
              onPressed: _onPressed,
              style: ElevatedButton.styleFrom(
                primary: kMainColor, // Background color
                fixedSize: Size(_size.width, 100),
              ),
              child: Text(
                _buttonTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isVisible12, // not visible if set false

          child: InkWell(
            onTap: _onAction,
            child: Container(
              width: _size.width,
              margin: const EdgeInsets.all(2.0),
              padding: const EdgeInsets.all(25.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
              child: Visibility(
                visible: _isVisible12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: kMainColor, height: 1.2),
                    ),
                    Text(
                      _content,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          ?.copyWith(color: kMainColor, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
