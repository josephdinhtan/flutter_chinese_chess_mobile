import 'package:local_db/src/local_db_item.dart';

class LocalData {
  LocalData._();
  static final LocalData _instance = LocalData._();
  factory LocalData() => _instance;

  late final LocalDbItem debugMode;
  late final LocalDbItem acceptedPrivacyPolicy;
  late final LocalDbItem cloudEngineEnabled;
  late final LocalDbItem thinkingArrowEnabled;
  late final LocalDbItem lastReviewInvite;

  Future<void> load() async {
    debugMode = LocalDbItem('debug_mode', false);
    acceptedPrivacyPolicy = LocalDbItem('pp_accepted', false);
    cloudEngineEnabled = LocalDbItem('cloud_engine_enabled', true);
    thinkingArrowEnabled = LocalDbItem('thinking_arrow_enabled', true);
    lastReviewInvite = LocalDbItem('last_review_invite', '');
  }

  Future<bool> save() => debugMode.save();
}
