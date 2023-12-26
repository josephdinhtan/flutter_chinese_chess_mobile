import 'dart:async';

import 'local_db.dart';
import 'profile.dart';

class LocalDbItem {
  LocalDbItem(this._key, this._defaultValue);
  final _localDb = LocalDb();
  final String _key;
  final dynamic _defaultValue;
  final _dataSetChange = StreamController();

  dynamic get value => _localDb.get(_key, _defaultValue);

  set value(dynamic v) {
    _localDb.set(_key, v);
    dynamic oldValue = _localDb.get(_key, null);
    if (value != oldValue) {
      _dataSetChange.sink.add(_key);
      _localDb.set(_key, value);
    }
  }

  StreamController get dataSetChangeNotifier => _dataSetChange;
  Future<bool> save() => _localDb.save();
}
