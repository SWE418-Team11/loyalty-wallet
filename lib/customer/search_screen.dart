import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';

import '../widgets/search_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchFor = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                child: TextField(
                  decoration: kTexFieldDecoration.copyWith(hintText: 'search'),
                  onChanged: (value) {
                    setState(() {
                      searchFor = value;
                    });
                  },
                ),
              ),
              SearchGrid(searchFore: searchFor),
            ],
          ),
        ),
      ),
    );
  }
}
