import 'package:flutter/material.dart';
import 'package:loyalty_wallet/constants.dart';

import '../database_models/cloud_batabase.dart';
import '../models/store.dart';
import 'items.dart';

class StoresGrid extends StatefulWidget {
  const StoresGrid({
    Key? key,
  }) : super(key: key);

  @override
  State<StoresGrid> createState() => _StoresGridState();
}

class _StoresGridState extends State<StoresGrid> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: CloudDatabase.getStores(),
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
