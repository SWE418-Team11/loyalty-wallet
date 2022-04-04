import 'package:flutter/material.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/widgets/card.dart';

import 'card_details_screen.dart';
import 'package:loyalty_wallet/models/card_data.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key, required this.isPressed, required this.update})
      : super(key: key);
  final VoidCallback update;
  final bool isPressed;
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    bool isPressed = widget.isPressed;

    return FutureBuilder(
      future: CloudDatabase.getCards(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CardData> cards = snapshot.data as List<CardData>;
          return ListView.separated(
            itemCount: cards.length,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 20,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              CardData card = cards[index];
              return Center(
                child: Cards(
                  isPressed: isPressed,
                  index: index,
                  type: card.cardType,
                  points: card.total,
                  stamps: card.total.toInt(),
                  name: card.storeName,
                  id: card.id,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CardDetails(card: card);
                        },
                      ),
                    );
                  },
                  update: () {
                    setState(() {
                      CloudDatabase.deleteCard(cardID: card.id);
                    });
                  },
                ),
              );
            },
          );
        } else {
          print(snapshot.error);
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
