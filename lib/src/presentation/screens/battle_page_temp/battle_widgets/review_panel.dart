import 'package:in_app_review/in_app_review.dart';

import '../data_base/local_data.dart';

class ReviewPanel {
  //
  static Future<void> popRequest({bool force = false}) async {
    //
    final InAppReview inAppReview = InAppReview.instance;

    DateTime? lastInvite = DateTime.tryParse(
      LocalData().lastReviewInvite.value,
    );

    if (lastInvite == null) {
      lastInvite = DateTime.now().subtract(const Duration(days: 28));
      LocalData().lastReviewInvite.value = lastInvite.toString();
      LocalData().save();
    }

    final timeOk = force ||
        DateTime.now().isAfter(lastInvite.add(const Duration(days: 30)));

    if (await inAppReview.isAvailable() && timeOk) {
      await inAppReview.requestReview();
      LocalData().lastReviewInvite.value = DateTime.now().toString();
      LocalData().save();
    }
  }
}
