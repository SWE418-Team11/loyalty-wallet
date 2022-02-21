class CardData {
  final String cardType;
  final String id;
  final String storeID;
  final String storeName;
  final double total;
  final List<dynamic> transactions;

  CardData(this.cardType, this.id, this.storeID, this.storeName, this.total,
      this.transactions);

  Map<String, Object?> toJson() => {
        'cardType': cardType,
        'id': id,
        'storeID': storeID,
        'storeName': storeName,
        'total': total,
        'transactions': transactions,
      };

  static CardData fromJson(var map) => CardData(
        map['cardType'] as String,
        map['id'] as String,
        map['storeID'] as String,
        map['storeName'] as String,
        double.parse(map['total'].toString()),
        map['transactions'] as List<dynamic>,
      );
}
