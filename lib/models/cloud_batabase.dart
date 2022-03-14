import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loyalty_wallet/models/card_data.dart';
import 'package:loyalty_wallet/models/report_data.dart';
import 'package:loyalty_wallet/models/store.dart';
import 'menu.dart';
import 'user_data.dart';
import 'package:uuid/uuid.dart';

// This Class Does All The Functionality In The Cloud
class CloudDatabase {
  // Crete New User Account Document
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

  // Get The User's Document
  static Future<UserData?> getUser({required String id}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot user;

    user = await users.where('id', isEqualTo: id).get();
    if (user.size > 0) {
      return UserData.fromJson(user.docs.first.data() as Map<String, Object?>);
    }
    return null;
  }

  // Make The Customer Account A Business Account
  static Future<void> turnAccountToBusiness({required String id}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .update({'isBusinessOwner': true});
  }

  // Get The Stores
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

  // Get The Menu OF The Store
  static Future<Menu> getMenu({required String id}) async {
    CollectionReference menuRef =
        FirebaseFirestore.instance.collection('Menus');
    QuerySnapshot menu;

    menu = await menuRef.where('menuID', isEqualTo: id).get();
    return menu.docs.isNotEmpty
        ? Menu.fromJson(menu.docs.first.data())
        : Menu('0', '0', []);
  }

  // Sent The Report To An Admin
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

