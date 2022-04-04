class Store {
  final String _name;
  final String _description;
  final String? _id;
  final String _menuID;
  final Map<String, dynamic> _socialMedia;
  final List<dynamic> _locations;
  final String _storeIcon;
  final String _storeBanner;
  final double _rsEqualsTo;
  final String _plan;

  String get name => _name;

  Store(
    this._name,
    this._description,
    this._id,
    this._menuID,
    this._socialMedia,
    this._locations,
    this._storeIcon,
    this._storeBanner,
    this._rsEqualsTo,
    this._plan,
  );

  Map<String, Object?> toJson() => {
        'id': _id,
        'menuID': _menuID,
        'name': _name,
        'description': _description,
        'socialMedia': _socialMedia,
        'locations': _locations,
        'storeIcon': _storeIcon,
        'storeBanner': _storeBanner,
        'RsEqualsTo': _rsEqualsTo,
        'plan': _plan,
      };

  static Store fromJson(var map) => Store(
        map['name'] as String,
        map['description'] as String,
        map['id'] as String,
        map['menuID'] as String,
        map['socialMedia'] as Map<String, dynamic>,
        map['locations'] as List<dynamic>,
        map['storeIcon'] as String,
        map['storeBanner'] as String,
        map['RsEqualsTo'] as double,
        map['plan'] as String,
      );

  void addBranch(Map<String, String> data) {
    locations.add({
      'branchBanner': data['branchBanner'],
      'location': data['location'],
      'description': data['description'],
    });
  }

  List<dynamic> deleteBranch(index) {
    _locations.removeAt(index);
    return _locations;
  }

  String get description => _description;

  String get storeBanner => _storeBanner;

  String get storeIcon => _storeIcon;

  List<dynamic> get locations => _locations;

  Map<String, dynamic> get socialMedia => _socialMedia;

  String get menuID => _menuID;
  String get plan => _plan;

  double get rsEqualsTo => _rsEqualsTo;

  String? get id => _id;
}
