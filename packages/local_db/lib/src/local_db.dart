import 'dart:async';

import 'profile.dart';

class LocalDb {
  LocalDb._internal();
  static final LocalDb _instance = LocalDb._internal();
  factory LocalDb() => _instance;

  late final Profile _profile;
  final _dataSetChange = StreamController();

  Future<void> load() async {
    _profile = await Profile.local().load();
    _profile.backup = await Profile.shared().load();
  }

  Future<bool> save() => _profile.save();

  dynamic get(String key, dynamic defaultValue) =>
      _profile.get(key) ?? defaultValue;

  void set(String key, dynamic value) {
    dynamic oldValue = get(key, null);
    if (value != oldValue) {
      _dataSetChange.sink.add(key);
      _profile.set(key, value);
    }
  }

  void close() {
    _dataSetChange.close();
  }

  StreamController get dataSetChangeNotifier => _dataSetChange;
}