  // Get the stores for a specific business owner
  static Future<List<Store>> getOwnerStores() async {
    var ownerRef = FirebaseFirestore.instance.collection('Owner');
    var docs = await ownerRef
        .where('ownerID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    var ownerDocs = docs.docs;

    List<Store> stores = [];
    var storeRef = FirebaseFirestore.instance.collection('Stores');
    for (var ownerDoc in ownerDocs) {
      var sdoct =
          await storeRef.where('id', isEqualTo: ownerDoc['storeID']).get();
      var queryDocs = sdoct.docs;
      stores.addAll(queryDocs
          .map((documentSnapshot) => Store.fromJson(documentSnapshot.data()))
          .toList());
    }

    return stores;
  }

  // Check if the current store is belong to the business owner
  static Future<bool> isTheOwner(String storeID) async {
    var ownerRef = FirebaseFirestore.instance.collection('Owner');
    var docs = await ownerRef.where('storeID', isEqualTo: storeID).get();
    if (docs.docs.first.data()['ownerID'] ==
        FirebaseAuth.instance.currentUser?.uid) {
      return true;
    } else {
      return false;
    }
  }

  // Edit The data of a store // Not USED //
  static Future<void> editStoreData(Map<String, dynamic> data) async {
    FirebaseFirestore.instance.collection('Stores').doc('id').update(data);
  }

  // Add New Store
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
      ],
      'RsEqualsTo': storeData['RsEqualsTo'],
      'plan': storeData['plan'],
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
      ],
      'RsEqualsTo': storeData['RsEqualsTo'],
      'plan': storeData['plan'],
    };

    await docRef.update(dataEdited);
  }

  // Add New Menu To The New Store
  static Future<String> addNewMenu(String storeID) async {
    var menuCollection = FirebaseFirestore.instance.collection('Menus');
    var docRef = await menuCollection.add({'storeID': storeID, 'products': []});
    await docRef.update({'menuID': docRef.id});

    return docRef.id;
  }

  // Add New Owner When A new Store Is Added
  static Future<void> addNewOwner(String storeID) async {
    List<String> cashierList = [];
    await FirebaseFirestore.instance.collection('Owner').doc(storeID).set({
      'ownerID': FirebaseAuth.instance.currentUser?.uid,
      'storeID': storeID,
      'cashierList': cashierList
    });
  }

  // Upload An Image To FireStore
  static Future<String> uploadImage(String filePath) async {
    String extension = filePath.split('.').last;
    String storagePath = '${const Uuid().v4()}.$extension';

    var ref =
        await FirebaseStorage.instance.ref(storagePath).putFile(File(filePath));

    return await ref.ref.getDownloadURL();
  }

  // Add New Branch For A Store
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

  // Get The User's List Of Cards
  static Future<List<CardData>> getCards() async {
    CollectionReference cardsRef =
        FirebaseFirestore.instance.collection('Cards');

    QuerySnapshot<Object?> cardsQuerySnapshot = await cardsRef
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    List<QueryDocumentSnapshot<Object?>> cardsQuery = cardsQuerySnapshot.docs;

    return cardsQuery.map((event) => CardData.fromJson(event)).toList();
  }

  // Add New Card For The User
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

  // Set Points For Each RS
  static Future<void> setPoints(double value, String storeID) async {
    CollectionReference storesRef =
        FirebaseFirestore.instance.collection('Stores');
    storesRef.doc(storeID).update({'RsEqualsTo': value});
  }

  // Search For A Store By Name
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
    return queryDocs
        .map((documentSnapshot) => Store.fromJson(documentSnapshot.data()))
        .toList();
  }

  // Toggle The Notification
  static Future<bool> toggleNotification({required String storeID}) async {
    CollectionReference cardsRef =
        FirebaseFirestore.instance.collection('Cards');

    var card = await cardsRef
        .where('storeID', isEqualTo: storeID)
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();

    if (card.docs.isNotEmpty) {
      var cardRef = card.docs.first;
      bool notification = await cardRef.get('isNotificationOn') as bool;

      await cardsRef
          .doc(cardRef.id)
          .update({'isNotificationOn': !notification});
      return true;
    }
    return false;
  }

  // Delete Card from Database
  static Future<void> deleteCard({required String cardID}) async {
    await FirebaseFirestore.instance.collection('Cards').doc(cardID).delete();
  }

  static Future<void> addNewCashier(
      String cashierPhone, String storeID, List<dynamic> cashlist) async {
    if (!cashlist.contains(cashierPhone)) {
      cashlist.add(cashierPhone);

      await FirebaseFirestore.instance
          .collection('Owner')
          .doc(storeID)
          .update({'cashierList': cashlist});
    }
  }

  static Future<void> removeCashier(
      String cashierPhone, String storeID, List<dynamic> cashlist) async {
    cashlist.remove(cashierPhone);
    await FirebaseFirestore.instance
        .collection('Owner')
        .doc(storeID)
        .update({'cashierList': cashlist});
  }

  static Future<void> deleteMenu({required String menuID}) async {
    CollectionReference menusReference =
        FirebaseFirestore.instance.collection('Menus');

    Menu menu = await getMenu(id: menuID);
    for (var product in menu.products) {
      await deleteImage(url: product['image']);
    }
    await menusReference.doc(menuID).delete();
  }

  static Future<void> deleteImage({required String url}) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (e) {}
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteStoreCards({required String storeID}) async {
    CollectionReference cardsReference =
        FirebaseFirestore.instance.collection('Cards');

    QuerySnapshot<Object?> cardsSnapshot =
        await cardsReference.where('storeID', isEqualTo: storeID).get();
    for (var card in cardsSnapshot.docs) {
      await cardsReference.doc(card.id).delete();
    }
  }

  static Future<void> deleteOwnership({required String storeID}) async {
    CollectionReference ownerReference =
        FirebaseFirestore.instance.collection('Owner');
    await ownerReference.doc(storeID).delete();
  }

  static Future<void> deleteAllOwnerStores() async {
    CollectionReference storesReference =
        FirebaseFirestore.instance.collection('Stores');

    List<Store> stores = await getOwnerStores();
    for (Store store in stores) {
      //delete the menu
      await deleteMenu(menuID: store.menuID);
      //delete related images
      await deleteImage(url: store.storeIcon);
      await deleteImage(url: store.storeBanner);
      for (var branch in store.locations) {
        deleteImage(url: branch['branchBanner']);
      }
      await deleteStoreCards(storeID: store.id!);
      await deleteOwnership(storeID: store.id!);
      await storesReference.doc(store.id).delete();
    }
  }

  static Future<void> deleteUser(UserData user) async {
    CollectionReference cardsReference =
        FirebaseFirestore.instance.collection('Cards');
    CollectionReference usersReference =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot<Object?> cardsSnapshot =
        await cardsReference.where('userID', isEqualTo: user.id).get();
    //delete all cards
    for (var card in cardsSnapshot.docs) {
      await cardsReference.doc(card.id).delete();
    }

    //if business Owner delete all stores
    if (user.businessOwner) {
      await deleteAllOwnerStores();
    }
    await usersReference.doc(FirebaseAuth.instance.currentUser?.uid).delete();
    await signOut();
  }

  static Future<double> getPointWeight(String? storeID) async {
    DocumentReference storeRef =
        FirebaseFirestore.instance.collection('Stores').doc(storeID);

    DocumentSnapshot<Object?> storeSnapshot = await storeRef.get();

    double pointweight = Store.fromJson(storeSnapshot).rsEqualsTo;
    //store class needs to be modified to get RsEqualsto field

    return pointweight;
  }

  static Future<CardData> getCardPoints(String? cardID) async {
    DocumentReference cardRef =
        FirebaseFirestore.instance.collection('Cards').doc(cardID);

    DocumentSnapshot<Object?> cardSnapshot = await cardRef.get();
    CardData card = CardData.fromJson(cardSnapshot);

    return card;
  }

  static Future<void> setCardPoints(
      String? cardID, double points, List<dynamic> transactions) async {
    DocumentReference cardRef =
        FirebaseFirestore.instance.collection('Cards').doc(cardID);
    cardRef.update({'total': points, 'transactions': transactions});
  }

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

  static Future<void> changePlanOfStore(
      {required String plan, required String id}) async {
    CollectionReference stores =
        FirebaseFirestore.instance.collection('Stores');
    await stores.doc(id).update({'plan': plan});
  }

  static Future<List<ReportData>> getReports() async {
    //create class reportdata to map it
    CollectionReference reportsRef =
        FirebaseFirestore.instance.collection('Reports');

    QuerySnapshot<Object?> reportsQuerySnapshot = await reportsRef.get();
    //status is not included in the reports, it should be available
    // to determine the reports that have not be given a response yet
    //the report must include report title, and report id too which is not available in firebase
    var queryDocs = reportsQuerySnapshot.docs;

    return queryDocs
        .map((documentSnapshot) =>
            ReportData.fromJson(documentSnapshot.data(), documentSnapshot.id))
        .toList();
  }

  static Future<void> bannerRequest(
      Map<String, dynamic> rentBanner, String UID) async {
    rentBanner['isActive'] = true;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(UID)
        .update({'rentBanner': rentBanner});
  }

  static Future<void> banUser(String phoneNumber) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot usersSnapShot;

    usersSnapShot = await users
        .where('phoneNumber', isEqualTo: '+966${phoneNumber.substring(1)}')
        .get();
    if (usersSnapShot.size > 0) {
      UserData userID = UserData.fromJson(
          usersSnapShot.docs.first.data() as Map<String, Object?>);
      DocumentReference bandRef =
          FirebaseFirestore.instance.collection('Users').doc(userID.id);
      bandRef.update({'isBand': true});
    }
  }

  static Future<void> unBanUser(String phoneNumber) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot usersSnapShot;

    usersSnapShot =
        await users.where('phoneNumber', isEqualTo: phoneNumber).get();
    if (usersSnapShot.size > 0) {
      UserData userID = UserData.fromJson(
          usersSnapShot.docs.first.data() as Map<String, Object?>);
      DocumentReference bandRef =
          FirebaseFirestore.instance.collection('Users').doc(userID.id);
      bandRef.update({'isBand': false});
    }
  }

  static Future<List<UserData>> getBanedUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot usersSnapShot =
        await users.where('isBand', isEqualTo: true).get();

    var docs = usersSnapShot.docs;

    return docs
        .map((e) => UserData.fromJson(e.data() as Map<String, Object?>))
        .toList();
  }
}
