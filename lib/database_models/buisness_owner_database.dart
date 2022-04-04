import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:loyalty_wallet/database_models/cloud_batabase.dart';
import 'package:loyalty_wallet/models/my_customer_data.dart';
import 'package:uuid/uuid.dart';

import '../models/card_data.dart';
import '../models/menu.dart';
import '../models/store.dart';

class BusinessOwnerDatabase {
  // Make The Customer Account A Business Account
  static Future<void> turnAccountToBusiness({required String id}) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .update({'isBusinessOwner': true});
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

  // Add new Cashier to a store
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

  // Remove cashier from a store
  static Future<void> removeCashier(
      String cashierPhone, String storeID, List<dynamic> cashlist) async {
    cashlist.remove(cashierPhone);
    await FirebaseFirestore.instance
        .collection('Owner')
        .doc(storeID)
        .update({'cashierList': cashlist});
  }

  // Delete Menu From A store
  static Future<void> deleteMenu({required String menuID}) async {
    CollectionReference menusReference =
        FirebaseFirestore.instance.collection('Menus');

    Menu menu = await CloudDatabase.getMenu(id: menuID);
    for (var product in menu.products) {
      await deleteImage(url: product['image']);
    }
    await menusReference.doc(menuID).delete();
  }

  // Delete An image from the database
  static Future<void> deleteImage({required String url}) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (e) {
      //Todo: catch the error
    }
  }

  // Delete all store cards from costumers
  static Future<void> deleteStoreCards({required String storeID}) async {
    CollectionReference cardsReference =
        FirebaseFirestore.instance.collection('Cards');

    QuerySnapshot<Object?> cardsSnapshot =
        await cardsReference.where('storeID', isEqualTo: storeID).get();
    for (var card in cardsSnapshot.docs) {
      await cardsReference.doc(card.id).delete();
    }
  }

  // Remove the the owner and the store from ownership
  static Future<void> deleteOwnership({required String storeID}) async {
    CollectionReference ownerReference =
        FirebaseFirestore.instance.collection('Owner');
    await ownerReference.doc(storeID).delete();
  }

  // delete all the stores for an owner
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

  static Future<void> deleteSTORE({required Store store}) async {
    // Stores Reference
    CollectionReference storesReference =
        FirebaseFirestore.instance.collection('Stores');
    //delete the menu
    await deleteMenu(menuID: store.menuID);
    //delete related images
    await deleteImage(url: store.storeIcon);
    await deleteImage(url: store.storeBanner);
    for (var branch in store.locations) {
      deleteImage(url: branch['branchBanner']);
    }
    //Delete Store Cards
    await deleteStoreCards(storeID: store.id!);
    //Delete Owner ship
    await deleteOwnership(storeID: store.id!);
    //Delete From Stores
    await storesReference.doc(store.id).delete();
  }

  // Set Points For Each RS
  static Future<void> setPoints(double value, String storeID) async {
    CollectionReference storesRef =
        FirebaseFirestore.instance.collection('Stores');
    storesRef.doc(storeID).update({'RsEqualsTo': value});
  }

  // change the plan for a store
  static Future<void> changePlanOfStore(
      {required String plan, required String id}) async {
    CollectionReference stores =
        FirebaseFirestore.instance.collection('Stores');
    await stores.doc(id).update({'plan': plan});
  }

  // add a banner request in database
  static Future<void> bannerRequest(
      Map<String, dynamic> rentBanner, String uid) async {
    rentBanner['isActive'] = true;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .update({'rentBanner': rentBanner});
  }

  //get all the cards of a store to use the user information
  static Future<List<CardData>> getStoreCustomers(
      {required String storeID}) async {
    List<QueryDocumentSnapshot<Object?>> cardDocs =
        await _getStoreCards(storeID: storeID);

    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('Users');

    List<MyCustomerData> customersData = [];

    for (int i = 0; i < cardDocs.length; i++) {
      QuerySnapshot<Object?> userDocs =
          await usersRef.where('id', isEqualTo: cardDocs[i]['userID']).get();

      customersData
          .add(MyCustomerData.fromJson(cardDocs[i], userDocs.docs.first));
    }

    return customersData;
  }

  // get all cards for a specific store
  static Future<List<QueryDocumentSnapshot<Object?>>> _getStoreCards(
      {required String storeID}) async {
    CollectionReference cardsRef =
        FirebaseFirestore.instance.collection('Cards');

    QuerySnapshot<Object?> cardsDocs =
        await cardsRef.where('storeID', isEqualTo: storeID).get();

    return cardsDocs.docs;
  }

  static Future<void> setOffer(String storeID, String offerDetails,
      String startDate, String endDate, double computation) async {
    CollectionReference offersRef =
        FirebaseFirestore.instance.collection('SpecialOffers');
    QuerySnapshot offers =
        await offersRef.where('storeID', isEqualTo: storeID).get();
    if (offers.docs.isEmpty) {
      await offersRef.add({
        'storeID': storeID,
        'offerDetails': offerDetails,
        'startDate': startDate,
        'endDate': endDate
      });
      setPoints(computation, storeID);
    } else {
      DocumentReference offerRef = offers.docs.first.reference;
      await offerRef.update({
        'offerDetails': offerDetails,
        'startDate': startDate,
        'endDate': endDate
      });
      setPoints(computation, storeID);
    }
  }

  static Future<void> deleteBranch(int index, Store store) async {
    CollectionReference storesRef =
        FirebaseFirestore.instance.collection('Stores');

    var branch = store.locations[index];
    await deleteImage(url: branch['branchBanner']);
    List<dynamic> branches = store.deleteBranch(index);
    print(branches.length);
    await storesRef.doc(store.id).update({'locations': branches});
  }
}
