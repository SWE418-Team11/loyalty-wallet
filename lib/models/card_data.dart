import 'package:flutter/cupertino.dart';

class CardData {
  final String cardType;
  final String id;
  final String storeID;
  final String storeName;
  final double total;
  final bool isNotificationOn;
  final List<dynamic> transactions;

  CardData(this.cardType, this.id, this.storeID, this.storeName, this.total,
      this.transactions, this.isNotificationOn);

  Map<String, Object?> toJson() => {
        'cardType': cardType,
        'id': id,
        'storeID': storeID,
        'storeName': storeName,
        'total': total,
        'transactions': transactions,
        'isNotificationOn': isNotificationOn
      };

  static CardData fromJson(var map) => CardData(
      map['cardType'] as String,
      map['id'] as String,
      map['storeID'] as String,
      map['storeName'] as String,
      double.parse(map['total'].toString()),
      map['transactions'] as List<dynamic>,
      map['isNotificationOn'] as bool);
}
