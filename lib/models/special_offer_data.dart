class SpecialOfferData {
  final String _startDate;
  final String _endDate;
  final String _offerDetails;
  final String _storeID;
  final String _storeName;

  SpecialOfferData(this._startDate, this._endDate, this._offerDetails,
      this._storeID, this._storeName);

  static SpecialOfferData fromJSON(var map, String storeName) =>
      SpecialOfferData(map['startDate'] as String, map['endDate'] as String,
          map['offerDetails'] as String, map['storeID'] as String, storeName);
  String get endDate => _endDate;

  String get offerDetails => _offerDetails;

  String get startDate => _startDate;

  String get storeID => _storeID;

  String get storeName => _storeName;
}
