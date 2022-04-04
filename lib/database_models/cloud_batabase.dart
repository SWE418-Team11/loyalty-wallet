import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loyalty_wallet/database_models/buisness_owner_database.dart';
import 'package:loyalty_wallet/models/card_data.dart';
import 'package:loyalty_wallet/models/special_offer_data.dart';
import 'package:loyalty_wallet/models/store.dart';
import '../models/menu.dart';
import '../models/user_data.dart';
import 'package:loyalty_wallet/admin/admin_report_reply_screen.dart';

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

  // Get The Stores
  static Future<List<Store>> getStores() async {
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
      'reportContent': reportContent,
      'ReplyMessage': '',
      'viewed': false,
    });
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
      await cardRef.update({
        'id': cardRef.id,
        'allTimes': 0,
        'userID': FirebaseAuth.instance.currentUser?.uid
      });
    }
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

  // Sign out from the database
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // delete a user with all their data from the database
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
      await BusinessOwnerDatabase.deleteAllOwnerStores();
    }
    await usersReference.doc(FirebaseAuth.instance.currentUser?.uid).delete();
    await signOut();
  }

  // get the a cards' points from the database
  static Future<CardData> getCardPoints(String? cardID) async {
    DocumentReference cardRef =
        FirebaseFirestore.instance.collection('Cards').doc(cardID);

    DocumentSnapshot<Object?> cardSnapshot = await cardRef.get();
    CardData card = CardData.fromJson(cardSnapshot);

    return card;
  }

  static Future<List<UserData>> getBO() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot usersSnapShot =
        await users.where('isBusinessOwner', isEqualTo: true).get();

    var docs = usersSnapShot.docs;

    return docs
        .map((e) => UserData.fromJson(e.data() as Map<String, Object?>))
        .toList();
  }

  static Future<List<UserData>> getReports2() async {
    CollectionReference reports =
        FirebaseFirestore.instance.collection('Reports');
    QuerySnapshot usersSnapShot = await reports.get();

    var docs = usersSnapShot.docs;

    return docs
        .map((e) => UserData.fromJson(e.data() as Map<String, Object?>))
        .toList();
  }

  static Future<void> sendReply(String reportID, String Report) async {
    CollectionReference reports =
        FirebaseFirestore.instance.collection('Reports');
    await FirebaseFirestore.instance
        .collection('Reports')
        .doc(reportID)
        .update({'ReplyMessage': Report});
  }

  static Future<List<SpecialOfferData>> getOffers() async {
    List<CardData> cards = await getCards();

    List<SpecialOfferData> specialOffers = [];

    CollectionReference so =
        FirebaseFirestore.instance.collection('SpecialOffers');

    for (int i = 0; i < cards.length; i++) {
      if (cards[i].isNotificationOn) {
        QuerySnapshot<Object?> fe =
            await so.where('storeID', isEqualTo: cards[i].storeID).get();
        var docs = fe.docs;
        if (docs.isNotEmpty) {
          specialOffers.addAll(docs
              .map((e) => SpecialOfferData.fromJSON(e, cards[i].storeName))
              .toList());
        }
      }
    }

    return specialOffers;
  }
}
