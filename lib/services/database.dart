import 'package:flutter/foundation.dart';
import 'package:inspirr/models/textAI.dart';
import 'package:inspirr/services/api_path.dart';
import 'package:inspirr/services/firestore_service.dart';

abstract class Database {
  Future<Map> getUserData();
  Future<Map> getAnonData();
  Future<void> setUserFields(int cnt, bool val);
  Future<void> setAnonFields(int cnt);
  Future<void> createText(TextAI text);
  Stream<List<TextAI>> textsStream();
}

String getTextId() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;
  final String did;

  FirestoreDatabase({@required this.uid, this.did}) : assert(uid != null);

  final _service = FirestoreService.instance;

  Future<Map> getAnonData() async {
    final Map data = await _service.getAnonData(did);
    if (data == null) {
      await setAnonFields(0);
      return {'count': 0};
    } else {
      return {'count': data['count']};
    }
  }

  Future<void> setAnonFields(int cnt) async {
    await _service.setData(
        path: APIPath.anons(did),
        data: {
          'count': cnt
        }
    );
  }

  Future<Map> getUserData() async {
    final Map data = await _service.getUserData(uid);
    if (data == null) {
      await setUserFields(0, false);
      return {'count': 0, 'paidUser': false};
    } else {
      return {'count': data['count'], 'paidUser': data['paidUser']};
    }
  }

  Future<void> setUserFields(int cnt, bool val) async {
    await _service.setData(
        path: APIPath.users(uid),
        data: {
          'count': cnt,
          'paidUser': val,
        }
    );
  }

  Future<void> createText(TextAI text) async {
    await _service.setData(
      path: APIPath.text(uid, getTextId()),
      data: text.toMap(),
    );
  }

  Stream<List<TextAI>> textsStream() => _service.collectionStream(
      path: APIPath.texts(uid), builder: (data) => TextAI.fromMap(data));

}
