import 'package:flutter/material.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/special_offer_data.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: CloudDatabase.getOffers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SpecialOfferData> offers =
                  snapshot.data as List<SpecialOfferData>;

              return ListView.builder(
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(30),
                      padding: const EdgeInsets.all(15),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 0.5,
                            color: Colors.black12,
                            offset: Offset(0.5, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(offers[index].storeName),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(offers[index].startDate),
                              const Text('To'),
                              Text(offers[index].endDate),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Details: ${offers[index].offerDetails}',
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
