import 'package:hive_flutter/hive_flutter.dart';

class DBClient {
  static late Box settingsBox;
  static late Box itemsBox;

  static init() async {
    await Hive.initFlutter();
    settingsBox = await Hive.openBox('settings');
    itemsBox = await Hive.openBox('items');
  }
}

class Settings {
  static getName() {
    return DBClient.settingsBox.get('name', defaultValue: "Calvo");
  }

  static setName(String name) {
    DBClient.settingsBox.put('name', name);
  }
}
