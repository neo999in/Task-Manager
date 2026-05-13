import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _getUserTasksCollection() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    return _db.collection('users').doc(user.uid).collection('tasks');
  }

  Stream<List<Task>> getTasks() {
    return _getUserTasksCollection()
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  Future<void> addTask(Task task) {
    return _getUserTasksCollection().add(task.toMap());
  }

  Future<void> updateTask(Task task) {
    return _getUserTasksCollection().doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) {
    return _getUserTasksCollection().doc(taskId).delete();
  }

  Future<void> toggleTaskStatus(Task task) {
    return _getUserTasksCollection().doc(task.id).update({
      'isCompleted': !task.isCompleted,
    });
  }
}
