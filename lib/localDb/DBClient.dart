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

  static isRemember() {
    return DBClient.settingsBox.get('remember', defaultValue: false);
  }

  static setRemember(bool remember) {
    DBClient.settingsBox.put('remember', remember);
  }

  static getRememberedPassword() {
    return DBClient.settingsBox.get('password', defaultValue: "");
  }

  static setRememberedPassword(String password) {
    DBClient.settingsBox.put('password', password);
  }
}
