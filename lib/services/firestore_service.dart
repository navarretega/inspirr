import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreService {
  FirestoreService._();

  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.documents
        .map(
          (snapshot) => builder(snapshot.data),
        )
        .toList());
  }

  Future<Map> getUserData(String uid) async {
    final document =
        await Firestore.instance.collection('/users').document(uid).get();
    return document.data;
  }

  Future<Map> getAnonData(String did) async {
    final document =
        await Firestore.instance.collection('/deviceIds').document(did).get();
    return document.data;
  }
}
