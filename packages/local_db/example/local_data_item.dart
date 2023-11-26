import 'package:local_db/local_db.dart';

class LocalDataItem {
  final _localDb = LocalDb();
  final String _key;
  final dynamic _defaultValue;

  LocalDataItem(this._key, this._defaultValue);

  dynamic get value => _localDb.get(_key, _defaultValue);

  set value(dynamic v) => _localDb.set(_key, v);
  void save() => _localDb.save();
}
