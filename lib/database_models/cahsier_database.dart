import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/store.dart';

class CashierDatabase {
  // check if the user is a cashier for a store
  static Future<String> isCashier() async {
    CollectionReference ownerReference =
        FirebaseFirestore.instance.collection('Owner');
    String? number = FirebaseAuth.instance.currentUser?.phoneNumber;
    number = number?.substring(4);
    number = '0$number';

    QuerySnapshot<Object?> cashiers =
        await ownerReference.where('cashierList', arrayContains: number).get();
    QuerySnapshot<Object?> owners = await ownerReference
        .where('ownerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    dynamic data;
    if (cashiers.size > 0) {
      data = cashiers.docs.first.data() as Map<String, dynamic>;
      return data['storeID'];
    }
    if (owners.size > 0) {
      data = owners.docs.first.data() as Map<String, dynamic>;
      return data['storeID'];
    }

    return 'empty';
  }

  // get the points wight for a store
  static Future<double> getPointWeight(String? storeID) async {
    DocumentReference storeRef =
        FirebaseFirestore.instance.collection('Stores').doc(storeID);

    DocumentSnapshot<Object?> storeSnapshot = await storeRef.get();

    double pointweight = Store.fromJson(storeSnapshot).rsEqualsTo;
    //store class needs to be modified to get RsEqualsto field

    return pointweight;
  }

  // add/remove point from a card
  static Future<void> setCardPoints(
      String? cardID, double points, List<dynamic> transactions) async {
    DocumentReference cardRef =
        FirebaseFirestore.instance.collection('Cards').doc(cardID);
    cardRef.update({'total': points, 'transactions': transactions});
  }
}
