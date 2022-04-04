import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report_data.dart';
import '../models/user_data.dart';

class AdminDatabase {
  // get all reports from database
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

  // ban a user in the database
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

  // unban a user in database
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

  // get all the baned users from database
  static Future<List<UserData>> getBanedUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot usersSnapShot =
        await users.where('isBand', isEqualTo: true).get();

    var docs = usersSnapShot.docs;

    return docs
        .map((e) => UserData.fromJson(e.data() as Map<String, Object?>))
        .toList();
  }

  static Future<void> updateReportStatus({required String id}) async {
    FirebaseFirestore.instance
        .collection('Reports')
        .doc(id)
        .update({'viewed': true});
  }
}
