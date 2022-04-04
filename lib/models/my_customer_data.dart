import 'package:loyalty_wallet/models/card_data.dart';

class MyCustomerData extends CardData {
  final String _name;
  final String _phoneNumber;

  MyCustomerData(
    this._name,
    this._phoneNumber,
    String cardType,
    String id,
    String storeID,
    String storeName,
    double total,
    bool isNotificationOn,
    List<dynamic> transactions,
    double allTimes,
  ) : super(cardType, id, storeID, storeName, total, transactions,
            isNotificationOn, allTimes);

  static MyCustomerData fromJson(var card, var user) => MyCustomerData(
        '${user['firstName'] as String} ${user['lastName'] as String}',
        user['phoneNumber'] as String,
        card['cardType'] as String,
        card['id'] as String,
        card['storeID'] as String,
        card['storeName'] as String,
        double.parse(card['total'].toString()),
        card['isNotificationOn'] as bool,
        card['transactions'] as List<dynamic>,
        double.parse(card['allTimes'].toString()),
      );

  String get phoneNumber => _phoneNumber;
  String get name => _name;
}
