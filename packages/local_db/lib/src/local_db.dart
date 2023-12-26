import 'dart:async';

import 'profile.dart';

class LocalDb {
  LocalDb._();
  static LocalDb? _instance;
  factory LocalDb() {
    if (_instance == null) {
      _instance = LocalDb._();
      _instance!._load(); // load for first singleton
    }
    return _instance!;
  }

  late final Profile _profile;

  Future<void> _load() async {
    _profile = await Profile.local().load();
    _profile.backup = await Profile.shared().load();
  }

  Future<bool> save() => _profile.save();

  Profile get profile => _profile;

  dynamic get(String key, dynamic defaultValue) =>
      _profile.get(key) ?? defaultValue;

  void set(String key, dynamic value) {
    dynamic oldValue = get(key, null);
    if (value != oldValue) {
      _profile.set(key, value);
    }
  }
}
