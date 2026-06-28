import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskey_app/core/network/result_firebase.dart';

import '../model/user_model.dart';

class FBAUser {
  static CollectionReference<UserModel> get _getCollection {
    return FirebaseFirestore.instance
        .collection(UserModel.collection)
        .withConverter<UserModel>(
          fromFirestore: (snap, _) => UserModel.fromJson(snap.data()!),
          toFirestore: (userModel, _) => userModel.toJson(),
        );
  }

  static Future<void> addUser(UserModel user) async {
    try {
      await _getCollection.doc(user.id).set(user);
    } catch (e) {
      throw "error from added user $e";
    }
  }

  static Future<ResultFB<UserModel>> registerUser(UserModel user) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email ?? ' ',
            password: user.password ?? '',
          );
      user.id = credential.user?.uid;
      await _getCollection.doc(user.id).set(user);
      return SuccessFB(data: user);
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }

  static Future<ResultFB<UserCredential>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return SuccessFB(data: userCredential);
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }

static Future<ResultFB<String>> getUserName(String uid) async {
    try {
      final userDoc = await _getCollection.doc(uid).get();

      if (userDoc.exists) {
        final userModel = userDoc.data();
        if (userModel?.name != null) {
          return SuccessFB(data: userModel!.name!);
        } else {
          return ErrorFB(messageError: 'اسم المستخدم غير موجود.');
        }
      } else {
        return ErrorFB(messageError: 'بيانات المستخدم غير موجودة في قاعدة البيانات.');
      }
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }
  static Future<ResultFB<UserModel>> getUserData(String uid) async {
    try {
      final userDoc = await _getCollection.doc(uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        return SuccessFB(data: userDoc.data()!);
      } else {
        return ErrorFB(
          messageError: 'بيانات المستخدم غير موجودة.',
        );
      }
    } catch (e) {
      return ErrorFB(
        messageError: e.toString(),
      );
    }
  }
}
