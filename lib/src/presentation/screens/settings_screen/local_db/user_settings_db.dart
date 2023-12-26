import 'package:local_db/local_db.dart';

class UserSettingsDb {
  UserSettingsDb._();
  static final UserSettingsDb _instance = UserSettingsDb._();
  factory UserSettingsDb() => _instance;

  late final LocalDbItem _debugMode;
  late final LocalDbItem _acceptedPrivacyPolicy;
  late final LocalDbItem _cloudEngineEnabled;
  late final LocalDbItem _thinkingArrowEnabled;
  late final LocalDbItem _lastReviewInvite;
  late final LocalDbItem _showAdDate;
  late final LocalDbItem _showAdTimes;
  late final LocalDbItem _uiFont;
  late final LocalDbItem _bgmEnabled;
  late final LocalDbItem _toneEnabled;
  late final LocalDbItem _highContrast;

  bool get debugMode => _debugMode.value;
  set debugMode(bool value) => _debugMode.value = value;

  bool get acceptedPrivacyPolicy => _acceptedPrivacyPolicy.value;
  set acceptedPrivacyPolicy(bool value) => _acceptedPrivacyPolicy.value = value;

  bool get cloudEngineEnabled => _cloudEngineEnabled.value;
  set cloudEngineEnabled(bool value) => _cloudEngineEnabled.value = value;

  bool get thinkingArrowEnabled => _thinkingArrowEnabled.value;
  set thinkingArrowEnabled(bool value) => _thinkingArrowEnabled.value = value;

  String get lastReviewInvite => _lastReviewInvite.value;
  set lastReviewInvite(String value) => _lastReviewInvite.value = value;

  String get showAdDate => _showAdDate.value;
  set showAdDate(String value) => _showAdDate.value = value;

  int get showAdTimes => _showAdTimes.value;
  set showAdTimes(int value) => _showAdTimes.value = value;

  String get uiFont => _uiFont.value;
  set uiFont(String value) => _uiFont.value = value;

  bool get bgmEnabled => _bgmEnabled.value;
  set bgmEnabled(bool value) => _bgmEnabled.value = value;

  bool get toneEnabled => _toneEnabled.value;
  set toneEnabled(bool value) => _toneEnabled.value = value;

  bool get highContrast => _highContrast.value;
  set highContrast(bool value) => _highContrast.value = value;

  Future<void> load() async {
    _debugMode = LocalDbItem('debug_mode', false);
    _acceptedPrivacyPolicy = LocalDbItem('pp_accepted', false);
    _cloudEngineEnabled = LocalDbItem('cloud_engine_enabled', true);
    _thinkingArrowEnabled = LocalDbItem('thinking_arrow_enabled', true);
    _lastReviewInvite = LocalDbItem('last_review_invite', '');
    _showAdDate = LocalDbItem('show_ad_date', '');
    _showAdTimes = LocalDbItem('show_ad_times', 0);
    _uiFont = LocalDbItem('ui_font', '');
    _bgmEnabled = LocalDbItem('bgm_enabled', false);
    _toneEnabled = LocalDbItem('tone_enabled', true);
    _highContrast = LocalDbItem('high_contrast', false);
  }

  Future<bool> save() => _debugMode.save();
}
