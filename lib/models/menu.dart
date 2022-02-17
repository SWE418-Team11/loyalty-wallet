class Menu {
  final String _storeID;
  final String _id;
  final List<dynamic> _products;

  Menu(this._storeID, this._id, this._products);

  List<dynamic> get products => _products;
  String get storeID => _storeID;
  String get id => _id;

  static Menu fromJson(var map) => Menu(
        map['storeID'] as String,
        map['menuID'] as String,
        map['products'] as List<dynamic>,
      );
}
