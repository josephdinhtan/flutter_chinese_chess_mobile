import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class Profile {
  //
  static const _kLocalFile = 'app-local-profile.json';
  static const _kSharedFile = 'app-default-profile.json';

  final String fileName;
  Profile._create(this.fileName);

  static final _local = Profile._create(_kLocalFile);
  static final _shared = Profile._create(_kSharedFile);

  factory Profile.local() => _local;
  factory Profile.shared() => _shared;

  File? _file;
  bool _loadOk = false;
  Map<String, dynamic> _values = {};

  // When a configuration item is not found in the current configuration,
  // you can find the configuration item from this backup configuration item.
  Profile? backup;

  operator [](String key) => _values[key] ?? backup?[key];

  operator []=(String key, dynamic value) => _values[key] = value;

  Future<Profile> load() async {
    //
    if (!_loadOk) {
      //
      final docDir = await getApplicationDocumentsDirectory();
      _file = File('${docDir.path}/$fileName');

      try {
        final contents = await _file!.readAsString();
        _values = jsonDecode(contents);
        _loadOk = true;
      } catch (e) {
        if (kDebugMode) {
          print('Profile.prepare: $e');
        }
      }
    }

    return this;
  }

  void update(Map<String, dynamic> values) {
    for (final key in values.keys) {
      _values[key] = values[key];
    }
  }

  dynamic get(String key) => _values[key];

  set(String key, value) => _values[key] = value;

  Future<bool> save() async {
    if (_file == null || _values.isEmpty) return false;

    _file!.create(recursive: true);

    try {
      final contents = jsonEncode(_values);
      await _file!.writeAsString(contents);
    } catch (e) {
      if (kDebugMode) {
        print('Profile.prepare: $e');
      }
      return false;
    }

    return true;
  }
}
