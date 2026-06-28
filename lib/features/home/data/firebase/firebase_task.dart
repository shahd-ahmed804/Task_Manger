import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskey_app/core/network/result_firebase.dart';
import '../../../auth/data/model/user_model.dart';
import '../model/task_model.dart';

abstract class FirebaseTask {
  static CollectionReference<TaskModel> get _getCollection {
    final tokenUser = FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance
        .collection(UserModel.collection)
        .withConverter(
          fromFirestore: (doc, _) => UserModel.fromJson(doc.data()!),
          toFirestore: (user, _) => user.toJson(),
        )
        .doc(tokenUser)
        .collection(TaskModel.collectionName)
        .withConverter<TaskModel>(
          fromFirestore: (doc, _) => TaskModel.fromJson(doc.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  static Future<ResultFB<void>> addTask(TaskModel task) async {
    try {
      final doc = _getCollection.doc();
      task.id = doc.id;
      await doc.set(task);
      return SuccessFB();
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }

  static Future<ResultFB<List<TaskModel>>> getTasks(DateTime date) async {
    final normalDate = DateTime(date.year, date.month, date.day);
    try {
      var querySnapshot = await _getCollection
          .where('selectedDate', isEqualTo: normalDate.millisecondsSinceEpoch)
          .orderBy('priorityIndex')
          .get();
      final listOfTasks = querySnapshot.docs
          .map<TaskModel>((doc) => doc.data())
          .toList();
      return SuccessFB(data: listOfTasks);
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }

  static Future<ResultFB<void>> updateIsCompleted(TaskModel task) async {
    try {
      final docRef = _getCollection.doc(task.id);
      await docRef.update({'isCompleted': task.isCompleted});

      return SuccessFB();
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }

  static Future<ResultFB<void>> deleteTask(TaskModel task) async {
    try {
      final docRef = _getCollection.doc(task.id);
      await docRef.delete();
      return SuccessFB();
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }
static Future<ResultFB<void>> updateTask(TaskModel task) async {
    try {
      if (task.id == null) {
        return ErrorFB(messageError: 'Task ID is missing for update.');
      }
      
      final docRef = _getCollection.doc(task.id);
      await docRef.update(task.toJson());

      return SuccessFB();
    } catch (e) {
      return ErrorFB(messageError: e.toString());
    }
  }
}
