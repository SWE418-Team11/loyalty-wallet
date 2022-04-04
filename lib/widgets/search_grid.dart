import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';

import '../database_models/cloud_batabase.dart';
import '../models/store.dart';
import 'items.dart';

class SearchGrid extends StatefulWidget {
  const SearchGrid({
    required this.searchFore,
    Key? key,
  }) : super(key: key);
  final String searchFore;
  @override
  State<SearchGrid> createState() => _SearchGridState();
}

class _SearchGridState extends State<SearchGrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: CloudDatabase.search(widget.searchFore),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Store> stores = snapshot.data as List<Store>;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.0,
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 15,
                  mainAxisExtent: MediaQuery.of(context).size.width / 2.5,
                ),
                itemCount: stores.length,
                itemBuilder: (BuildContext context, int index) {
                  return Items(
                    store: stores[index],
                  );
                },
              ),
            );
          } else {
            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
          }
          return const Center(
            child: CircularProgressIndicator(
              color: kMainColor,
            ),
          );
        },
      ),
    );
  }
}
