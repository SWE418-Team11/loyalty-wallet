import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loyalty_wallet/models/store.dart';
import 'menu.dart';
import 'user_data.dart';

class CloudDatabase {
  static Future<UserData> createAccount({
    required String accountType,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    final String? userID =
        FirebaseAuth.instance.currentUser?.uid; // get userID from firebase

    UserData? user = await getUser(id: userID!); //get user if exist

    //if user doesn't exist, create new account
    if (user == null) {
      UserData newUser = UserData(userID, firstName, lastName, phoneNumber,
          accountType == 'Business' ? true : false, false, false, false);
      //Create an account in firebase using the current user information
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .set(newUser.toJson());

      return newUser;
    } else {
      return user;
    }
  }

  static Future<UserData?> getUser({required String id}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot user;

    user = await users.where('id', isEqualTo: id).get();
    if (user.size > 0) {
      return UserData.fromJson(user.docs.first.data() as Map<String, Object?>);
    }
    return null;
  }

  static Future<void> turnAccountToBusiness({required String id}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .update({'isBusinessOwner': true});
  }

  // List<Store>
  static Future<List<Store>> getStores() async {
    List<Store> stores = [];
    CollectionReference storesRef =
        FirebaseFirestore.instance.collection('Stores');
    QuerySnapshot query = await storesRef.get();
    List<QueryDocumentSnapshot> queryDocs = query.docs;

    return queryDocs
        .map((documentSnapshot) => Store.fromJson(documentSnapshot.data()))
        .toList();
  }

  static Future<Menu> getMenu({required String id}) async {
    CollectionReference menuRef =
        FirebaseFirestore.instance.collection('Menus');
    QuerySnapshot menu;

    menu = await menuRef.where('menuID', isEqualTo: id).get();
    return Menu.fromJson(menu.docs.first.data());
  }

  static Future<void> reportToAdmin(
      {required Store store,
      required String reportType,
      required String reportContent}) async {
    CollectionReference reportsRef =
        FirebaseFirestore.instance.collection('Reports');
    reportsRef.add({
      'userID': FirebaseAuth.instance.currentUser?.uid,
      'storeID': store.id,
      'storeName': store.name,
      'reportType': reportType,
      'reportContent': reportContent
    });
  }

//get owner Stores
  static Future<Map<String, dynamic>> getStore() async {
    var ownerRef = FirebaseFirestore.instance.collection('Owners');
    var docs = await ownerRef
        .where('ownerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    var ownerDoc = docs.docs.first;

    var storeRef = FirebaseFirestore.instance.collection('Stores');
    var sdoct =
        await storeRef.where('storeID', isEqualTo: ownerDoc['storeID']).get();
    var store = sdoct.docs.first.data();
    return store;
  }

  static Future<void> editStoreData(Map<String, dynamic> data) async {
    FirebaseFirestore.instance.collection('Stores').doc('id').update(data);
  }
}
