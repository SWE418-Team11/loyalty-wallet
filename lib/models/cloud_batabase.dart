import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
}
