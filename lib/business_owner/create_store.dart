import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loyalty_wallet/business_owner/scoial_media_links_screen.dart';
import 'package:loyalty_wallet/constants.dart';
import 'package:image_picker/image_picker.dart';

class CreateStore extends StatefulWidget {
  const CreateStore({Key? key}) : super(key: key);

  @override
  _CreateStoreState createState() => _CreateStoreState();
}

class _CreateStoreState extends State<CreateStore> {
  final ImagePicker _picker = ImagePicker();
  XFile? _storeIcon;
  XFile? _storeBanner;
  bool filled = true;

  final TextEditingController _storeDescription = TextEditingController();
  final TextEditingController _storeName = TextEditingController();
  Future<void> choseIcon() async {
    var icon = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _storeIcon = icon;
    });
  }

  Future<void> choseBanner() async {
    var banner = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _storeBanner = banner;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create New Store'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Store name
                const Text('Store Name'),
                SizedBox(
                  width: size.width / 1.5,
                  child: TextField(
                    controller: _storeName,
                    decoration: kTexFieldDecoration.copyWith(
                        hintText: 'e.g Central Perk'),
                  ),
                ),
                const SizedBox(height: 20),
                //Store name
                const Text('Store description'),
                SizedBox(
                  width: size.width / 1.5,
                  child: TextField(
                    controller: _storeDescription,
                    decoration: kTexFieldDecoration.copyWith(
                        hintText: 'e.g  Breakfast, Coffee & Dessert'),
                  ),
                ),
                const SizedBox(height: 20),
                //Store icon
                const Text('Upload Store Icon'),
                const SizedBox(height: 5),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        choseIcon();
                      });
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        width: size.width,
                        height: size.height / 4,
                        color: Colors.grey,
                        child: _storeIcon == null
                            ? Icon(
                                Icons.add_photo_alternate_outlined,
                                size: size.height / 4.5,
                                color: Colors.white,
                              )
                            : Image.file(
                                File(_storeIcon!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                //Store Banner
                const SizedBox(height: 20),
                const Text('Upload Store Banner'),
                const SizedBox(height: 5),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      choseBanner();
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        width: size.width,
                        height: size.height / 4,
                        color: Colors.grey,
                        child: _storeBanner == null
                            ? Icon(
                                Icons.add_photo_alternate_outlined,
                                size: size.height / 4.5,
                                color: Colors.white,
                              )
                            : Image.file(
                                File(_storeBanner!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                // Next
                const SizedBox(height: 20),
                !filled
                    ? const Center(
                        child: Text(
                          'All Data Must Be Filled',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      )
                    : const SizedBox(),
                Center(
                  child: SizedBox(
                    height: size.height / 13,
                    width: size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_storeBanner == null ||
                            _storeIcon == null ||
                            _storeDescription.text.isEmpty ||
                            _storeName.value.text.isEmpty) {
                          setState(() {
                            filled = !filled;
                          });
                        } else {
                          setState(() {
                            filled = true;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SocialMediaLinksScreen(
                                isNew: true,
                                links: null,
                                storeData: {
                                  'name': _storeName.value.text,
                                  'description': _storeDescription.value.text,
                                  'storeIcon': '${_storeIcon?.path}',
                                  'storeBanner': '${_storeBanner?.path}',
                                },
                              ),
                            ),
                          );
                        }
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
