import 'package:flutter/foundation.dart';
import 'package:inspirr/models/textAI.dart';
import 'package:inspirr/services/api_path.dart';
import 'package:inspirr/services/firestore_service.dart';

abstract class Database {
  Future<Map> getUserData(bool isAnon);
  Future<void> setUserFields(bool isAnon, int freeTexts, int paidTexts);
  Future<void> createText(TextAI text);
  Stream<List<TextAI>> textsStream();
}

String getTextId() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  final String uid;
  final String did;

  FirestoreDatabase({@required this.uid, this.did}) : assert(uid != null);

  final _service = FirestoreService.instance;

  Future<Map> getUserData(bool isAnon) async {
    if (isAnon) {
      final Map data = await _service.getAnonData(did);
      if (data == null) {
        await setUserFields(true, 25, 0);
        return {'freeTexts': 25, 'paidTexts': 0};
      } else {
        return {'freeTexts': data['freeTexts'], 'paidTexts': data['paidTexts']};
      }
    } else {
      final Map data = await _service.getUserData(uid);
      if (data == null) {
        await setUserFields(false, 25, 0);
        return {'freeTexts': 25, 'paidTexts': 0};
      } else {
        return {'freeTexts': data['freeTexts'], 'paidTexts': data['paidTexts']};
      }
    }
  }

  Future<void> setUserFields(bool isAnon, int freeTexts, int paidTexts) async {
    String path;
    if (isAnon) {
      path = APIPath.anons(did);
    } else {
      path = APIPath.users(uid);
    }
    await _service.setData(
        path: path,
        data: {
          'freeTexts': freeTexts,
          'paidTexts': paidTexts,
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
