import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyalty_wallet/business_owner/computation_points_screen.dart';

import '../constants.dart';
import '../database_models/buisness_owner_database.dart';
import '../models/store.dart';

class AddBranchScreen extends StatefulWidget {
  const AddBranchScreen(
      {Key? key,
      required this.storeData,
      required this.isNew,
      required this.store})
      : super(key: key);
  final Map<String, dynamic>? storeData;
  final bool isNew;
  final Store? store;
  @override
  _AddBranchScreenState createState() => _AddBranchScreenState();
}

class _AddBranchScreenState extends State<AddBranchScreen> {
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool filled = true;
  final ImagePicker _picker = ImagePicker();
  XFile? _branchBanner;
  Future<void> choseBanner() async {
    var banner = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _branchBanner = banner;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isNew = widget.isNew;
    Size size = MediaQuery.of(context).size;
    final Map<String, dynamic>? storeData = widget.storeData;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isNew ? 'Create New Store' : 'Add Branch'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Branch Banner icon
                const Text('Upload Branch Banner'),
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
                        child: _branchBanner == null
                            ? Icon(
                                Icons.add_photo_alternate_outlined,
                                size: size.height / 4.5,
                                color: Colors.white,
                              )
                            : Image.file(
                                File(_branchBanner!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                //Google map link
                const Text('Add Google Map Link'),
                SizedBox(
                  width: size.width,
                  child: TextField(
                    controller: _linkController,
                    decoration: kTexFieldDecoration.copyWith(
                        hintText: 'e.g https://goo.gl/maps/jYbidc8sDgUvzaoi8'),
                  ),
                ),

                //Branch description
                const SizedBox(height: 20),
                const Text('Describe The Location'),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'e.g Saudi Arabia, Dahran, KFUPM mall...',
                      fillColor: Color(0xfff9f9f9)),
                  minLines: 1,
                  maxLines: 3,
                ),
                // Next
                SizedBox(height: size.height / 6),
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
                      onPressed: () async {
                        if (_branchBanner == null ||
                            _linkController.value.text.isEmpty ||
                            _descriptionController.value.text.isEmpty) {
                          setState(() {
                            filled = false;
                          });
                        } else {
                          if (isNew) {
                            // if new, continue to set the points system
                            filled = true;
                            Map<String, dynamic> data = {
                              'name': storeData!['name'],
                              'description': storeData['description'],
                              'storeIcon': storeData['storeIcon'],
                              'storeBanner': storeData['storeBanner'],
                              'socialMedia': {
                                'instagram': storeData['socialMedia']
                                    ['instagram'],
                                'twitter': storeData['socialMedia']['twitter'],
                                'facebook': storeData['socialMedia']
                                    ['facebook'],
                                'snapchat': storeData['socialMedia']
                                    ['snapchat'],
                              },
                              'locations': [
                                {
                                  'branchBanner': '${_branchBanner?.path}',
                                  'location': _linkController.value.text,
                                  'description':
                                      _descriptionController.value.text,
                                },
                              ]
                            };
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ComputationPointsScreen(
                                      store: null, data: data, isNew: true)),
                            );
                          } else {
                            BusinessOwnerDatabase.addBranch({
                              'branchBanner': _branchBanner?.path,
                              'location': _linkController.value.text,
                              'description': _descriptionController.value.text,
                            }, widget.store!)
                                .whenComplete(() => Navigator.pop(context));
                          }
                        }
                      },
                      child: Text(
                        isNew ? "Next" : 'Add',
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
