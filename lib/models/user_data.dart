import 'package:flutter/cupertino.dart';

class UserData with ChangeNotifier {
  String? _id;
  final String _firstName;
  final String _lastName;
  final String _phoneNumber;
  final bool _isBusinessOwner;
  final bool _isBand;
  final bool _isAdmin;
  final bool _isCashier;

  UserData(this._id, this._firstName, this._lastName, this._phoneNumber,
      this._isBusinessOwner, this._isBand, this._isAdmin, this._isCashier);

  Map<String, Object?> toJson() => {
        'id': _id,
        'firstName': _firstName,
        'lastName': _lastName,
        'phoneNumber': _phoneNumber,
        'isAdmin': _isAdmin,
        'isBusinessOwner': _isBusinessOwner,
        'isCashier': _isCashier,
        'isBand': _isBand,
      };

  static UserData fromJson(Map<String, Object?> map) => UserData(
        map['id'] as String,
        map['firstName'] as String,
        map['lastName'] as String,
        map['phoneNumber'] as String,
        map['isBusinessOwner'] as bool,
        map['isBand'] as bool,
        map['isAdmin'] as bool,
        map['isCashier'] as bool,
      );

  UserData copy({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? isBusinessOwner,
    bool? isBand,
    bool? isAdmin,
    bool? isCashier,
  }) =>
      UserData(
          id ?? _id,
          firstName ?? _firstName,
          lastName ?? _lastName,
          phoneNumber ?? _phoneNumber,
          isBusinessOwner ?? _isBusinessOwner,
          isBand ?? _isBand,
          isAdmin ?? _isAdmin,
          isCashier ?? _isCashier);

  set id(String value) {
    _id = value;
  }

  String get id => _id!;

  String get phoneNumber => _phoneNumber;

  bool get cashier => _isCashier;

  bool get admin => _isAdmin;

  bool get band => _isBand;

  bool get businessOwner => _isBusinessOwner;

  String get lastName => _lastName;
  String get firstName => _firstName;
}
