import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loyalty_wallet/models/card_data.dart';
import 'package:loyalty_wallet/models/store.dart';
import 'menu.dart';
import 'user_data.dart';
import 'package:uuid/uuid.dart';

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
  static Future<List<Store>> getOwnerStores() async {
    var ownerRef = FirebaseFirestore.instance.collection('Owners');
    var docs = await ownerRef
        .where('ownerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    var ownerDoc = docs.docs.first;

    var storeRef = FirebaseFirestore.instance.collection('Stores');
    var sdoct =
        await storeRef.where('storeID', isEqualTo: ownerDoc['storeID']).get();
    var queryDocs = sdoct.docs;
    return queryDocs
        .map((documentSnapshot) => Store.fromJson(documentSnapshot.data()))
        .toList();
  }

  static Future<bool> isTheOwner(String storeID) async {
    var ownerRef = FirebaseFirestore.instance.collection('Owner');
    var docs = await ownerRef.where('storeID', isEqualTo: storeID).get();
    print(docs.docs.first.data());
    if (docs.docs.first.data()['ownerID'] ==
        FirebaseAuth.instance.currentUser?.uid) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> editStoreData(Map<String, dynamic> data) async {
    FirebaseFirestore.instance.collection('Stores').doc('id').update(data);
  }

  static Future<void> addStore(Map<String, dynamic> storeData) async {
    var storesCollection = FirebaseFirestore.instance.collection('Stores');

    String storeBanner = await uploadImage(storeData['storeBanner']);
    String storeIcon = await uploadImage(storeData['storeIcon']);
    String branchBanner =
        await uploadImage(storeData['locations'][0]['branchBanner']);

    Map<String, dynamic> data = {
      'name': storeData['name'],
      'description': storeData['description'],
      'storeIcon': storeIcon,
      'storeBanner': storeBanner,
      'socialMedia': {
        'instagram': storeData['socialMedia']['instagram'],
        'twitter': storeData['socialMedia']['twitter'],
        'facebook': storeData['socialMedia']['facebook'],
        'snapchat': storeData['socialMedia']['snapchat'],
      },
      'locations': [
        {
          'branchBanner': branchBanner,
          'location': storeData['locations'][0]['location'],
          'description': storeData['locations'][0]['description'],
        }
      ]
    };

    DocumentReference docRef = await storesCollection.add(data);
    String menuId = await addNewMenu(docRef.id);
    await addNewOwner(docRef.id);

    Map<String, dynamic> dataEdited = {
      'name': storeData['name'],
      'id': docRef.id,
      'menuID': docRef.id,
      'description': storeData['description'],
      'storeIcon': storeIcon,
      'storeBanner': storeBanner,
      'socialMedia': {
        'instagram': storeData['socialMedia']['instagram'],
        'twitter': storeData['socialMedia']['twitter'],
        'facebook': storeData['socialMedia']['facebook'],
        'snapchat': storeData['socialMedia']['snapchat'],
      },
      'locations': [
        {
          'branchBanner': branchBanner,
          'location': storeData['locations'][0]['location'],
          'description': storeData['locations'][0]['description'],
        }
      ]
    };

    await docRef.update(dataEdited);
  }

  static Future<String> addNewMenu(String storeID) async {
    var menuCollection = FirebaseFirestore.instance.collection('Menus');
    var docRef = await menuCollection.add({'storeID': storeID, 'products': []});
    await docRef.update({'menuID': docRef.id});

    return docRef.id;
  }

  static Future<void> addNewOwner(String storeID) async {
    await FirebaseFirestore.instance.collection('Owner').doc(storeID).set({
      'ownerID': FirebaseAuth.instance.currentUser?.uid,
      'storeID': storeID
    });
  }

  static Future<String> uploadImage(String filePath) async {
    String extension = filePath.split('.').last;
    String storagePath = '${const Uuid().v4()}.$extension';

    var ref =
        await FirebaseStorage.instance.ref(storagePath).putFile(File(filePath));

    return await ref.ref.getDownloadURL();
  }

  static Future<void> addBranch(Map<String, dynamic> data, Store store) async {
    String branchBanner = await uploadImage(data['branchBanner']!);
    Store cStore = store;
    store.addBranch({
      'branchBanner': branchBanner,
      'location': data['location']!,
      'description': data['description']!,
    });

    FirebaseFirestore.instance
        .collection('Stores')
        .doc(store.id)
        .update(cStore.toJson());
  }

  static Future<List<CardData>> getCards() async {
    CollectionReference cardsRef =
        FirebaseFirestore.instance.collection('Cards');
    QuerySnapshot cardsQuerySnapshot = await cardsRef
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    List<QueryDocumentSnapshot> cardsQuery = cardsQuerySnapshot.docs;
    return cardsQuery
        .map((documentSnapshot) => CardData.fromJson(documentSnapshot.data()))
        .toList();
  }

  static Future<void> addCard(Map<String, dynamic> data) async {
    CollectionReference cardsRef =
        FirebaseFirestore.instance.collection('Cards');

    var card = await cardsRef
        .where('storeID', isEqualTo: data['storeID'])
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (card.docs.isEmpty) {
      var cardRef = await cardsRef.add(data);
      await cardRef.update(
          {'id': cardRef.id, 'userID': FirebaseAuth.instance.currentUser?.uid});
    }
  }

  static Future<void> setPoints(double value, String storeID) async {
    CollectionReference storesRef =
        FirebaseFirestore.instance.collection('Stores');
    storesRef.doc(storeID).update({'RsEqualsTo': value});
  }

  static Future<List<Store>> search(String suggestion) async {
    CollectionReference storesRef =
        FirebaseFirestore.instance.collection('Stores');
    QuerySnapshot query;

    if (suggestion.isNotEmpty) {
      query = await storesRef
          .where("name", isGreaterThanOrEqualTo: suggestion)
          .where("name", isLessThanOrEqualTo: "$suggestion\uf7ff")
          .get();
    } else {
      query = await storesRef.where("name", isEqualTo: suggestion).get();
    }

    List<QueryDocumentSnapshot> queryDocs = query.docs;
    print(queryDocs.length);
    return queryDocs
        .map((documentSnapshot) => Store.fromJson(documentSnapshot.data()))
        .toList();
  }
}
