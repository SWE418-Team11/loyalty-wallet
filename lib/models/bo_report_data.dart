class BOReportData {
  final String _reportContent;
  final String _reportType;
  final String _storeId;
  final String _storeName;
  final String _userID;
  final String _reportID;

  BOReportData(this._reportContent, this._reportType, this._storeId,
      this._storeName, this._userID, this._reportID);

  static BOReportData fromJson(var map, String reportID) => BOReportData(
      map['reportContent'] as String,
      map['reportType'] as String,
      map['storeID'] as String,
      map['storeName'] as String,
      map['userID'] as String,
      reportID);

  String get reportType => _reportType;

  String get reportID => _reportID;

  String get userID => _userID;

  String get storeName => _storeName;

  String get storeId => _storeId;

  String get reportContent => _reportContent;
}
