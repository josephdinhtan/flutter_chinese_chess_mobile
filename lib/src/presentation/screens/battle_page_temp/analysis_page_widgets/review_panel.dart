import 'package:in_app_review/in_app_review.dart';

import '../../settings_screen/local_db/user_settings_db.dart';

class ReviewPanel {
  static Future<void> popRequest({bool force = false}) async {
    final InAppReview inAppReview = InAppReview.instance;

    DateTime? lastInvite = DateTime.tryParse(
      UserSettingsDb().lastReviewInvite,
    );

    if (lastInvite == null) {
      lastInvite = DateTime.now().subtract(const Duration(days: 28));
      UserSettingsDb().lastReviewInvite = lastInvite.toString();
      UserSettingsDb().save();
    }

    final timeOk = force ||
        DateTime.now().isAfter(lastInvite.add(const Duration(days: 30)));

    if (await inAppReview.isAvailable() && timeOk) {
      await inAppReview.requestReview();
      UserSettingsDb().lastReviewInvite = DateTime.now().toString();
      UserSettingsDb().save();
    }
  }
}
