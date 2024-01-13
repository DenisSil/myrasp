import 'package:localstore/localstore.dart';

class SettingsService {
  final Localstore _db = Localstore.instance;

  Future<Map<String, dynamic>> getSettings() async {
    var data = await _db.collection('settings').doc('123').get();
    if (data == null) {
      return {};
    }
    return data;
  }

  void saveSettings(String name, int group) {
    _db.collection('settings').doc('123').set({'name': name, 'group': group});
  }
}
