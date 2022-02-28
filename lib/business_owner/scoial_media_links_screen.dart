import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/add_branch_screen.dart';
import 'package:loyalty_wallet/constants.dart';

class SocialMediaLinksScreen extends StatefulWidget {
  const SocialMediaLinksScreen(
      {Key? key,
      required this.links,
      required this.isNew,
      required this.storeData})
      : super(key: key);
  final Map<String, dynamic>? links;
  final bool isNew;
  final Map<String, dynamic>? storeData;

  @override
  _SocialMediaLinksScreenState createState() => _SocialMediaLinksScreenState();
}

class _SocialMediaLinksScreenState extends State<SocialMediaLinksScreen> {
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _snapchatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic>? links = widget.links;
    if (!widget.isNew) {
      _instagramController.text = links?['instagram'];
      _twitterController.text = links?['twitter'];
      _facebookController.text = links?['facebook'];
      _snapchatController.text = links?['snapchat'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isNew = widget.isNew;
    final Map<String, dynamic>? links = widget.links;
    final Map<String, dynamic>? storeData = widget.storeData;

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isNew ? 'Create new Store' : ''),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Enter Accounts',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(
                  height: 30,
                ),
                SocialMediaField(
                  size: size,
                  name: 'Instagram @',
                  hint: 'e.g LoyaltyWallet',
                  controller: _instagramController,
                ),
                SocialMediaField(
                  size: size,
                  name: 'Twitter @',
                  hint: 'e.g LoyaltyWallet',
                  controller: _twitterController,
                ),
                SocialMediaField(
                  size: size,
                  name: 'Facebook @',
                  hint: 'e.g LoyaltyWallet',
                  controller: _facebookController,
                ),
                SocialMediaField(
                  size: size,
                  name: 'Snapchat @',
                  hint: 'e.g LoyaltyWallet',
                  controller: _snapchatController,
                ),
                SizedBox(
                  height: size.height / 4.3,
                ),
                Center(
                  child: SizedBox(
                    height: size.height / 13,
                    width: size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> currentStoreData = {
                          'name': storeData?['name'],
                          'description': storeData?['description'],
                          'storeIcon': storeData?['storeIcon'],
                          'storeBanner': storeData?['storeBanner'],
                          'socialMedia': {
                            'instagram': _instagramController.value.text,
                            'twitter': _twitterController.value.text,
                            'facebook': _facebookController.value.text,
                            'snapchat': _snapchatController.value.text,
                          }
                        };
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBranchScreen(
                              isNew: true,
                              storeData: currentStoreData,
                              store: null,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Next",
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(color: Colors.white),
                      ),
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

class SocialMediaField extends StatelessWidget {
  const SocialMediaField(
      {Key? key,
      required this.size,
      required this.name,
      required this.hint,
      required this.controller})
      : super(key: key);

  final Size size;
  final String name;
  final String hint;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              width: size.width / 2,
              child: TextField(
                controller: controller,
                decoration: kTexFieldDecoration.copyWith(hintText: hint),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}
