import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loyalty_wallet/models/card_data.dart';
import '../widgets/card.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({Key? key, required this.card}) : super(key: key);
  final CardData card;

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  @override
  Widget build(BuildContext context) {
    CardData card = widget.card;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(card.storeName),
          centerTitle: true,
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Center(
            child: Column(
              children: [
                Cards(
                  isPressed: false,
                  index: 5,
                  type: card.cardType,
                  points: card.total,
                  stamps: card.total.toInt(),
                  id: card.id,
                  name: card.storeName,
                  onTap: () {},
                  update: () {},
                ),
                const SizedBox(
                  height: 25,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Transaction History',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: card.transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      var transaction = card.transactions[index];
                      Timestamp stamp = transaction['date'];
                      DateTime date = stamp.toDate();
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                transaction['amount'].toString(),
                                style: TextStyle(
                                    color: transaction['state'] == 'remove'
                                        ? Colors.red
                                        : Colors.green),
                              ),
                              Text(
                                '${date.day}/${date.month}/${date.year}',
                                style: TextStyle(
                                    color: transaction['state'] == 'remove'
                                        ? Colors.red
                                        : Colors.green),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.black,
                          ),
                        ],
                      );
                    },
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
