import 'package:flutter/material.dart';
import 'package:loyalty_wallet/models/cloud_batabase.dart';
import 'package:loyalty_wallet/widgets/stores_grid.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 50),
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: (() {}),
                  icon: const Icon(Icons.search),
                  label: const Text("Search"),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: (() {}),
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filter"),
                ),
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: GridView.count(
        //     childAspectRatio: 1.0,
        //     crossAxisCount: 2,
        //     crossAxisSpacing: 5,
        //     mainAxisSpacing: 15,
        //     shrinkWrap: true,
        //     physics: const BouncingScrollPhysics(),
        //     children: List.generate(20, (index) {
        //       return const Items();
        //     }),
        //   ),
        // ),
        StoresGrid(),
      ],
    );
  }
}
